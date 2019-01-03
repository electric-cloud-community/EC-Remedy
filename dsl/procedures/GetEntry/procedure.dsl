procedure 'GetEntry', description: 'Fetches Remedy entry with the specified form name and entry ID', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'get entry',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('get entry');
""",
        errorHandling: 'failProcedure',
        exclusiveMode: 'none',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'
    
    // [REST Plugin Wizard step ends]
    // [Output Parameters Begin]
formalOutputParameter 'entry', description: 'JSON representation of the incident'
formalOutputParameter 'entryId', description: 'Entry ID'

    // [Output Parameters End]
}
