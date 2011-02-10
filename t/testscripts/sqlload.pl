#!/usr/bin/perl 

BEGIN {

    @LIBS = qw( lib/ t/ );
#    $ENV{'ADAPPS_CONF_LIB'} = qw( t/ ); 

} ;

use lib @LIBS;
use warnings;
use strict;
use Data::Dumper;
use ADApps::SqlLoader;
use ADApps::DB;

my $DATABASE = 'tests';

#my $conf = ADApps::DB->get_db_conf($DATABASE);


#my $sql_loader = ADApps::SqlLoader->new(
#    database => $DATABASE,
#    username => $conf->{'username'},
#    password => $conf->{'password'}
#);

my $sql_loader = ADApps::SqlLoader->database($DATABASE);

print Dumper $sql_loader;

$sql_loader->load('./t/testschemas/testemployee.sql');
