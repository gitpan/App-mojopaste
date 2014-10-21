use warnings;
use strict;
use Test::More;
use Test::Mojo;

$ENV{PASTE_DIR} = 't/paste';
$ENV{PASTE_ALLOW_ROBOTS} = 1;

plan skip_all => $@ unless eval { require 'mojopaste' };

my $t = Test::Mojo->new;
my $content = "var foo = 123; # cool!\n";

plan skip_all => "$ENV{PASTE_DIR} was not created" unless -d $ENV{PASTE_DIR};

{
  $t->get_ok('/')
    ->status_is(200)
    ->element_exists('form[method="post"][action="/"]')
    ->element_exists('button')
    ->element_exists('a[href="https://metacpan.org/release/App-mojopaste"]')
    ->element_exists_not('a.button')
    ;

  $t->post_ok('/', form => { content => $content })
    ->status_is(302)
    ->header_like('Location', qr,:\d+/\w{12}$,)
    ;

  unlink glob "$ENV{PASTE_DIR}/*";
}

done_testing;
