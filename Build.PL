use strict;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Bot::MetaSyntactic',
    license             => 'perl',
    dist_author         => 'Sébastien Aperghis-Tramoni <sebastien@aperghis.net>',
    dist_version_from   => 'lib/Bot/MetaSyntactic.pm',
    script_files        => [ 'script/metabot' ], 
    requires => {
        'Acme::MetaSyntactic' => '0.12',
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Bot-MetaSyntactic-*' ],
);

$builder->create_build_script();
