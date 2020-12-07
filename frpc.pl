
my $cf = "/c4/.ssh/frpc.ini";
if(-e $cf){ exec "/tools/frp/frpc","-c",$cf } else { exec "sleep", "infinity" }
die;
