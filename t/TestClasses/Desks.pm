package TestClasses::Desks;

use strict;
use warnings;
use base qw(ADApps::DataObject);

__PACKAGE__->use_db('tests');

__PACKAGE__->meta->setup(

    table => 'desks',
    columns => [
        id => { primary_key => 1 },
        location => { type => 'varchar', length => '30'}
    ],
    relationships => [
        employee => {
            type => 'one to one',
            class => 'TestClasses::Employees',
            column_map => { id => 'desk_id' }
        }

    ],
);

__PACKAGE__->load_manager_methods();


1;
