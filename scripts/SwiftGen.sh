#!/bin/bash

swiftgen="../Pods"/SwiftGen/bin/swiftgen
if [ -f "$swiftgen" ]; then
    "$swiftgen" config run --config "$1"
fi
