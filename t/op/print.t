#!./perl

BEGIN {
    require "test.pl";
}

plan(3);

fresh_perl_is('$_ = qq{OK\n}; print;', "OK\n",
              'print without arguments outputs $_');
fresh_perl_is('$_ = qq{OK\n}; print STDOUT;', "OK\n",
              'print with only a filehandle outputs $_');
fresh_perl_unlike(<<'EOF', "oops", "", "print doesn't launder utf8 overlongs");
use strict;
use warnings;

use warnings FATAL => 'utf8';

# These form overlong "oops"
open my $fh, "<:utf8", \"\xC1\xAF\xC1\xAF\xC1\xB0\xC1\xB3" or die;
read($fh, my $s, 10) or die;
die if $s =~ /oops/;
print $s;
EOF
