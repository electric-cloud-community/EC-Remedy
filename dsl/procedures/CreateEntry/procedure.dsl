procedure 'CreateEntry', description: 'Creates Remedy entry', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'create entry',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('create entry');
""",
        errorHandling: 'failProcedure',
        exclusiveMode: 'none',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'
    
    // [REST Plugin Wizard step ends]
    // [Output Parameters Begin]
formalOutputParameter 'entry', description: 'JSON representation of the created entry'
formalOutputParameter 'entryId', description: 'Entry ID of the created entry'

    // [Output Parameters End]
}
