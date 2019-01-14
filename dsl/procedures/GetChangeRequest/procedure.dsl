procedure 'GetChangeRequest', description: 'Get Remedy change request details', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'get change request',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('get change request');
""",
        errorHandling: 'failProcedure',
        exclusiveMode: 'none',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'
    
    // [REST Plugin Wizard step ends]
    // [Output Parameters Begin]
formalOutputParameter 'changeRequest', description: 'JSON representation of the change request'
formalOutputParameter 'entryId', description: 'Entry ID of the change request'

    // [Output Parameters End]
}
