use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'ADApps::Blob',
    license             => 'perl',
    dist_author         => 'adorfman <adorfman@mediatemple.net>',
    dist_version_from   => 'lib/ADApps/Blob.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'ADApps-Blob-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
