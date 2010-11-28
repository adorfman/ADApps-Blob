#!/usr/bin/perl 

package ADApps::DB_ENV;
use warnings;
use strict;

use DBI;
use DBD::mysql;
use Carp;

my @EXPORTED;

my @TYPES = qw( mysql );

my %VARS = (

    mysql => [ qw( MYSQL_USER MYSQL_PASS MYSQL_DB   
                 MYSQL_HOST MYSQL_PORT 
                )
             ]

);

my %DEFAULTS = (

    mysql => {
        db   => 'tests',
        host => 'localhost',
        port => '3306'
    }

);

sub import {

    # we want to do more selective exporting based on the
    # type of database variables requested on 'use' and
    # Exporter doesn't seem to everything we need.

    my ( $class, @types ) = @_;

    return unless (@types);

    my $caller = caller();

    foreach my $type (@types) {
        unless ( grep { /^$type$/  } @TYPES ) {
            carp "invalid type: $type";
            return;
         }
        _export_vars($type,$caller);
    }
}

sub _export_vars {


        my ($type,$caller) = @_;

        no strict 'refs';
        
        # Add variables to the callers name space.
        for (@{ $VARS{$type} }) {
            *{"${caller}::$_"} = \$$_;    
        }
        
        # set  variables.
        _load_from_env($type);

        push(@EXPORTED, $type);
    
}    

sub _load_from_env {

    my $type = shift;
   
    foreach my $default (keys %{$DEFAULTS{$type}} ) {

        my $env_name = uc($type) . '_TEST_' . uc($default);
        $ENV{$env_name} ||= $DEFAULTS{$type}->{$default};


    }
    foreach my $var (@{$VARS{$type}}) {
        no strict 'refs';
        my $env_name = $var;
        $env_name =~ s/_/_TEST_/;
        
        # I dont know which is better/worse here.
        #my $eval = 'our $' . $var . '= $ENV{$env_name}';
        #eval $eval;
        #carp 'Something went really wrong' if ($@);

        ${$var} = $ENV{$env_name};
    }

}

sub verify_db_env {

    my ($class, $type )= @_ ;

    unless ( grep { /^$type$/ } @EXPORTED  ) {
        carp "$type was not loaded";
        return 0;

    }

    our $mysql_dbh  = _test_dbh( $type );

}

sub _test_dbh {

    my $type = shift;
 
    my $user = $ENV{ uc($type) . '_TEST_USER' };
    my $pass = $ENV{ uc($type) . '_TEST_PASS' };

    unless($user && $pass) {
        print_debug('no user and pass in ENV');
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
    ) or print_debug( $DBI::errstr ) ;

    if ( $dbh =~ /^DBI::db=HASH.*/) {
        return $dbh
    }
    else {
        print_debug('dbh creation failed');
        return 0;
    }
}

sub print_debug {

    my $err = shift;
    print $err . "\n" if $ENV{'DB_ENV_DEBUG'} ;

}

1;
