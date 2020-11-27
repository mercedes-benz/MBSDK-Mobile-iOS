#!/bin/bash

swiftlint="../Pods"/SwiftLint/swiftlint
if [ -f "$swiftlint" ]; then
    "$swiftlint" --config "$1"
fi
