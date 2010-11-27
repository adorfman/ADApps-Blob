#!/user/bin/perl -T 
use Test::More tests => 6; 


use lib qw(./lib);
use ADApps::GetConf;
use Data::Dumper;


my $lib = './t';
local $ENV{'ADAPPS_CONF_LIB'} = $lib ;

my $expected_conf = {
    'testconf' => {
       'settings' => {
            'array' => [
                 'red',
                 'green',
                 'blue'
             ],
             'test' => 'four',
             'value' => '3'
        }
    },
    'databases' => {
        'tests' => {
            'domain' => 'Production',
            'password' => '',
            'type' => 'main',
            'driver' => 'mysql',
            'host' => 'localhost',
            'username' => 'testing'
         }
    }
};

# Test file loads from specific path and matches expected data;

my $conf ;

eval {
    $conf = ADApps::GetConf->load(
        { file => './t/databases.yml' } 
    );
};

ok($conf =~ /^HASH\(/, 'Conf loaded with file path' );

is_deeply($conf, $expected_conf, 'Conf from file path matches'); 

# Test file loads when $ENV{'ADAPPS_CONF_LIB'} is set;

my $conf2;

eval {
    $conf2 = ADApps::GetConf->load('databases');
};

ok($conf2 =~ /^HASH\(/, 'Conf loaded with ADAPPS_CONF_LIB set' ); 

is_deeply($conf2, $expected_conf, 'Conf from LIB matches');

# Test for correct error message when invalid path is set.

my $conf3;

eval {
    $conf3 = ADApps::GetConf->load( 
        { file => './t/notfound.yml' } 
    );
}; 

ok( $@ =~ /Invaid config file/, 'Conf not found from path' );

# Test for correct error message when invalid ADAPPS_CONF_LIB is set;

my $conf4;

eval {
    local $ENV{'ADAPPS_CONF_LIB'} = './notlib' ; 
    $conf4 = ADApps::GetConf->load( 'notfound'  );
}; 

ok( $@ =~ /Invaid config file/, 'Conf not found in ADAPPS_CONF_LIB' ); 




__DATA__
#print Dumper($yaml);
