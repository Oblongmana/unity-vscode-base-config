#!/bin/bash

# Replace the analyzers used by omnisharp, with the latest from NuGet
#    - For Use with VSCode, not Visual Studio

# Automates instructions at https://code.visualstudio.com/docs/other/unity#_enabling-unity-warnings

# Note we can get more sophisticated with the NuGet API, and this is susceptible to changes in URLs,
#   but should be reasonably stable for now.
#   This repo DOES NOT INCLUDE a working version of the Analyzers, to avoid potential licensing issues, and repo bloat.
#   Further, the getLatestGitignore.sh script adds an entry to ignore the packages we retrieve.

echo "Retrieving Unity Analyzers"

# Check for existence of jq
if  ! command -v jq &> /dev/null
then
    echo "jq could not be found, and is required for retrieving latest Unity Analyzers"
    exit 1
fi

nuGetApiFlatContainerUrl="https://api.nuget.org/v3-flatcontainer"
nuGetDirName="NuGet"
lowerPkgId="microsoft.unity.analyzers"

# Get Package Version info from NuGet
# Be wary of this url changing. Can in theory get up-to-date URL by pulling from Catalog using API.
#   That's a lot of steps though, keeping it loose for now and hard-coding the Autocomplete URL that
#   lets us get version info for a known package ID. See https://docs.microsoft.com/en-us/nuget/api/overview for full API info
# Another alternative using autocomplete URL: pkgCurrInfoJson=$(curl -f -s -L "https://azuresearch-usnc.nuget.org/autocomplete?id=${lowerPkgId}")
pkgCurrInfoJson=$(curl -f -s -L "${nuGetApiFlatContainerUrl}/${lowerPkgId}/index.json")
curlPkgInfoResult=$?
if [ $curlPkgInfoResult -ne 0 ]
then
    echo "Error retrieving latest Unity Analyzer version details. Curl error code ${curlPkgInfoResult}"
    exit 1
fi

# echo "$pkgCurrInfoJson"

# Parse latest package version from response
latestPkgVersion=$(jq -e -r '.versions[-1]' <<< "$pkgCurrInfoJson")
jqParseResult=$?
if [ $jqParseResult -ne 0 ]
then
    echo "Error parsing latest Unity Analyzer version details. jq code ${jqParseResult}, parse result ${latestPkgVersion}. Uncomment debugs in the script for further info"
    exit 1
fi

echo "Latest Version is ${latestPkgVersion}. Retrieving"


# Get the actual package
#  Doc: https://docs.microsoft.com/en-us/nuget/api/package-base-address-resource
#  NB an alternative approach where we take the server-supplied name is as follows, though API doc suggests we can reliably determine it ourselves:
#     filename=$(curl -f -s -O -J -L ${pkgUrl} -w '%{filename_effective}')
pkgFileName="${lowerPkgId}.${latestPkgVersion}.nupkg"
pkgUrl="${nuGetApiFlatContainerUrl}/${lowerPkgId}/${latestPkgVersion}/${pkgFileName}"
curl -f -s ${pkgUrl} --output ${pkgFileName}
curlPkgResult=$?
# echo $curlPkgResult

# Unzip the package to the NuGet dir, under a dir with the package's own filename
if [ $curlPkgResult -ne 0 ]
then
    echo "Error retrieving latest Unity Analyzers. Curl error code ${curlResult}"
    exit 1
else
    echo "Retrieved latest Unity Analyzers (${latestPkgVersion}) to ${pkgFileName}. Unzipping"

    zipfile="$pkgFileName"
    zipDirName=$(basename $pkgFileName .nupkg) # Same name, but with stripped extension
    absoluteZipDir="${PWD}/${nuGetDirName}/${zipDirName}"
    # echo $zipfile
    # echo $zipdir
    mkdir -p "$nuGetDirName"
    unzip -d "$absoluteZipDir" "$zipfile"

    if [[ -d "${absoluteZipDir}" ]]
    then
        echo "Removing ${zipfile}"
        rm -f "${zipfile}"
    else
        echo "Error. Unexpectedly did not create ${zipdir}. Exiting"
        exit 1
    fi
fi


# Prepare replacement for the omnisharp.json file to use the latest Analyzers
#   Assumes:
#   - there is an existing unity analyzers entry (if there's none, it won't be added; if there are multiple, they'll all be replaced)
#   - the package structure hasn't changed, dll still lives in analyzers/dotnet/cs
newOmnisharpJson=$(jq -e --arg nuGetDirName "${nuGetDirName}" --arg zipDirName "${zipDirName}" '.RoslynExtensionsOptions.LocationPaths |= map(if contains("microsoft.unity.analyzers") then "./"+$nuGetDirName+"/"+$zipDirName+"/analyzers/dotnet/cs" else . end)' omnisharp.json)
omniSharpJsonReplaceResult=$?
# Uncomment for debugging JSON. Don't use echo for debugging the actual JSON
# jq -r '.' <<< ${newOmnisharpJson}
# echo $omniSharpJsonReplaceResult
if [ $omniSharpJsonReplaceResult -ne 0 ]
then
    echo "Error preparing updated omnisharp.json. jq code ${omniSharpJsonReplaceResult}. Uncomment debugs in the script for further info"
    exit 1
fi

# Updating
echo "Updating omnisharp.json file with latest Unity Analyzers"
printf "%s" "${newOmnisharpJson}" > omnisharp.json

echo "Done."
exit 0