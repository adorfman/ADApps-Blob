package ADApps::DB2;

use strict;
use warnings;
use Carp;
use base "Rose::DB";
use ADApps::DB2::Registry;
use Data::Dumper;

our $DEBUG = 0;
our $NOCACHE = 0; 
our $ENV = 'Production';

sub load {

    my ($class, $database) = @_;

    $Rose::DB::Debug = 1 if ( $DEBUG > 1 );
    return __PACKAGE__->get_db_object($database);

}

sub load_dbh {

    my ( $class, $database ) = @_;
    my $db = $class->load($database);
    return $db->retain_dbh();

}


sub get_db_object {

    my ( $class, $database ) = @_;

    if ($NOCACHE) {
        return __PACKAGE__->_get_db_object($database)
    }
    else { 
        return __PACKAGE__->_get_db_object_cached($database)
    }
}

sub _get_db_object {
    my ( $class, $database ) = @_;
    print $class . "\n";
    return __PACKAGE__->new( domain => $ENV, type => $database  );
}

sub _get_db_object_cached {
    my ( $class, $database ) = @_;
    print $class . "\n";
    my $return =  __PACKAGE__->new_or_cached( domain => $ENV, type => $database  ); 
 
#    print Dumper $return;
    return $return;
}
1;
