#!/usr/bin/perl 

use warnings;
use strict;
use Test::More tests => 19;
use Test::MockObject;
use DBI;

use lib qw( ./lib  );

BEGIN {
    my %ENV_VARS = (
        ENV_MYSQL_USER => 'user',
        ENV_MYSQL_PASS => 'pass',
        ENV_MYSQL_DB   => 'testing'
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

my %EXPECTED = (
    MYSQL_USER => 'user',
    MYSQL_PASS => 'pass',
    MYSQL_DB   => 'testing',
    MYSQL_HOST => 'localhost',
    MYSQL_PORT => '3306'

);

use_ok( 'ADApps::DB_ENV', qw( mysql ) );
can_ok( 'ADApps::DB_ENV', qw(import verify_db_env get_dbh)  );

for ( keys %EXPECTED ) {
    no strict 'refs';
    is( defined ${$_}, 1,  "$_ exported");
    is( ${$_}, $EXPECTED{$_}, "$_ set to expected value" );
}

is( ADApps::DB_ENV->verify_db_env('mysql'), '1', 'db connection verified' );

is( ADApps::DB_ENV->get_dbh('mysql'), 'DBI::db=HASH', 'got dbh'  );

{
    # Localizing $SIG{__WARN__} to die() 
    # so we can easily trap warns/carps messages;
    local $SIG{'__WARN__'} = sub { die  $_[0] };
    
    eval { ADApps::DB_ENV->verify_db_env() };
    like( $@, '/no type specified.*/', 'undefined type check' );

    eval { ADApps::DB_ENV->verify_db_env('mysqli') };
    like( $@, '/mysqli type variables were not exported.*/', 'not loaded type check' ); 

    local $DB_ENV::DEBUG = 1; 

    # this is the dumbest hack to avoid a silly warning
    eval($DB_ENV::DEBUG) ;

    {
        local $ADApps::DB_ENV::MYSQL_USER = 0;
        local $ADApps::DB_ENV::MYSQL_PASS = 0;

        # more dumb hackyness
        eval($ADApps::DB_ENV::MYSQL_USER && $ADApps::DB_ENV::MYSQL_PASS);

        eval { ADApps::DB_ENV->verify_db_env('mysql') };
        like( $@, '/no user and pass in ENV.*/', 'user/pass in env check' );  
    }
    
    our $DBI_FAIL = 1;
    eval { ADApps::DB_ENV->verify_db_env('mysql') }; 
    like( $@, '/dbh creation failed.*/', 'dbh test failed' );   
}

{    
    # for these tests we want to silient all warns and test just the return value
    local $SIG{'__WARN__'} = sub {};

    is( ADApps::DB_ENV->get_dbh('mysqli') , '0', 'got_dbh failed' ) ; 
}














