use strict;
use Data::Dumper;
use Test::More;
#use Test::More qw(no_plan);

eval q{ use POEIKC::Daemon };
plan skip_all => "POEIKC::Daemon is not installed." if $@;

my $path = `poeikcd -v`;
plan skip_all => "poeikcd is not installed." if $path !~ /poeikcd version/ ;

plan tests => 16;


use POEIKC::Plugin::GlobalQueue::Capsule;
use POEIKC::Plugin::GlobalQueue::ClientLite;

my $cmd;

$cmd = `poeikcd start -I=lib -M=POEIKC::Plugin::GlobalQueue -n=GlobalQueue -a=QueueServer -p=47301 -s`;
ok $cmd =~ /Started/, $cmd;
sleep 1;
my $gq = POEIKC::Plugin::GlobalQueue::ClientLite->new(port=>47301, timeout=>3);
ok $gq, Dumper($gq);

my $co = $gq->connect;
ok $co, Dumper($co);


my $re;
$re = $gq->enqueue(POEIKC::Plugin::GlobalQueue::Capsule->new({AAA=>'aaa',BBB=>'bbb',},tag=>'tagName1',));
$re = $gq->enqueue(POEIKC::Plugin::GlobalQueue::Capsule->new({CCC=>'ccc',DDD=>'ddd',},tag=>'tagName1',));

$cmd = `poeikcd stop -a=QueueServer -p=47301`;
ok $cmd =~ /stopped/, $cmd;
ok $gq, Dumper($gq);

$cmd = `poeikcd start -I=lib -M=POEIKC::Plugin::GlobalQueue -n=GlobalQueue -a=QueueServer -p=47301 -s`;
ok $cmd =~ /Started/, $cmd;
sleep 1;

$re = $gq->enqueue(POEIKC::Plugin::GlobalQueue::Capsule->new({EEE=>'eee',FFF=>'fff',},tag=>'tagName1',));
$cmd = `poeikcd stop -a=QueueServer -p=47301`;
ok $cmd =~ /stopped/, $cmd;

sleep 1;

$re = $gq->enqueue(POEIKC::Plugin::GlobalQueue::Capsule->new({IROHA=>'iroha',AIU=>'AIU',},tag=>'tagName2',));
ok not($re), 'not($re)';
ok $gq->ikc->error, '$gq->ikc->error: '.$gq->ikc->error;

ok not($gq->ikc(undef)), 'not($gq->ikc(undef))';
eval {
	local $gq->{RaiseError} = 1;
	$gq->enqueue(POEIKC::Plugin::GlobalQueue::Capsule->new({IROHA=>'iroha',AIU=>'AIU',},tag=>'tagName2',));
};if($@){
	ok $@, 'eval_error($gq->enqueue): '.$@. '<<'.__LINE__;
}
eval {
	local $gq->{RaiseError} = 1;
	$co = $gq->connect;
};if($@){
	ok $@, 'eval_error($gq->connect): '.$@. '<<'.__LINE__;
}


$cmd = `poeikcd start -I=lib -M=POEIKC::Plugin::GlobalQueue -n=GlobalQueue -a=QueueServer -p=47301 -s`;
ok $cmd =~ /Started/, $cmd;
sleep 1;

$re = $gq->enqueue(POEIKC::Plugin::GlobalQueue::Capsule->new({IROHA=>'iroha',AIU=>'AIU',},tag=>'tagName2',));
my $le = $gq->length();
ok $le, Dumper($le);

$cmd = `poeikcd stop -a=QueueServer -p=47301`;
ok $cmd =~ /stopped/, $cmd;

ok 1, 'all ok';