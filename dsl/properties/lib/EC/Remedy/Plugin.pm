package EC::Remedy::Plugin;
use strict;
use warnings FATAL => 'all';

use base 'EC::RESTPlugin';

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;

use Data::Dumper;

sub after_init_hook {
    my ( $self, %params ) = @_;

    # Get token and apply authorization header
    $self->{auth_type} = {
        ua      => sub {return 1},
        request => sub {$self->apply_token(shift);}
    };

    return $self->SUPER::after_init_hook(%params);
};

sub apply_token {
    my ( $self, $request ) = @_;

    # Perform authentication
    my $token = $self->get_token();

    if (! $token) {
        $self->bail_out("Failed to get token. Please check credentials.");
    }

    $request->headers->header('Authorization', 'AR-JWT ' . $token);

    return $request;
}

sub get_token {
    my ( $self ) = @_;

    my $config_name = $self->get_param('config');
    my $config = $self->get_config_values($config_name);

    # Cannot use default methods because of recursion
    my LWP::UserAgent $lwp = LWP::UserAgent->new();
    my $token_request_uri = $config->{endpoint} . '/api/jwt/login';
    $self->logger->debug("Token URI : $token_request_uri");

    my HTTP::Request $request = HTTP::Request->new('POST', $token_request_uri);
    $request->headers->header('Content-Type', 'application/x-www-form-urlencoded');

    my %content = (
        username => $config->{userName},
        password => $config->{password}
    );

    if ($config->{authString}) {
        $content{authString} = $config->{authString};
    }

    my @query_params = ();
    for my $key (keys %content) {
        push @query_params, ( url_encode($key) . '=' . url_encode($content{$key}) )
    }

    # Adding pairs
    $request->add_content(join('&', @query_params));

    my HTTP::Response $response = $lwp->request($request);

    if ($response->is_success()) {
        my $token = $response->decoded_content();
        return $token;
    }

    print "Token request failed with status:" . $response->status_line() . "\n";

    return 0;
}

sub url_encode {
    my ( $str ) = @_;
    $str =~ s/([^0-9A-Za-z])/sprintf("%%%02lX", unpack('C', $1))/eg;
    return $str;
}

1;
