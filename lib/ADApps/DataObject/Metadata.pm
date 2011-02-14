package ADApps::DataObject::Metadata;

use strict;
use warnings;
use base "Rose::DB::Object::Metadata";
use ADApps::DataObject::Validate;

sub setup {

    my ($class, @setup) = @_;
    ADApps::DataObject::Validate->validate(@setup);
    shift->SUPER::setup(@_);

}

1;
