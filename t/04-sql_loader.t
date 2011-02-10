use Test::More tests => 4;

BEGIN {

    @LIBS = qw( lib/ t/ );

};

use lib @LIBS;
use warnings;
use strict;
use Data::Dumper;
use ADApps::SqlLoader;
use ADApps::DB;

my $DATABASE = 'tests';
my @EXPECTED_TABLES = ( 
  'desks',
  'employees',
  'employees_responsibilities',
  'responsibilities' );


my $DB;

eval{
    $DB = ADApps::DB->database($DATABASE);
};
my $DB_ERR = $@;     
my $dbh;

if (!$DB_ERR) {

    $dbh = $DB->dbh;

    # Make sure our testing tables aren't already there
    foreach my $table (@EXPECTED_TABLES) {
        $dbh->do("DROP TABLE $table  ");
    } 
} 

my $sql_loader = ADApps::SqlLoader->database($DATABASE); 

isa_ok($sql_loader, 'ADApps::SqlLoader');
    


eval{
    $sql_loader->load('./t/TestSQL/drop_add_data.sql'); 
};

is($@,'','no error on load');


SKIP: {
    
    skip "Failed getting dbh", 1 if $DB_ERR;

    my $sth = $dbh->prepare('SHOW TABLES');
    $sth->execute();

    my @GOT_TABLES;

    while ( my $table = $sth->fetchrow) {
        push(@GOT_TABLES, $table)
    }

    is_deeply( \@GOT_TABLES, \@EXPECTED_TABLES, 'Found all tables');

}

eval{
    $sql_loader->load('./t/TestSQL/notfound.sql'); 
};

like($@, qr/File not found/, 'File not found'); 
