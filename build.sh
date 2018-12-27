#!/usr/bin/env bash

SERVER=nick
PLUGIN_NAME=EC-Remedy
PLUGIN_VERSION=1.0.0

echo "Building $PLUGIN_NAME-$PLUGIN_VERSION"
ecpluginbuilder --plugin-version $PLUGIN_VERSION --plugin-name $PLUGIN_NAME --folder dsl,htdocs,pages,META-INF || exit 1;

uninstall(){
  echo "Uninstalling $PLUGIN_NAME-$PLUGIN_VERSION"
  ectool uninstallPlugin $PLUGIN_NAME-$PLUGIN_VERSION
}

if [ x"$1" = "x--uninstall" ]; then
  uninstall || exit 1;
fi;

echo "Login to server ${SERVER}"
ectool --server ${SERVER} login admin changeme || exit 1;
ectool installPlugin build/$PLUGIN_NAME.zip || exit 1;

echo "Installed, started promote"
ectool promotePlugin $PLUGIN_NAME-$PLUGIN_VERSION || exit 1;
ectool setProperty /projects/$PLUGIN_NAME-$PLUGIN_VERSION/debugLevel 10