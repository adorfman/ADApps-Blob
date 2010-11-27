#!/usr/bin/perl 

package DB_ENV;
use  Exporter qw( import  );
#@ISA = qw(Exporter);
use warnings;
use strict;

use DBI;
use DBD::mysql;

our @EXPORT = qw( $mysql_user $mysql_pass $mysql_db $mysql_host $mysql_port $mysql_dbh );
our $Debug;

$ENV{'MYSQL_TEST_DB'}   ||= 'tests';
$ENV{'MYSQL_TEST_HOST'} ||= 'localhost';
$ENV{'MYSQL_TEST_PORT'} ||= '3306';

our ($mysql_user, $mysql_pass, $mysql_db, $mysql_host,$mysql_port ) = 
    (   $ENV{'MYSQL_TEST_USER'}, $ENV{'MYSQL_TEST_PASS'}, $ENV{'MYSQL_TEST_DB'}, 
        $ENV{'MYSQL_TEST_HOST'}, $ENV{'MYSQL_TEST_PORT'} 
    );


sub verify_dbh {

    my ($class, $type )= @_ ;

    our $mysql_dbh  = get_dbh( $type );

}

sub get_dbh {

    my $type = shift;
 
    my $user = $ENV{ uc($type) . '_TEST_USER' };
    my $pass = $ENV{ uc($type) . '_TEST_PASS' };

    unless($user && $pass) {
        print_error('no user and pass in ENV');
        return 0;
    }

    my $db   = $ENV{ uc($type) . '_TEST_DB' };
    my $host = $ENV{ uc($type) . '_TEST_HOST' };
    my $port = $ENV{ uc($type) . '_TEST_PORT' };

    my $dns = "DBI:$type:$db:$host:port=$port";

    my $dbh = DBI->connect($dns, $user,$pass, 
        {   RaiseError => 0,  
            PrintError => 0
        }
    ) or print_error( $DBI::errstr ) ;

    if ( $dbh =~ /^DBI::db=HASH.*/) {
        return $dbh
    }
    else {
        print_error('dbh creation failed');
        return 0;
    }
}

sub print_error {

    my $err = shift;
    print $err . "\n" if $ENV{'DB_ENV_DEBUG'} ;

}

1;
