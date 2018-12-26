def configName = "config",
    pluginName = 'EC-Remedy',
    endpoint = 'http://10.200.1.150:5000',
    desc = 'Flask Stub Configuration',
    userName = 'admin',
    password = 'password'

def pluginProjectName = getPlugin(pluginName: pluginName).projectName
runProcedure(
    projectName: pluginProjectName,
    procedureName: 'CreateConfiguration',
    actualParameter: [
        config    : configName,
        desc      : desc,
        endpoint  : endpoint,
        credential: configName
    ],
    credential: [
        credentialName: configName,
        userName      : userName,
        password      : password
    ]
)
