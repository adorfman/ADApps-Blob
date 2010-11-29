#!/usr/bin/perl 

package ADApps::DB_ENV;
use warnings;
use strict;

use DBI;
use DBD::mysql;
use Carp;

our $DEBUG = 0;
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

    # we want to do more on import() based on the
    # type of database variables requested on 'use' and
    # Exporter doesn't seem to allow us to do
    # do everything we need.

    my ( $class, @types ) = @_;

    return unless (@types);

    my $caller = caller();

    foreach my $type (@types) {
        unless ( grep { /^$type$/  } @TYPES ) {
            carp "invalid type: $type";
            next;
        }
        _export_vars($type,$caller);
        # set  variables.
        _load_from_env($type);
 
    }

}

sub _export_vars {

        my ($type,$caller) = @_;

        no strict 'refs';
        
        # Add variables to the callers name space.
        for (@{ $VARS{$type} }) {
            # pretty much borrowed this from Exporter.pm
            *{"${caller}::$_"} = \${$_};    
        }

        push(@EXPORTED, $type);
    
}    

sub _load_from_env {

    my $type = shift;
   
    foreach my $default (keys %{$DEFAULTS{$type}} ) {

        my $env_name = 'ENV_' . uc($type) . '_' .  uc($default);
        $ENV{$env_name} ||= $DEFAULTS{$type}->{$default};


    }
    foreach my $var (@{$VARS{$type}}) {

        no strict 'refs';
        
        my $env_name = 'ENV_' . $var;
        
        # I dont know which is better/worse here.
        #my $eval = 'our $' . $var . '= $ENV{$env_name}';
        #eval $eval;
        #carp 'Something went really wrong' if ($@);

        ${$var} = $ENV{$env_name};
    }

}

sub verify_db_env {

    my ($class, $type )= @_ ;
    
    unless( $type )  {
        carp "no type specified";
        return ;
    }  
    
    unless ( grep { /^$type$/ } @EXPORTED  ) {
        carp "$type type variables were not exported";
        return 0;

    }

    our $mysql_dbh  = _test_dbh( $type );

}

sub _test_dbh {

    my $type = shift;

    my $user = $ENV{ 'ENV_' .  uc($type) . '_USER' };
    my $pass = $ENV{ 'ENV_' . uc($type) . '_PASS' };

    unless($user && $pass) {
        print_debug('no user and pass in ENV');
        return 0;
    }

    my $db   = $ENV{ 'ENV_' . uc($type) . '_DB' };
    my $host = $ENV{ 'ENV_' . uc($type) . '_HOST' };
    my $port = $ENV{ 'ENV_' . uc($type) . '_PORT' };

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
    carp $err if $DB_ENV::DEBUG ; 
    #print $err . "\n" if $ENV{'DB_ENV_DEBUG'} ;

}

1;

__END__

=pod

=head1 NAME: ADApps::DB_ENV

=head1 SYNOPSIS:

Simple module for loading dbh connection info from %ENV and exporting 
appropriate variables into the calling class. It currently supports the following types:
 
 mysql

=head1 EXAMPLE:

 use APApps::DB_ENV qw( mysql );                                        
 # This will import the following variables into the calling package:  
 #                                                                     
 # MYSQL_USER                                                          
 # MYSQL_PASS 
 # MYSQL_DB   
 # MYSQL_HOST 
 # MYSQL_PORT  

 # To validate these work:
 APApps::DB_ENV->verify_db_env('mysql')

=head1 METHODS:

 verify_db_env( import_type  ) : This module currently only has one public class method. This method will attempt to to use the appropriate DBI drive to make a connection to the database using the information in the variables in exported  

 import : This called on 'use' and should not be called as a class method. When called it will export the appropriate variables into the calling package. It will then search for the appropriate environmental variables and load their values into the matching exported variables.

=cut




