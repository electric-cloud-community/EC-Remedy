#!/usr/bin/env bash
find dsl/procedures -name "procedure.dsl" -exec sed -i 's/EC::RESTPlugin/EC::Remedy::Plugin/g' {} \;
