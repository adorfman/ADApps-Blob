#!/usr/bin/perl 

use warnings;
use strict;
use Test::More tests => 17;
use Test::MockObject;
use DBI;

use lib qw( ./lib  );

BEGIN {
    my %ENV_VARS = (
        MYSQL_TEST_USER => 'user',
        MYSQL_TEST_PASS => 'pass',
    );    

    (   sub {
            foreach my $var ( keys %ENV_VARS) {
                $ENV{$var} = $ENV_VARS{$var};
            }          
        }
    )->();
    
    our $DBI_FAIL;
    my $mock = Test::MockObject->new(); 
    $mock->fake_module( 'DBI',
        connect => sub {
                    return ( $DBI_FAIL )  ? 'fail' : 'DBI::db=HASH';
                   },
    );
    


}

our $WARN;

my %EXPECTED = (
    MYSQL_USER => 'user',
    MYSQL_PASS => 'pass',
    MYSQL_DB   => 'tests',
    MYSQL_HOST => 'localhost',
    MYSQL_PORT => '3306'

);

use_ok( 'ADApps::DB_ENV', qw( mysql ) );
can_ok( 'ADApps::DB_ENV', qw(import verify_db_env)  );
for ( keys %EXPECTED ) {
    no strict 'refs';
    is( defined ${$_}, 1,  "$_ exported");
    is( ${$_}, $EXPECTED{$_}, "$_ set to expected value" );
}

is( ADApps::DB_ENV->verify_db_env('mysql'), 'DBI::db=HASH', 'db connection verified' );

#no warnings 'all';

{
    # Localizing $SIG{__WARN__} to die() 
    # so we can easily trap warns/carps messages;
    local $SIG{'__WARN__'} = sub { die  $_[0] };
    
    eval { ADApps::DB_ENV->verify_db_env() };
    like( $@, '/no type specified.*/', 'undefined type check' );

    eval { ADApps::DB_ENV->verify_db_env('mysqli') };
    like( $@, '/mysqli was not loaded.*/', 'not loaded type check' ); 

    local $ENV{'DB_ENV_DEBUG'} = 1; 
    
    {
        local $ENV{'MYSQL_TEST_USER'} = 0;
        local $ENV{'MYSQL_TEST_PASS'} = 0;

        eval { ADApps::DB_ENV->verify_db_env('mysql') };
        like( $@, '/no user and pass in ENV.*/', 'user/pass in env check' );  
    }
    
    our $DBI_FAIL = 1;
    eval { ADApps::DB_ENV->verify_db_env('mysql') }; 
    like( $@, '/dbh creation failed.*/', 'dbh test failed' );   

}













