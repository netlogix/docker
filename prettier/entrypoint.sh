#!/bin/bash
set -e
exec npx prettier ./code --config ./code/.prettierrc.json --ignore-path ./code/.gitignore --ignore-path ./code/.prettierignore "$@"