def configName = "config",
    pluginName = 'EC-Remedy'

def pluginProjectName = getPlugin(pluginName: pluginName).projectName
runProcedure(
    projectName: pluginProjectName,
    procedureName: 'DeleteConfiguration',
    actualParameter: [
        config    : configName
    ]
)
