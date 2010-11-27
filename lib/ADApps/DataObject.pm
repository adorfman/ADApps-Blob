package ADApps::DataObject;

#use lib $ENV{'ADAPPS_LIB'};
use strict;
use warnings;
use ADApps::DB;
use ADApps::DataObject::Manager;
use base qw(Rose::DB::Object);
our @EXPORT = qw( $ROSEDEBUG  );

our $ROSEDEBUG = 0;

#if ($ROSEDEBUG) {
#    print "Debuging \n";    
#    $Rose::DB::Debug = 1; 
#    $Rose::DB::Object::Debug = 1;
# $Rose::DB::Object::Metadata::Relationship::Debug = 1; 
#    $Rose::DB::Object::Metadata::Relationship::ManyToOne::Debug = 1;
#    $Rose::DB::Object::Manager::Debug = 1;
#    $Rose::DB::Object::Metadata::Debug = 1;
#}

my $DATABASE_CON;

sub use_db {

    my ($self,$database) = @_;

    $DATABASE_CON = $database;

}


sub load_manager_methods {

    my $class = shift;
    my %args;

    if (@_) {
        if (@_ % 2 == 0)  {
            %args = @_;
        }
        else {
            die "Odd number of paramets";
        }
    }

    $class =~ /(.*::)([^:]+)/;
    my $table = 
        $args{'table'}
        ? $args{'table'}
        : lc($2);

    ADApps::DataObject::Manager->make_manager_methods(
        target_class => $class,
        base_name    => $table
    );
}

#sub load_all {
#
#    my ($class, $args_ref) = @_; 
#    
#    return _manager_sub_classer(
#        $class, 
#        { 
#            method_p => 'get_',
#            args     => $args_ref
#        }
#    );  
#}
#
#sub get_iterator {
#
#    my ($class, $args_ref) = @_; 
#    
#    return _manager_sub_classer(
#        $class, 
#        { 
#            method_p => 'get_',
#            method_s => '_iterator',
#            args     => $args_ref
#        }
#    );  
#}
#
#
#sub get_count {
#    
#    my ($class, $args_ref) = @_;
#  
#    return _manager_sub_classer(
#        $class, 
#        { 
#            method_p => 'get_',
#            method_s => '_count',
#            args     => $args_ref
#        }
#    );
#}
#
#
#
#
#sub delete {
#
#    my ($class, $args_ref ) = @_; 
#
#    if ($class->id) {
#        $class->SUPER::delete();    
#    }
#    else {
#        return _manager_sub_classer(
#            $class, 
#            { 
#            method_p => 'delete_',
#            args     => $args_ref
#            }
#        );   
#
#    }
#
#}
#
#
#sub _manager_sub_classer {
#
#    my ( $class, $args ) = @_;
#    
#
#    $class =~ /(.*::)([^:]+)/; 
#    my $table = lc($2); 
#    my @args  = ();
#
#    my $method_p = $args->{'method_p'};
#    my $method_s = $args->{'method_s'}; 
#    @args     = @{$args->{'args'}}
#        if ($args->{'args'});
#    
#    my $method = sprintf('%s%s', $method_p, $table);
#
#    $method .= $method_s
#        if ($method_s);
#
#    my $return;
#
#    eval {
#        $return = $class->$method(@args);
#    }; 
#    if ($@) {
#        warn "ADApps::DataObject::Manager methods not loaded in $class"
#    }
#    else {
#        return $return;
#    }
#}



#sub init_db {  ADApps::DB->database('mtrides')  }

sub init_db {

    $DATABASE_CON ||= 'default';

    my $db_obj = ADApps::DB->database($DATABASE_CON);

    return $db_obj;

}

sub load {

    my ($self, $key_vals, $opts ) = @_;

    $key_vals ||= 'unset';

    my $obj;


    if ( $key_vals =~ /HASH/  ) {
    #if ( UNIVERSAL::isa( $key_vals, 'HASH' ) ) {
        $obj = $self->new( %{$key_vals} );
        $opts->{'speculative'} = 1;
        eval { $obj->SUPER::load( %{$opts} ) } ;
        if(!$@) {
            return $obj;
        }
        else {
            return 0;
        }
    }
    elsif ( $key_vals =~ /^[\d]+$/ ) {
        $obj = $self->new( id => "$key_vals" );
        eval { $obj->SUPER::load( speculateive => 1  ) };
        if(!$@) {
            return $obj;
        }
        else {
            warn $@;
            return 0;

        } 

    }
    else {
        shift->SUPER::load(@_);
    }


}


1;
