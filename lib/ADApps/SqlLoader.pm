package ADApps::SqlLoader;

use warnings;
use strict;
use Env qw( PATH );
use Carp ;
use IPC::Run3;
use ADApps::DB;


my $MYSQL_BIN = 'mysql';

sub database {

    my ($class, $database) = @_;

    my $conf = ADApps::DB->get_db_conf($database);

    my $sql_loader = $class->new(
        database => $database,
        host     => $conf->{'host'},
        username => $conf->{'username'},
        password => $conf->{'password'}
    );

    return $sql_loader;

}

sub new {

    my ($class, @opts) = @_;
    #croak on odd number of params
    $class->_param_check(@opts);
    my $self = {@opts}; 

    croak 'No database provided'
        unless ($self->{'database'});

    bless $self, $class;

    return $self;

}


sub load {

    my ( $self, $file ) = @_;

    croak "File not found: $file"
        unless ( -f $file );

    return $self->_load_sql_file($file);

}

sub _load_sql_file {

    my ( $self, $file ) = @_; 

    my $cmd = $self->_create_cmd($file);

    my ($out, $err)  = $self->_run_cmd($cmd);

    carp $err if ($err);

    return 1;

}

sub _create_cmd {

    my ( $self, $file ) = @_;

    my $database = $self->{'database'};

    my $cmd = "$MYSQL_BIN";
    $cmd .= ' -h ' . $self->{'host'}
        if ( $self->{'host'}  ) ;
    $cmd .= ' -u ' . $self->{'username'}
        if ( $self->{'username'}  );
    $cmd .= ' -p' . $self->{'password'}
        if ( $self->{'password'}) ;
    $cmd .= " $database ";
    $cmd .= "< $file";

    return $cmd;

}


sub _run_cmd {

    my ($self, $cmd ) = @_;

    my $OLDPATH = $PATH;

    $PATH='/usr/local/bin:/usr/bin:/bin';
 
    my ($stout, $sterr);

    run3( $cmd, undef, \$stout, \$sterr );

    $PATH = $OLDPATH;

    if ( wantarray() ) {
        return ($stout, $sterr);
    }
    else {
        return $stout;
    }

}

sub _param_check {

    my ($self, @params) = @_;

    if ( !(@params % 2 == 0 ) )  {
        croak "Odd number of paramets";
    } 

}


1;
