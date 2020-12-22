#!/usr/bin/perl
use strict;
use JSON::XS;

sub so{ print join(" ",@_),"\n"; system @_; }
sub sy{ print join(" ",@_),"\n"; system @_ and die $?; }

my $sync_commit = sub{
    my ($parent_dir,$name,$ato) = @_;
    my $dir = "$parent_dir/$name";
    my ($full_repo,$to) = $ato=~/^(.*):([^:]+)$/ ? ($1,$2) : die;
    $full_repo and !-e $dir and sy("git clone $full_repo $dir");
    #
    my $no_sync = "$dir/c4gen-git-no-sync";
    my $git = "cd $dir && git";
    if(-e $no_sync){
        print "%%%% $dir IS OUT OF SYNC %%%%\nfix and rm $no_sync\n";
        return;
    }
    my $status = `$git status --porcelain`;
    if($status=~/\S/){
        print "%%%% $dir GOES OUT OF SYNC %%%%\n$status";
        sy("> $no_sync");
        return;
    }
    my $from = `$git rev-parse HEAD`=~/^\s*([0-9a-f]+)\s*$/ ? $1 : die;
    if($to ne substr $from, 0, length $to){
        print "%%%% $dir GOES $to %%%%\n";
        sy("$git fetch");
        sy("$git checkout $to");
    }
};

my $chk_distinct = sub{ my %was; $was{$_}++ and die "non-single ($_)" for @_; };
my ($op,$from,$to) = map{my $i=$_;sub{$_[0][$i]||die}} 0..2;

my $iter; $iter = sub{
    my ($parent_dir,$left,$done) = @_;
    my @rels = grep{ref && &$op($_) eq "C4REL"} 
        map{@{JSON::XS->new->decode(scalar `cat $_`)}} 
        grep{-e} map{"$parent_dir/$_/c4dep.main.json"} @$left;
    @rels || return;
    my @names = map{&$from($_)} @rels;
    my @will_done = (@$left,@$done);
    &$chk_distinct(@names,@will_done);
    &$sync_commit($parent_dir,&$from($_),&$to($_)) for @rels;
    &$iter($parent_dir,\@names,\@will_done);
};

my $relink = sub{
    my($f,$l)=@_;
    if($f ne readlink $l){ unlink $l; symlink $f, $l or die $!, $f, $l }
};

do{
    my $parent_dir = $ENV{C4REPO_PARENT_DIR} || die "no C4REPO_PARENT_DIR";
    my $extra_dir = $ENV{C4REPO_ALIAS_DIR};
    my($name,$ato)=@ARGV;
    $name || die "no name arg";
    $ato and &$sync_commit($parent_dir,$name,$ato);
    &$iter($parent_dir,[$name],[]);
    if($extra_dir){
        &$relink($_,$extra_dir.substr $_,length $parent_dir) for <$parent_dir/*>
    }
};
