procedure 'PollChangeRequest', description: 'Polls Remedy Change Request until it gets to the desired status', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'poll change request',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('poll change request');
""",
        errorHandling: 'failProcedure',
        exclusiveMode: 'none',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'
    
    // [REST Plugin Wizard step ends]
    // [Output Parameters Begin]
formalOutputParameter 'changeRequest', description: 'JSON representation of the incident'
formalOutputParameter 'entryId', description: 'Entry ID'
formalOutputParameter 'status', description: 'Entry status'

    // [Output Parameters End]
}
