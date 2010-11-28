#!/usr/bin/perl 

use warnings;
use strict;
use Test::More tests => 1; 
use Test::MockObject;
use Data::Dumper;

use lib qw( ./t ./lib ) ;
use DB_ENV qw( mysql );;


SKIP: {
    skip 'cannot connect to db', 1 unless DB_ENV->verify_dbh('mysql');

    my $mock = Test::MockObject->new();

    my $conf = {  
        username => $MYSQL_USER,
        password => $MYSQL_PASS,
        host     => $MYSQL_HOST,
        driver   => 'mysql',
        database => $MYSQL_DB,
    };

    $mock->fake_module(
        'ADApps::GetConf',
        load => sub { $conf  }
    
    );
    use ADApps::GetConf;

    print Dumper( ADApps::GetConf->load('something')  );

    print "$MYSQL_HOST $MYSQL_PORT \n" ;

    is(1,1, 'truth test');

};
