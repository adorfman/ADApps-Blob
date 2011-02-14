package ADApps::DB;

use strict;
use warnings;
use Carp;
use ADApps::GetConf;
use Data::Dumper;
use Rose::DB;

#$Rose::DB::Debug = 1;

# Looks like this doesn't work
#sub db {
#
#    my ($class, $database) = @_;
#
#    my $db = $class->_get_db_obj($database);
#
#    return $db->dbh
#        or carp $db->error;

#}


sub database {

    my ($class, $database) = @_;

    return $class->_get_db_obj($database);

}

sub get_conf {

    my $class  = $_;
    
    my $conf_file =  ADApps::GetConf->load('databases');

    carp "Could not locate databases.yml file"
        unless ($conf_file);

    return $conf_file;

}

sub get_db_conf {

    my ($class, $database) = @_;

    my $conf_data = $class->get_conf();

    my $db_conf = $conf_data
                    ->{$database};
    
    carp "Can't find database connection: $database"
        unless ($db_conf);

    return $db_conf;

}

sub _get_db_obj {

    my ( $class,$database ) = @_;

   my $db_conf = $class->get_db_conf($database);

    my $rose_db_obj = Rose::DB->new(
    
        database => $db_conf->{'database'},
        username => $db_conf->{'username'},
        password => $db_conf->{'password'}, 
        host     => $db_conf->{'host'}, 
        driver   => $db_conf->{'driver'}, 
    ) or carp Rose::DB->error;

    return $rose_db_obj;

}



1;
