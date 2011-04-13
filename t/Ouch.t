use Test::More tests => 8;
use lib '../lib';

use_ok 'Ouch';

eval { ouch(100, 'Test', 'field_name') };

isa_ok $@, 'Ouch';

is $@->code, 100, 'fetch code';
is $@->message, 'Test', 'fetch message';
is $@->data, 'field_name', 'fetch data';
is $@, 'Test', 'string overload works';
isa_ok $@->hashref, 'HASH';
is scalar($@->array), 3, 'array works';
