#!/usr/bin/perl

use warnings;
use strict;
use lib qw( t/ lib/  );
use ADApps::DB2;
use Data::Dumper;

#$ADApps::DB2::DEBUG = 2;
#$ADApps::DB2::NOCACHE = 1;

my $test = ADApps::DB2->load_dbh('tests');
my $test2 = ADApps::DB2->load('tests'); 

#$test2->connect();
#print "After load \n";
#print Dumper $test2;


my $dbh =  $test2->dbh() or die $test2->error;

#$dbh->connect();
my $sth = $dbh->prepare('SHOW TABLES');
$sth->execute();

while (my $table  = $sth->fetchrow) {
    print "$table\n";
}
