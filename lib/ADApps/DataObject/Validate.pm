package ADApps::DataObject::Validate;

use strict;
use warnings;
use Carp;

my $RULES = {
    columns => { 
        id => {
           present => 1
        },
    }
} ;

sub validate {

    my ( $class, %setup ) = @_ ;
    $class->validate_columns(%setup);

}

sub validate_columns {

    my ( $class, %setup ) = @_ ;

    my $val_err;

    foreach my $column ( keys %{ $RULES->{'columns'} } ) {
        if ( $RULES->{'columns'}->{$column}->{'present'} ) {
            $val_err .= "Must define column $column \n"
               unless ( grep { /$column/  } @{ $setup{'columns'} } ) ;
        }
    
    }
    croak "Validation error: $val_err" if ($val_err);

}


1;
