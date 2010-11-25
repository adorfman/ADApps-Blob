package TestClasses::Employee_Responsibilities;

use strict;
use warnings;
use base qw(ADApps::DataObject);

__PACKAGE__->use_db('tests');


__PACKAGE__->meta->setup(

    table => 'employees_responsibilities',
    columns => [
        id                => { primary_key => 1},
        employee_id       => { type => 'int', length => 8  },
        responsibilities_id => { type => 'int', length => 8  }
    ],
    relationships => [
        employee => {
            type       => 'many to one',
            class      => 'TestClasses::Employees',
            column_map => { employee_id => 'id' }
        },
        responsibility => {
            type       => 'many to one',
            class      => 'TestClasses::Responsibilities',
            column_map => { responsibilities_id => 'id'  }
        }

    ],

);

__PACKAGE__->load_manager_methods();


1; 
