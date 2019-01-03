procedure 'PollEntry', description: 'Polls Remedy entry until it gets to the desired status', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'poll entry',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('poll entry');
""",
        errorHandling: 'failProcedure',
        exclusiveMode: 'none',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'
    
    // [REST Plugin Wizard step ends]
    // [Output Parameters Begin]
formalOutputParameter 'entry', description: 'JSON representation of the entry'
formalOutputParameter 'entryId', description: 'Entry ID'
formalOutputParameter 'status', description: 'Entry status'

    // [Output Parameters End]
}
