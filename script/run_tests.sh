#!/bin/sh

emit_tt_test() {
test_file=`basename $1`
cat > $1 <<_EOT_
#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my \$tt = Test::Template->new({ INPUT => '$test_file', })
    or die "\$Template::ERROR\n";

ok( \$tt->process(), q{Processed template ok} );

done_testing();

_EOT_
}

## =======================================================================
## MAINLINE:
path=`dirname $0`
path=`( cd $path && pwd )`
root=`dirname $path`

cd $root

for file in `find ./lib ./root -type f -a \( -name "*.tt" -o -name "*.pm" \)`
do
    case $file in
        *.tt) test=${file/%.tt/.t}
              type="tt"
              ;;
        *.pm) test=${file/%.pm/.t}
              type="pm"
              ;;
    esac

    if [ ! -f $test ]; then
        echo "test file $test not found - creating...";
        if [ $type == 'tt' ]; then
            emit_tt_test $test
        else
            echo "skipping because type=$type"
        fi
    fi
done

prove -lr ./lib ./root

