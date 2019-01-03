import groovy.transform.BaseScript
import com.electriccloud.commander.dsl.util.BasePlugin

//noinspection GroovyUnusedAssignment
@BaseScript BasePlugin baseScript

// Variables available for use in DSL code
def pluginName = args.pluginName
def upgradeAction = args.upgradeAction
def otherPluginName = args.otherPluginName

def pluginKey = getProject("/plugins/$pluginName/project").pluginKey
def pluginDir = getProperty("/projects/$pluginName/pluginDir").value

//List of procedure steps to which the plugin configuration credentials need to be attached
// ** steps with attached credentials
def stepsWithAttachedCredentials = [
  [procedureName: 'Create Change Request', stepName: 'create change request'],
  [procedureName: 'CreateEntry', stepName: 'create entry'],
  [procedureName: 'CreateIncident', stepName: 'create incident'],
  [procedureName: 'GetIncidentStatus', stepName: 'get incident status'],
  [procedureName: 'PollEntry', stepName: 'PollEntry'],
  [procedureName: 'PollEntry', stepName: 'poll entry'],
  [procedureName: 'QueryEntries', stepName: 'query entries'],
  [procedureName: 'UpdateChangeRequest', stepName: 'update change request'],
  [procedureName: 'UpdateEntry', stepName: 'update entry'],
  [procedureName: 'UpdateIncident', stepName: 'update incident']
]
// ** end steps with attached credentials

project pluginName, {

    property 'ec_formXmlCompliant', value: 'true'

	loadPluginProperties(pluginDir, pluginName)
	loadProcedures(pluginDir, pluginKey, pluginName, stepsWithAttachedCredentials)
	//plugin configuration metadata
	property 'ec_config', {
		form = '$[' + "/projects/${pluginName}/procedures/CreateConfiguration/ec_parameterForm]"
		property 'fields', {
			property 'desc', {
				property 'label', value: 'Description'
				property 'order', value: '1'
			}
		}
        configLocation = 'ec_plugin_cfgs'
	}

}

// Copy existing plugin configurations from the previous
// version to this version. At the same time, also attach
// the credentials to the required plugin procedure steps.
upgrade(upgradeAction, pluginName, otherPluginName, stepsWithAttachedCredentials)
