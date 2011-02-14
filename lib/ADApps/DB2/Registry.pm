package ADApps::DB2::Registry;

use strict;
use warnings;
use Carp;
use ADApps::DB2;
use ADApps::GetConf;
use Data::Dumper;

my $conf = ADApps::GetConf->load('databases');

foreach my $database  ( keys %{$conf}  ) {

    print $database . "\n";

    my $db_conf = $conf->{$database} ;

    ADApps::DB2->register_db(
        domain   =>  $db_conf->{'domain'} ,
        type     =>  $database ,
        driver   =>  $db_conf->{'driver'},
        database =>  $db_conf->{'database'},
        host     =>  $db_conf->{'host'},
        username =>  $db_conf->{'username'},
        password =>  $db_conf->{'password'}   
    );

}


1;
