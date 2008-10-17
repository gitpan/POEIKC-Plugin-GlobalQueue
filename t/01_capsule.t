use strict;
use Data::Dumper;
use Test::More;
#use Test::More qw(no_plan);

eval q{ use POEIKC::Daemon };
plan skip_all => "POEIKC::Daemon is not installed." if $@;

my $path = `poeikcd -v`;
plan skip_all => "poeikcd is not installed." if $path !~ /poeikcd version/ ;

plan tests => 13;


use POEIKC::Plugin::GlobalQueue::Capsule;

my $substance = {
	AAA=>'aaa',
	BBB=>'bbb',
};

my $capsule = POEIKC::Plugin::GlobalQueue::Capsule->new(
	$substance,
	tag=>'tagName',
	expireTime=>3
);

ok $capsule, Dumper($capsule);
is $capsule->substance->{AAA}, 'aaa', Dumper($capsule->substance);

sleep 1;

$capsule = POEIKC::Plugin::GlobalQueue::Capsule->new(
	undef, %{$capsule},
	gqId=>123,
	);

ok $capsule, Dumper($capsule);
is $capsule->substance->{AAA}, 'aaa', Dumper($capsule->substance);

ok $capsule->createTime, '$capsule->createTime';
ok $capsule->expireTime, '$capsule->expireTime';
ok $capsule->createTime > (time-$capsule->expireTime);

my @list;
push @list, $capsule->expire;
ok @list;
@list = ();
ok $capsule->expire, $capsule->expire;
sleep 2;
ok not $capsule->expire, $capsule->expire;
push @list, $capsule->expire;
ok not @list;

$capsule = POEIKC::Plugin::GlobalQueue::Capsule->new(
	$substance,
);
ok $capsule, Dumper($capsule);
@list = ();
push @list, $capsule->expire;
ok @list, Dumper($list[0]);
