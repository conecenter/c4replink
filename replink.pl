#!/usr/bin/perl
use strict;

sub sy{ print join(" ",@_),"\n"; system @_ and die $?; }
my $get_parent = sub{ my($p)=@_; $p=~m{(.*)/[^/]+$} ? "$1" : die };

my $sync_commit = sub{
    my ($dir,$full_repo,$to) = @_;
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

my $iter; $iter = sub{
    my ($p_conf_path) = @_;
    for(map{`cat $_`} grep{-e} $p_conf_path){
        my ($c_rel_conf_path,$repo,$to) = /^C4REL\s+(\S+)\s+(\S+)\s+(\S+)\s*$/ ? 
            ($1,$2,$3) : !/\S/ || /^#/ ? next : die $_; 
        my $c_conf_path =  &$get_parent($p_conf_path)."/$c_rel_conf_path";
        &$sync_commit(&$get_parent($c_conf_path),$repo,$to);
        &$iter($c_conf_path);
    }
};

&$iter($ENV{C4REPO_MAIN_CONF} || die "no C4REPO_MAIN_CONF");
