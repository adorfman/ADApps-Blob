package ADApps::GetConf;

use strict;
use warnings;
use YAML;
use Carp;
use Cwd;
use Data::Dumper;

my $PWD = cwd ;#  system('pwd');;
my $HOMEDIR = ( getpwuid $< )[ 7 ];
my @CONF_LIBS_STATIC = qw(
    /etc/adapps/etc
    /opt/appaps/etc
);

my @CONF_LIBS;
push(@CONF_LIBS, ( $PWD, $HOMEDIR, @CONF_LIBS_STATIC) );

sub load {

    my ($self, $file_param ) = @_;

    my $conf_file = _find_conf_file($file_param);

    return YAML::LoadFile($conf_file);

}

sub _find_conf_file {

    my $conf_file;

    my $file_param  = shift;

    if ( (ref $file_param) && ( scalar $file_param =~ /HASH/ ) ){
        $conf_file = $file_param->{'file'}
            if ( -f  $file_param->{'file'} );

        croak "Config file not found: " . $file_param->{'file'}
            unless ($conf_file);
    }
    elsif ( $ENV{'ADAPPS_CONF_LIB'} ) {  
        my $file_loc = sprintf(
            '%s/%s.yml',
            $ENV{'ADAPPS_CONF_LIB'}, 
            $file_param
        ); 

        $conf_file = $file_loc
            if ( -f  $file_loc );

        croak "Config file not found: $file_loc"
            unless ($conf_file);  

    }
    else {
        foreach my $conf_lib (@CONF_LIBS) {
            my $file_loc = sprintf(
                '%s/%s.yml',
                $conf_lib, 
                $file_param
            );

            if ( -f $file_loc  ) {
                $conf_file = $file_loc;
                last;
            }
        }
         
        croak "Config file not found: ${file_param}.yml"
            unless ($conf_file);  

    } 

    return $conf_file;


}



1;
