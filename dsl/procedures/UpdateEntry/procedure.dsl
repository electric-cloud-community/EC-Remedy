procedure 'UpdateEntry', description: 'Updates Remedy entry', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'update entry',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('update entry');
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

    // [Output Parameters End]
}
