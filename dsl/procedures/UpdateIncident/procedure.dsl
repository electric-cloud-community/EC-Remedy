procedure 'UpdateIncident', description: 'Updates Remedy incident', { // [PROCEDURE]
    // [REST Plugin Wizard step]

    step 'update incident',
        command: """
\$[/myProject/scripts/preamble]
use EC::Remedy::Plugin;
EC::Remedy::Plugin->new->run_step('update incident');
""",
        errorHandling: 'failProcedure',
        exclusiveMode: 'none',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'
    
    // [REST Plugin Wizard step ends]
    // [Output Parameters Begin]
formalOutputParameter 'entryId', description: 'Entry ID of the incident'
formalOutputParameter 'incident', description: 'JSON representation of the incident'

    // [Output Parameters End]
}
