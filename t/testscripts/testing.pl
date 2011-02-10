#!/usr/bin/perl 

BEGIN {

    @LIBS = qw( lib/ t/ );
#    $ENV{'ADAPPS_CONF_LIB'} = qw( t/ ); 

} ;

use lib @LIBS;
use warnings;
use strict;
use Data::Dumper;

use TestClasses::Employees;

my $emp_obj = TestClasses::Employees->load(1);

foreach my $underling ( $emp_obj->subordinates ) {
    printf("%s %s \n", $underling->f_name, $underling->l_name);

}

foreach my $responsibility ( $emp_obj->responsibilities )  {
    printf("%s\n", $responsibility->name);
}

my $desk_location = $emp_obj->desk->location;

printf("%s\n",$desk_location);

my $emp_obj2 = TestClasses::Employees->load(2);

my $emp_obj2_manager = $emp_obj2->manager;

printf("%s %s\n", $emp_obj2_manager->f_name, $emp_obj2_manager->l_name);

foreach my $responsibility ( $emp_obj2->responsibilities )  {
    printf("%s\n", $responsibility->description);
}
#print Dumper($emp_obj);

$emp_obj->responsibilities({ name => 'manager'});

$emp_obj->save;
#print Dumper($respon);

print TestClasses::Employees->get_employees_count() . "\n";
#print TestClasses::Employees->total() . "\n"; 
#$emp_obj->save;


my @responsibilities = TestClasses::Responsibilities->get_responsibilities();

#print Dumper(@responsibilities);


#my $del_emp = TestClasses::Employees->load(3);


#print Dumper($del_emp);

#$del_emp->delete(cascade => 1 );
