# Unity VSCode Base Config

Tools for project config for Unity development using VSCode.

This is an abbreviated version of the doc available at https://github.com/Oblongmana/unity-vscode-base-config/blob/main/README.md

## Tools directory

**BEWARE: THIS WILL OVERWRITE EXISTING FILES:**
 - `.editorconfig`
 - `.gitignore`
 - `omnisharp.json`
 - `Assets/Editor/EditorShortcutKeys.cs`

Run from project root.

Requires:
 - `jq`
 - Should otherwise be fairly portable, let me know if you use this repo and hit any issues

The tools directory provides the following scripts:
1. `./tools/setupVSCodeUnityConfig.sh` - Runs scripts 2 & 3 below
2. `./tools/getLatestAnalyzers.sh` - This adds the `omnisharp.json` config needed to run the `Microsoft.Unity.Analyzers` in VSCode, after retrieving them to a `NuGet` folder.
3. `./tools/getLatestGitignore.sh` - This will also update a standard Unity `.gitignore`, with the aforementioned Analyzers excluded.
