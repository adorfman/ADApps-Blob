package ADApps::DB;

use strict;
use warnings;
use ADApps::GetConf;
use Data::Dumper;
use Rose::DB;

#$Rose::DB::Debug = 1;

sub db {

    my ($self, $database) = @_;

    my $db = _get_db_obj($database);

    return $db->dbh
        or die $db->error;

}


sub database {

    my ($self, $database) = @_;

    return _get_db_obj($database);

}

sub _get_db_obj {

    my $database = shift;

    my $CONF_DATA = ADApps::GetConf->load('databases');

    my $db_conf = $CONF_DATA
                    ->{'databases'}
                    ->{$database};
    
    die "Invalid database connection"
        unless ($db_conf);

    my $rose_db_obj = Rose::DB->new(
    
        database => $db_conf->{'database'},
        username => $db_conf->{'username'},
        password => $db_conf->{'password'}, 
        host     => $db_conf->{'host'}, 
        driver   => $db_conf->{'driver'}, 
    );
    #print Dumper($rose_db_obj);
    #print $database;

    return $rose_db_obj;


}



1;
