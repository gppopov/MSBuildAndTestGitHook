# Build helper script

This is a very basic powershell script that can be used with git hooks to run your xunit tests and then build your solution. To use add this to your git hook (on a single line):

```powershell
exec powershell.exe -NoProfile -ExecutionPolicy Bypass `
-File "path-to-this-script" `
-testsProjectFile "path-to-unit-tests-project-file" `
-testsDll "path-to-unit-tests-dll"
```

For example in my current solution the parameters look like this:

```powershell
exec powershell.exe -NoProfile -ExecutionPolicy Bypass `
-File "..\..\tools\buildtools\build.ps1" `
-testsProjectFile ".\UnitTesting\UnitTesting.csproj" `
-testsDll ".\UnitTesting\bin\Debug\UnitTesting.dll"
```

For this script to work the MSBuild.exe and xunit.console.exe must be in the path of the environment and accessible for use from the console/powershell. MSBuild.exe is usually found in `C:\Program Files (x86)\MSBuild\12.0\Bin` and xunit executable can be installed with Chocolatey like `choco install XUnit` assuming you have the choco bins in your path.

I usually use the pre-commit hook to run this script but depending on your committing policy you might want to allow some commits that break the code or don't pass all tests. Then probably you should use the pre-push hook.