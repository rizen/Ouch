use Test::More tests => 11;
use lib '../lib';

use_ok 'Ouch';

eval { ouch(100, 'Test', 'field_name') };
isa_ok $@, 'Ouch';

is $@->code, 100, 'fetch code';
is kiss(100), 1, 'trap an ouch';
is kiss(101), 0, 'do not trap wrong ouch';
is $@->message, 'Test', 'fetch message';
is $@->data, 'field_name', 'fetch data';
like $@, qr/^Test at/, 'string overload works';
isa_ok $@->hashref, 'HASH';
ok $@->trace, 'got a stack trace';

eval { die 'crap' };
is kiss(100), 0, 'do not trap non-ouch';
