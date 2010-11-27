#!perl -T

use Test::More tests => 5;
#use FindBin qw($Bin);
use lib "./lib";

BEGIN {
	use_ok( 'ADApps::Blob' );
    use_ok( 'ADApps::DB' );
    use_ok( 'ADApps::GetConf' );
    use_ok( 'ADApps::DataObject' );
    use_ok( 'ADApps::DataObject::Manager' );
}

diag( "Testing ADApps::Blob $ADApps::Blob::VERSION, Perl $], $^X" );
