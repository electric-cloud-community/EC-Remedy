procedure 'PollIncident', description: 'Polls Remedy Incident until it gets to the desired status', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'poll incident',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('poll incident');
""",
        errorHandling: 'failProcedure',
        exclusiveMode: 'none',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'
    
    // [REST Plugin Wizard step ends]
    // [Output Parameters Begin]
formalOutputParameter 'entryId', description: 'Entry ID'
formalOutputParameter 'incident', description: 'JSON representation of the incident'
formalOutputParameter 'status', description: 'Entry status'

    // [Output Parameters End]
}
