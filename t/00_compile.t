use strict;
use Test::More tests => 5;

BEGIN { use_ok 'POEIKC::Plugin::GlobalQueue' }
BEGIN { use_ok 'POEIKC::Plugin::GlobalQueue::Capsule' }
BEGIN { use_ok 'POEIKC::Plugin::GlobalQueue::ClientLite' }

is $POEIKC::Plugin::GlobalQueue::VERSION, $POEIKC::Plugin::GlobalQueue::Capsule::VERSION;
is $POEIKC::Plugin::GlobalQueue::VERSION, $POEIKC::Plugin::GlobalQueue::ClientLite::VERSION;
