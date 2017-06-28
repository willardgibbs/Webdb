#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use Webdb;

Webdb->to_app;

use Plack::Builder;

builder {
    enable 'Deflater';
    Webdb->to_app;
}



=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use Webdb;
use Plack::Builder;

builder {
    enable 'Deflater';
    Webdb->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use Webdb;
use Webdb_admin;

builder {
    mount '/'      => Webdb->to_app;
    mount '/admin'      => Webdb_admin->to_app;
}

=end comment

=cut

