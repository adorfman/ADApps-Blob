package TestClasses::Employees;

use strict;
use warnings;
use base qw(ADApps::DataObject);

__PACKAGE__->use_db('tests');


__PACKAGE__->meta->setup(

    table => 'employees',
    columns => [ 
        id          => { primary_key => 1  },         
        f_name      => { type => 'varchar', length => 30  },     
        l_name      => { type => 'varchar', length => 30  },
        manager_id  => { type => 'int', length => 8 },
        desk_id     => { type => 'int', length => 8 } 
    ],
    relationships => [
        manager          => {
            type       => 'many to one',
            class      => 'TestClasses::Employees',
            column_map => { manager_id => 'id'  }
        },
        desk             => {
            type       => 'one to one',
            class      => 'TestClasses::Desks',
            column_map => { desk_id => 'id' }
        },
        subordinates     => {
            type       => 'one to many',
            class      => 'TestClasses::Employees',
            column_map => { id => 'manager_id'  }
        },
        responsibilities => {
            type      => 'many to many',
            map_class => 'TestClasses::Employee_Responsibilities',
            map_from  => 'employee',
            map_to    => 'responsibility'
        }

    ],


);


__PACKAGE__->load_manager_methods();


1; 
