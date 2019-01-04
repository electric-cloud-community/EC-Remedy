procedure 'GetIncident', description: 'Get Remedy incident details', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'get incident',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('get incident');
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

    // [Output Parameters End]
}
