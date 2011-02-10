#!/usr/bin/perl 

use warnings;
use strict;
use lib qw( ./t ./lib ) ;
use Test::More tests => 1; 
use ADApps::DB;
use Test::MockObject;
use Data::Dumper;

    my $mock = Test::MockObject->new();

    $mock->fake_module(
        'ADApps::DB',
        database => sub { return ADApps::DB->_get_db_obj('tests') }
    );


    is(1,1, 'truth test');

