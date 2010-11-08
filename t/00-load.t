#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'ADApps::Blob' );
}

diag( "Testing ADApps::Blob $ADApps::Blob::VERSION, Perl $], $^X" );
