package EC::Plugin::Hooks;

use strict;
use warnings;
use MIME::Base64 qw(encode_base64);
use JSON;

use base qw(EC::Plugin::HooksCore);


=head1 SYNOPSYS

User-defined hooks

Available hooks types:

    before
    parameters
    request
    response
    parsed
    after

    ua - will be called when User Agent is created

    Accepts step name, hook name, hook code, options

    sub define_hooks {
        my ($self) = @_;

        $self->define_hook('my step', 'before', sub { ( my ($self) = @_; print "I'm before step my step" }, {run_before_shared => 1});
    }


    step name - the name of the step. If value "*" is specified, the hook will be "shared" - it will be executed for every step
    hook name - the name of the hook, see Available hook types
    hook code - CODEREF with the hook code
    options - hook options
        run_before_shared - this hook ("own" step hook) will be executed before shared hook (the one marked with "*")




=head1 SAMPLE


    sub define_hooks {
        my ($self) = @_;

        # step name is 'deploy artifact'
        # hook name is 'request'
        # This hook accepts HTTP::Request object
        $self->define_hook('deploy artifact', 'request', \&deploy_artifact);
    }

    sub deploy_artifact {
        my ($self, $request) = @_;

        # $self is a EC::Plugin::Hooks object. It has method ->plugin, which returns the EC::RESTPlugin object
        my $artifact_path = $self->plugin->parameters($self->plugin->current_step_name)->{filesystemArtifact};

        open my $fh, $artifact_path or die $!;
        binmode $fh;
        my $buffer;
        $self->plugin->logger->info("Writing artifact $artifact_path to the server");

        $request->content(sub {
            my $bytes_read = read($fh, $buffer, 1024);
            if ($bytes_read) {
                return $buffer;
            }
            else {
                return undef;
            }
        });
    }


=cut

# autogen end

sub define_hooks {
    my ($self) = @_;


    # Inserting necessary parameters
    $self->define_hook('*', 'request', \&expand_generic_parameters);
    $self->define_hook('*', 'response', \&parse_json_error);
    $self->define_hook('poll entry', 'after', \&poll_entry);
    $self->define_hook('poll incident', 'after', \&poll_incident);
    $self->define_hook('poll change request', 'after', \&poll_change_request);
    $self->define_hook('get incident', 'after', \&get_incident_parsed);
    $self->define_hook('get entry', 'after', \&get_entry_parsed);
    $self->define_hook('create incident', 'response', \&create_incident_response);
    $self->define_hook('update incident', 'response', \&update_incident_response);
    $self->define_hook('create change request', 'response', \&create_change_request_response);
    $self->define_hook('create entry', 'parameters', \&create_entry_params);
    $self->define_hook('update entry', 'parameters', \&create_entry_params);
    $self->define_hook('create entry', 'response', \&create_entry_response);
    $self->define_hook('update entry', 'response', \&update_entry_response);
}


sub create_entry_params {
    my ($self, $params) = @_;

    my $values;
    eval {
        $values = decode_json($params->{values});
        1;
    } or do{
        $self->plugin->bail_out("Values should be a valid JSON object: $@");
    };

    unless($values->{values}) {
        $values = {values => $values};
    }

    $params->{values} = encode_json($values);
    return $params;
}


sub update_entry_response {
    my ($self, $response) = @_;

    $self->plugin->run_one_step('get entry');
}

sub create_entry_response {
    my ($self, $response) = @_;

    unless($response->is_success) {
        return;
    }
    my $url = $response->header('Location');
    my $entry_id = $self->get_entry_id($url);
    my $entry = $self->get_entry_from_url($url);

    $self->plugin->ec->setOutputParameter('entry', JSON->new->utf8->pretty->encode($entry));
    $self->plugin->ec->setOutputParameter('entryId', $entry_id);

    $self->plugin->set_summary("Successfully created entry $entry_id");
}

sub get_entry_parsed {
    my ($self, $data) = @_;

    my $values = $data->{values};
    my $entry_id = $self->plugin->parameters->{entry_id};
    my $form = $self->plugin->parameters->{form_name};
    $self->plugin->ec->setOutputParameter('incident', JSON->new->pretty->encode($values));
    $self->plugin->ec->setOutputParameter('entryId', $entry_id);
    $self->plugin->logger->info("Got Entry: ", $values);
    $self->plugin->set_summary("Retrieved entry $form :: $entry_id");
}

sub poll_entry {
    my ($self, $data) = @_;

    my $params = $self->plugin->parameters;
    my $status_field = $params->{status_field};
    my $interval = $params->{poll_interval};
    my $timeout = $params->{polling_timeout};
    my $expected_status = $params->{expected_status};

    my $status = $data->{values}->{$status_field};
    my $elapsed = $self->{polling_elapsed} ||= 0;

    $self->plugin->ec->setOutputParameter('status', $status);
    $self->plugin->ec->setOutputParameter('entry', JSON->new->pretty->encode($data->{values}));
    $self->plugin->ec->setOutputParameter('entryId', $params->{entry_id});

    if ($status ne $expected_status) {

        if ($timeout && $elapsed > $timeout) {
            # This will end the step execution
            $self->plugin->bail_out("Polling timeout, the last status is $status");
        }
        # This is a sort of recursion
        $self->plugin->logger->info("Status is $status, polling (elapsed time is $elapsed seconds)...");

        sleep($interval);
        $elapsed += $interval;
        $self->{polling_elapsed} = $elapsed;
        $self->plugin->run_one_step($self->plugin->current_step_name);
    }
    else {
        $self->plugin->set_summary("Status is $status");
    }

}

# TODO squash into one method
sub poll_incident {
    my ($self, $data) = @_;

    my $params = $self->plugin->parameters;
    my $status_field = 'Status';
    my $interval = $params->{poll_interval};
    my $timeout = $params->{polling_timeout};
    my $expected_status = $params->{expected_status};

    my $status = $data->{values}->{$status_field};
    my $elapsed = $self->{polling_elapsed} ||= 0;

    $self->plugin->ec->setOutputParameter('status', $status);
    $self->plugin->ec->setOutputParameter('incident', JSON->new->pretty->encode($data->{values}));
    $self->plugin->ec->setOutputParameter('entryId', $params->{entry_id});

    if ($status ne $expected_status) {

        if ($timeout && $elapsed > $timeout) {
            # This will end the step execution
            $self->plugin->bail_out("Polling timeout, the last status is $status");
        }
        # This is a sort of recursion
        $self->plugin->logger->info("Status is $status, polling (elapsed time is $elapsed seconds)...");

        sleep($interval);
        $elapsed += $interval;
        $self->{polling_elapsed} = $elapsed;
        $self->plugin->run_one_step($self->plugin->current_step_name);
    }
    else {
        $self->plugin->set_summary("Status is $status");
    }

}


# TODO squash into one method
sub poll_change_request {
    my ($self, $data) = @_;

    my $params = $self->plugin->parameters;
    my $status_field = 'Status';
    my $interval = $params->{poll_interval};
    my $timeout = $params->{polling_timeout};
    my $expected_status = $params->{expected_status};

    my $status = $data->{values}->{$status_field};
    my $elapsed = $self->{polling_elapsed} ||= 0;

    $self->plugin->ec->setOutputParameter('status', $status);
    $self->plugin->ec->setOutputParameter('changeRequest', JSON->new->pretty->encode($data->{values}));
    $self->plugin->ec->setOutputParameter('entryId', $params->{entry_id});

    if ($status ne $expected_status) {

        if ($timeout && $elapsed > $timeout) {
            # This will end the step execution
            $self->plugin->bail_out("Polling timeout, the last status is $status");
        }
        # This is a sort of recursion
        $self->plugin->logger->info("Status is $status, polling (elapsed time is $elapsed seconds)...");

        sleep($interval);
        $elapsed += $interval;
        $self->{polling_elapsed} = $elapsed;
        $self->plugin->run_one_step($self->plugin->current_step_name);
    }
    else {
        $self->plugin->set_summary("Status is $status");
    }

}


sub expand_generic_parameters {
    my ($self, $request) = @_;

    my $parameters = $self->plugin->parameters();

    my %req_params = $request->uri->query_form();

    if ($parameters->{fields}){
        $req_params{fields} = "values($parameters->{fields})";
    }
    if ($parameters->{expand}){
        # $req_params{}
    }

    $request->uri->query_form(%req_params);

    return $request;
}


sub parse_json_error {
    my ($self, $response) = @_;

    return if $response->is_success;

    my $json;
    eval {
        $json = decode_json($response->content);
        1;
    } or do {
        return;
    };

    my $formatted_response = JSON->new->utf8->pretty->encode($json);
    $self->plugin->logger->info('Got error', $formatted_response);
    my $message = $json->{message};
    if ($message) {
        $self->plugin->bail_out($message);
    }
}

sub get_entry_id {
    my ($self, $url) = @_;

    my $uri = URI->new($url);
    my @segments = reverse $uri->path_segments;
    my $entry_id = $segments[0];
    return $entry_id;
}


sub get_entry_from_url {
    my ($self, $url) = @_;

    my $request = $self->plugin->get_new_http_request('GET', $url);
    my $response = $self->plugin->request($self->plugin->current_step_name, $request);

    if ($response->is_success) {
        my $values = decode_json($response->content)->{values};
        $self->plugin->logger->info("Got Entry", $values);
        return $values;
    }
    else {
        $self->plugin->bail_out("Request failed: " . $response->status_line);
    }
}


sub get_incident_parsed {
    my ($self, $data) = @_;

    my $values = $data->{values};
    my $entry_id = $self->plugin->parameters->{entry_id};
    $self->plugin->ec->setOutputParameter('incident', JSON->new->pretty->encode($values));
    $self->plugin->ec->setOutputParameter('entryId', $entry_id);
    $self->plugin->logger->info("Got Incident: ", $values);
    $self->plugin->set_summary("Retrieved entry $entry_id");
}


sub create_incident_response {
    my ($self, $response) = @_;

    return if $response->is_error;
    my $url = $response->header('Location');

    if ($url) {
        $self->plugin->ec()->setProperty('/myJobStep/URL', $url);

        my $uri = URI->new($url);
        my @segments = reverse $uri->path_segments;
        my $entry_id = $segments[0];

        my $request = $self->plugin->get_new_http_request('GET', $url);
        $response = $self->plugin->request($self->plugin->current_step_name, $request);
        if ($response->is_success) {
            my $values = decode_json($response->content)->{values};
            $self->plugin->logger->info("Got Incident", $values);
            $self->plugin->ec->setOutputParameter('incident', JSON->new->pretty->utf8->encode($values));
            $self->plugin->ec->setOutputParameter('entryId', $entry_id);
        }
        else {
            $self->plugin->bail_out("Request failed: " . $response->status_line);
        }
    }
    else {
        $self->plugin->warning('URL not found for created incident.');
    }
}


sub update_incident_response {
    my ($self, $response) = @_;
    return if $response->is_error;
    $self->plugin->run_one_step('get incident');
}


sub create_change_request_response {
    my ($self, $response) = @_;

    return if $response->is_error;
    my $url = $response->header('Location');

    if ($url) {
        $self->plugin->ec()->setProperty('/myJobStep/URL', $url);

        my $uri = URI->new($url);
        my @segments = reverse $uri->path_segments;
        my $entry_id = $segments[0];

        my $request = $self->plugin->get_new_http_request('GET', $url);
        $response = $self->plugin->request($self->plugin->current_step_name, $request);
        if ($response->is_success) {
            my $values = decode_json($response->content)->{values};
            $self->plugin->logger->info("Got Change Request", $values);
            $self->plugin->ec->setOutputParameter('changeRequest', JSON->new->pretty->utf8->encode($values));
            $self->plugin->ec->setOutputParameter('entryId', $entry_id);
        }
        else {
            $self->plugin->bail_out("Request failed: " . $response->status_line);
        }
    }
    else {
        $self->plugin->warning('URL not found for created incident.');
    }
}
1;
