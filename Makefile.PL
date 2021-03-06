use inc::Module::Install 0.77;

if ( -e 'MANIFEST.SKIP' ) {
    system( 'pod2text lib/URI/Template.pm > README' );
}

perl_version '5.006';

name 'URI-Template';
all_from 'lib/URI/Template.pm';

requires 'URI';
requires 'URI::Escape';
requires 'Unicode::Normalize';

test_requires 'Test::More';
use_test_base;

WriteAll;
