procedure 'UpdateChangeRequest', description: 'Updates Remedy change request', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'update change request',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('update change request');
""",
        errorHandling: 'failProcedure',
        exclusiveMode: 'none',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'
    
    // [REST Plugin Wizard step ends]
    // [Output Parameters Begin]

    // [Output Parameters End]
}
