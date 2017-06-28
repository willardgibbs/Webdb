use strict;
use warnings;

use Webdb;
use Test::More tests => 2;
use Plack::Test;
use HTTP::Request::Common;

my $app = Webdb->to_app;
is( ref $app, 'CODE', 'Got app' );

my $url = "localhost:5000";
my $bd_name = "webdb";
my $table = "users";
my $id = 1;

my $test = Plack::Test->create($app);
my $res  = $test->request( GET "http://$url/$bd_name/$table/$id" );

ok( $res->is_success, "[GET http://$url/$bd_name/$table/$id] successful" );