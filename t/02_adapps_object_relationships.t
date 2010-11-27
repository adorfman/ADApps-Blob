#!/usr/bin/perl 

use warnings;
use strict;
use Test::More tests => 1; 
use Test::MockObject;
use Data::Dumper;

use lib qw( ./t ./lib ) ;
use DB_ENV;


SKIP: {
    skip 'cannot connect to db', 1 unless DB_ENV->verify_dbh('mysql');

    my $mock = Test::MockObject->new();

    my $conf = {  
        username => $mysql_user,
        password => $mysql_pass,
        host     => $mysql_host,
        driver   => 'mysql',
        database => $mysql_db,
    };

    $mock->fake_module(
        'ADApps::GetConf',
        load => sub { $conf  }
    
    );
    use ADApps::GetConf;

    print Dumper( ADApps::GetConf->load('something')  );

    print "$mysql_host $mysql_port $mysql_dbh\n" ;

    is(1,1, 'truth test');

};
