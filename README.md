# Unity VSCode Base Config

Sets up a directory for a Unity project, for development using VSCode.

**BEWARE: THIS WILL OVERWRITE EXISTING FILES:**
 - `.editorconfig`
 - `.gitignore`
 - `omnisharp.json`

## Quickstart

If you don't want to read the rest of this README, and trust it'll all turn out ok:
```
curl -L https://github.com/Oblongmana/unity-vscode-base-config/tarball/main | tar -zxv --strip-components=1 --exclude='LICENSE' --exclude='README'
./scripts/setupVSCodeUnityConfig.sh
```

## Adding to project

This is a github template repo, so can be used with the Web Interface "Use this template" button.

You should be able to use the `gh` cli tool to create a new repo using this one as a template, but it appears bugged at present.

Alternatively (and my preferred approach, especially as it doesn't require a github repo to be created), you could also use curl:
```
# Copies the repo without creating a .git file, by pulling a tarball, and extracting everything except license and readme.
#   If you'd like to include those for some reason, just remove the --exclude items from this command
curl -L https://github.com/Oblongmana/unity-vscode-base-config/tarball/main | tar -zxv --strip-components=1 --exclude='LICENSE' --exclude='README'
```

You could of course also clone the repo somewhere, and manually copy the files you want. There's not too many, don't overthink it!

Note that this step will set up `.editorconfig`, and a `.gitignore`, which may initially be out of date.

This will also setup an `omnisharp.json` which won't work out of the box - proceed to the Setup section for that.

## Setup

Run `./scripts/setupVSCodeUnityConfig.sh`

Requires:
 - `jq`
 - Should otherwise be fairly portable

This adds the `omnisharp.json` config needed to run the `Microsoft.Unity.Analyzers` in VSCode, after retrieving them to a `NuGet` folder.

This will also update a standard Unity `.gitignore`, with the aforementioned Analyzers excluded.

Alternatively, either of those steps can be completed separately with `./scripts/getLatestAnalyzers.sh` and `./scripts/getLatestGitignore.sh`