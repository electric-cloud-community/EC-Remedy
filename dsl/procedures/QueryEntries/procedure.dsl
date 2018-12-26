procedure 'QueryEntries', description: 'Retrieves a list of Remedy entries', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'query entries',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('query entries');
""",
        errorHandling: 'failProcedure',
        exclusiveMode: 'none',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'
    
    // [REST Plugin Wizard step ends]

}
