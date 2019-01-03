procedure 'PollEntry', description: 'Polls Remedy entry until it gets to the desired status', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'PollEntry',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('PollEntry');
""",
        errorHandling: 'failProcedure',
        exclusiveMode: 'none',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'
    
    // [REST Plugin Wizard step ends]
    // [Output Parameters Begin]
formalOutputParameter 'entryId', description: 'Entry ID'
formalOutputParameter 'status', description: 'Entry status'
formalOutputParameter 'entry', description: 'JSON representation of the entry'

    // [Output Parameters End]
}
