# Unity VSCode Base Config

Sets up a directory for a Unity project, for development using VSCode.

**BEWARE: THIS WILL OVERWRITE EXISTING FILES:**
 - `.editorconfig`
 - `.gitignore`
 - `omnisharp.json`

## Quickstart

If you don't want to read the rest of this README, and trust it'll all turn out ok (do read it at least once, so you know what it's doing. After all, you are downloading and extracting a random tarball, then executing a shell script):
```
curl -L https://github.com/Oblongmana/unity-vscode-base-config/tarball/main | tar -zxv --strip-components=1 --exclude='LICENSE' --exclude='README.md'
./scripts/setupVSCodeUnityConfig.sh
```

## Adding to project

This is a github template repo, so can be used with the Web Interface "Use this template" button.

You should be able to use the `gh` cli tool to create a new repo using this one as a template, but it appears bugged at present.

Alternatively (and my preferred approach, especially as it doesn't require a github repo to be created), you could also use curl:
```
# Copies the repo without creating a .git file, by pulling a tarball, and extracting everything except license and readme.
#   If you'd like to include those for some reason, just remove the --exclude items from this command
curl -L https://github.com/Oblongmana/unity-vscode-base-config/tarball/main | tar -zxv --strip-components=1 --exclude='LICENSE' --exclude='README.md'
```

You could of course also clone the repo somewhere, and manually copy the files you want. There's not too many, don't overthink it!

Note that this step will set up `.editorconfig`, and a `.gitignore`, which may initially be out of date.

This will also setup an `omnisharp.json` which won't work out of the box - proceed to the Setup section for that.

## Setup

Run `./scripts/setupVSCodeUnityConfig.sh`

Requires:
 - `jq`
 - Should otherwise be fairly portable, let me know if you use this repo and hit any issues

This adds the `omnisharp.json` config needed to run the `Microsoft.Unity.Analyzers` in VSCode, after retrieving them to a `NuGet` folder.

This will also update a standard Unity `.gitignore`, with the aforementioned Analyzers excluded.

Alternatively, either of those steps can be completed separately with `./scripts/getLatestAnalyzers.sh` and `./scripts/getLatestGitignore.sh`

## Why?

- Running through Unity tutorials leads to a lot of projects being created, each of which requires the setup executed here if you want Unity warnings to appear (and a proper `.gitignore`). This turns that into a trivial task.
- While the official doc is great, it's always easy to miss a step in fiddly multi-step processes (especially when we're using some things not strictly designed for VSCode, but rather Visual Studio).
- Having a convenient way to keep standard .gitignore and Analyzers up-to-date.
- Reducing the amount of fishing around for rules to ignore in `.editorconfig`, while waiting on suppressor support in VSCode for the Unity Analyzers

## TODO:
- Depending on if/when suppressor support lands, possibly worth a script to sync `.editorconfig` with latest