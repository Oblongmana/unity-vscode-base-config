# Unity VSCode Base Config

Sets up a directory for a Unity project, for development using VSCode.

**BEWARE: THIS WILL OVERWRITE EXISTING FILES:**
 - `.editorconfig`
 - `.gitignore`
 - `omnisharp.json`
 - `Assets/Editor/EditorShortcutKeys.cs`

## Table of Contents
- [Quickstart](#quickstart)
- [Adding to project](#adding-to-project)
- [Setup](#setup)
- [Why?](#why)
- [Sources:](#sources)
- [TODO:](#todo)

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

**As noted in the warning above, this creates the following files, or will overwrite existing ones. If you're doing this into an existing project, I suggest committing first, and checking the diff after.**
 - `.editorconfig`
 - `.gitignore`
 - `omnisharp.json`
 - `Assets/Editor/EditorShortcutKeys.cs`

Note that as this step copies this repo, it sets up `.editorconfig`, and a `.gitignore`, which may initially be out of date (and can be updated in the next section).

The `omnisharp.json` won't work out of the box - proceed to the Setup section for that.

The `EditorShortcutKeys.cs` file just lets you press F5 to Play/Stop - feel free to delete it if you're fine with defaults (Ctrl + P or clicking the Play Button).
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
- While the official doc is great (https://code.visualstudio.com/docs/other/unity#_enabling-unity-warnings), it's always easy to miss a step in fiddly multi-step processes, especially when we're using some things not strictly designed for VSCode, but rather Visual Studio
- Having a convenient way to keep standard .gitignore and Analyzers up-to-date.
- Reducing the amount of fishing around for rules to ignore in `.editorconfig`, while waiting on suppressor support in VSCode for the Unity Analyzers
- I personally don't like pressing Ctrl + P to run/stop. F5 is better.

## Sources:
- Official Doc for setting up Analyzers: https://code.visualstudio.com/docs/other/unity#_enabling-unity-warnings
- General additional rules for `.editorconfig`: https://www.reddit.com/r/Unity3D/comments/kbonih/how_to_enable_unity_warnings_in_visual_studio_code/
- Rules for `.editorconfig` around unused methods: https://developercommunity.visualstudio.com/t/ide0052-identifies-unity-method-update-as-never-ca/1299963
- Unity `.gitignore` is pulled by scripts from: https://github.com/github/gitignore
- Microsoft.Unity.Analyzers analyzers are pulled from NuGet (human-friendly page: https://www.nuget.org/packages/Microsoft.Unity.Analyzers/) using NuGet API (https://docs.microsoft.com/en-us/nuget/api)
- F5 to Play/Stop: https://support.unity.com/hc/en-us/articles/210719486-Enter-Play-Mode-with-F5-key

## TODO:
- Depending on if/when suppressor support lands, possibly worth a script to sync `.editorconfig` with latest