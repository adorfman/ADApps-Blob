package ADApps::GetConf;

use strict;
use warnings;
use YAML;

my @CONF_LIBS = qw(
    /etc/adapps/etc
    /opt/appaps/etc
);

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

        die "Invaid config file"
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

        die "Invaid config file $file_loc"
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
         
        die "Invaid config file $file_param"
            unless ($conf_file);  

    } 

    return $conf_file;


}



1;
