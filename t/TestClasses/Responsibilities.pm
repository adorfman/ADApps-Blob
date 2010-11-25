package TestClasses::Responsibilities;

use strict;
use warnings;
use base qw(ADApps::DataObject);

__PACKAGE__->use_db('tests');

__PACKAGE__->meta->setup(

    table   => 'responsibilities',
    columns => [
        id          => { primary_key => 1  },
        name        => { type => 'varchar', length => 30 },
        description => { type => 'text' }
    ],
    relationships => [
        employees => {
            type      => 'many to many',
            map_class => 'TestClasses::Employee_Responsibilities',
            map_to    => 'employee',
            map_from  => 'responsibility'
        } 
    ],
);

__PACKAGE__->load_manager_methods(); 

1;
