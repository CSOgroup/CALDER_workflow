#!/bin/bash

release_version=$(curl -s https://github.com/aidenlab/Juicebox/releases/latest \
					| grep "https://github.com/aidenlab/Juicebox/releases/tag/*" \
					| cut -d '"' -f2 \
					| rev \
					| cut -d '/' -f 1 \
					| rev)

juicer_tools_url="https://github.com/aidenlab/Juicebox/releases/download/${release_version}/juicer_tools.jar"
wget ${juicer_tools_url}

