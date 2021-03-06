package EC::Plugin::ContentProcessor;

use strict;
use warnings;
use JSON;
use Data::Dumper;

use base qw(EC::Plugin::ContentProcessorCore);


=head1 SYNOPSYS

Here one can define custom processors for request & response. E.g., request
is not a plain JSON object but a file, or response does not contain JSON.

By default we assume that request body should be in JSON format and
response returns JSON as well.


Two processors can be defined:
    serialize_body - which will be used to serialize request body
    parse_response - which will be used to parse the content of the response

Code may look like the following:

    use constant {
        RETRIEVE_ARTIFACT => 'retrieve artifact',
        DEPLOY_ARTIFACT => 'deploy artifact',
    };


    sub define_processors {
        my ($self) = @_;

        $self->define_processor(DEPLOY_ARTIFACT, 'serialize_body', \&deploy_artifact);
        $self->define_processor(RETRIEVE_ARTIFACT, 'parse_response', \&download_artifact);
    }

    sub deploy_artifact {
        my ($self, $body) = @_;

        my $path = $body->{filesystemArtifact};

        open my $fh, $path or die "Cannot open $path: $!";
        binmode $fh;

        my $data = '';
        my $buffer;
        while( my $bytes_read = read($fh, $buffer, 1024)) {
            $data .= $buffer;
        }

        close $fh;


        # Here we return file content instead of JSON object
        return $data;
    }

    sub download_artifact {
        my ($self, $response) = @_;

        my $directory = $self->plugin->parameters(RETRIEVE_ARTIFACT)->{destination};

        $self->plugin->logger->debug("Destintion is $directory");
        my $filename = $response->header('x-artifactory-filename');


        my $dest_filename = $directory ? "$directory/$filename" : $filename;

        # And here we write a file instead of parsing response body as JSON

        open my $fh, ">$dest_filename" or die "Cannot open $dest_filename: $!";
        print $fh $response->content;
        close $fh;

        $self->plugin->logger->info("Artifact $dest_filename is saved");
        $self->plugin->set_summary("Artifact $dest_filename is saved");
    }


=cut


# autogen code ends here

use Data::Dumper;

sub define_processors {
    my ($self) = @_;
    $self->define_processor('create entry',          'serialize_body', \&raw_body);
    $self->define_processor('update entry',          'serialize_body', \&raw_body);
    $self->define_processor('create incident',       'serialize_body', \&create_incident_body);
    $self->define_processor('update incident',       'serialize_body', \&update_incident_body);
    $self->define_processor('create change request', 'serialize_body', \&create_change_request_body);
    $self->define_processor('update change request', 'serialize_body', \&update_change_request_body);
}


sub create_incident_body {
    my ($self, $body) = @_;

    my $data = { values => {} };
    if($body->{values}) {
        $data->{values} = decode_json($body->{values});
        if(!$data->{values}->{'z1D_Action'}) {
            $data->{values}->{'z1D_Action'} = 'CREATE';
        }
    }

    $data->{values}->{'Description'}     = $body->{description};
    $data->{values}->{'First_Name'}      = $body->{first_name};
    $data->{values}->{'Last_Name'}       = $body->{last_name};
    $data->{values}->{'Impact'}          = $body->{impact};
    $data->{values}->{'Status'}          = $body->{incident_status};
    $data->{values}->{'Urgency'}         = $body->{urgency};
    $data->{values}->{'Reported Source'} = $body->{reported_source};
    $data->{values}->{'Service_Type'}    = $body->{service_type};

    my $json = encode_json($data);
    return $json;
}


sub update_incident_body {
    my ($self, $body) = @_;

    my $data = { values => {} };
    if($body->{values}) {
        $data->{values} = decode_json($body->{values});
        if(!$data->{values}->{'z1D_Action'}) {
            $data->{values}->{'z1D_Action'} = 'MODIFY';
        }
    }

    $data->{values}->{'Description'} = $body->{description}     if defined $body->{description}; 
    $data->{values}->{'First_Name'}  = $body->{first_name}      if defined $body->{first_name}; 
    $data->{values}->{'Last_Name'}   = $body->{last_name}       if defined $body->{last_name}; 
    $data->{values}->{'Impact'}      = $body->{impact}          if defined $body->{impact}; 
    $data->{values}->{'Status'}      = $body->{incident_status} if defined $body->{incident_status}; 
    $data->{values}->{'Urgency'}     = $body->{urgency}         if defined $body->{urgency}; 

    my $json = encode_json($data);
    return $json;
}


sub create_change_request_body {
    my ($self, $body) = @_;

    my $data = { values => {} };
    if($body->{values}) {
        $data->{values} = decode_json($body->{values});
        if(!$data->{values}->{'z1D_Action'}) {
            $data->{values}->{'z1D_Action'} = 'CREATE';
        }
    }

    $data->{values}->{'Description'}      = $body->{description};
    $data->{values}->{'First Name'}       = $body->{first_name};
    $data->{values}->{'Last Name'}        = $body->{last_name};
    $data->{values}->{'Impact'}           = $body->{impact};
    $data->{values}->{'Status'}           = $body->{cr_status};
    $data->{values}->{'Urgency'}          = $body->{urgency};
    $data->{values}->{'Location Company'} = $body->{location_company};

    my $json = encode_json($data);
    return $json;
}


sub update_change_request_body {
    my ($self, $body) = @_;

    my $data = { values => {} };
    if($body->{values}) {
        $data->{values} = decode_json($body->{values});
        if(!$data->{values}->{'z1D_Action'}) {
            $data->{values}->{'z1D_Action'} = 'MODIFY';
        }
    }

    $data->{values}->{'Description'}      = $body->{description}      if defined $body->{description}; 
    $data->{values}->{'First Name'}       = $body->{first_name}       if defined $body->{first_name}; 
    $data->{values}->{'Last Name'}        = $body->{last_name}        if defined $body->{last_name}; 
    $data->{values}->{'Impact'}           = $body->{impact}           if defined $body->{impact}; 
    $data->{values}->{'Status'}           = $body->{cr_status}        if defined $body->{cr_status}; 
    $data->{values}->{'Urgency'}          = $body->{urgency}          if defined $body->{urgency};
    $data->{values}->{'Location Company'} = $body->{location_company} if defined $body->{location_company};

    my $json = encode_json($data);
    return $json;
}


sub raw_body {
    my ($self, $body) = @_;
    my $data = $body->{values}; 
    return $data;
}

1;
