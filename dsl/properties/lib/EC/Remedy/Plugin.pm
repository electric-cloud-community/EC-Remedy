package EC::Remedy::Plugin;
use strict;
use warnings FATAL => 'all';

use base 'EC::RESTPlugin';

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;

use Data::Dumper;

sub get_token {
    my ( $self ) = @_;

    my $config_name = $self->get_param('config');
    my $config = $self->get_config_values($config_name);

    my LWP::UserAgent $lwp = $self->new_lwp($config);
    my HTTP::Request $request = $self->get_new_http_request('POST', '/api/jwt/login');

    my %content = (
        username => $config->{userName},
        password => $config->{password}
    );

    if ($config->{authString}) {
        $content{authString} = $config->{authString};
    }

    my @query_params = ();
    for my $key (keys %content){
        push @query_params, (url_encode($key) . '=' . url_encode($content{$key}))
    }

    # Adding pairs
    $request->add_content(join('&', @query_params));

    my HTTP::Response $response = $lwp->request($request);

    if ($response->is_success()){
        my $token = $response->decoded_content();
        return $token;
    }

    print "Token request failed with status:" . $response->status_line() . "\n";
    print Dumper $response;

    return 0;
}

sub url_encode {
    my ($str) = @_;
    $str =~ s/([^0-9A-Za-z])/sprintf("%%%02lX",unpack('C',$1))/eg;
    return $str;
}

1;