#!/bin/bash

# Replace your current .gitignore with the latest from https://github.com/github/gitignore
#    Suggest closely reviewing diff after executing this

echo "Retrieving Latest Unity base .gitignore"

latestGitIgnore=$(curl -f -s -L -H 'Accept: application/vnd.github.v3.raw' https://api.github.com/repos/github/gitignore/contents/Unity.gitignore)
curlResult=$?

if [ $curlResult -ne 0 ]
then
    echo "Error retrieving latest .gitignore. Curl error code ${curlPkgInfoResult}"
    exit 1
fi

echo "Retrieved. Appending Analyzer exclusion and writing to local .gitignore"

latestGitIgnoreWithAnalyzerIgnore="${latestGitIgnore}

# Exclude latest Analyzers from the repo
NuGet/"
# echo $latestGitIgnoreWithAnalyzerIgnore

printf "%s" "${latestGitIgnoreWithAnalyzerIgnore}" > .gitignore

echo Done.

exit 0