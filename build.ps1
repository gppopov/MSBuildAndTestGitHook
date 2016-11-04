# Filename: build.ps1
# MSBuild and xunit.console commands require both executables to be in you environment path.
# MSBuild.exe is usually found in C:\Program Files (x86)\MSBuild\12.0\Bin
# xunit.console.exe can be installed with Chocolatey or Nuget
param([String]$testsProjectFile="",[String]$testsDll="")

clear
echo "`n`n`n`n`n"

if ($testsProjectFile.CompareTo("") -ne 0 -and $testsDll.CompareTo("") -ne 0) {
    Write-Progress -Activity "Precomit build and test..." -Status "Building test project."

    # Build test project (MSBuil.exe path should be in Env variables).
    MSBuild.exe $testsProjectFile | Out-File .\build-log.txt
    Write-Progress -Activity "Precomit build and test..." -Status "Test project built successfully..."
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Test Project Failed to build! " -ForegroundColor Red -BackgroundColor White
        exit $LASTEXITCODE
    }

    # Run xunit tests (xunit.console executable shoulb be installed and path should be in Env variables).
    Write-Progress -Activity "Precomit build and test..." -Status "Running test project."
    xunit.console $testsDll -nologo
    echo "`n"
}

# Build whole solution. This will run even if the tests don't succeed.
Write-Progress -Activity "Precomit build and test..." -Status "Building the solution."
MSBuild.exe | Out-File .\build-log.txt

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n!!! Error building solution, commit canceled. Full error message in build-log.txt !!!" -ForegroundColor Red -BackgroundColor White
    # TODO: improve errors output with some regex matching for the relevant lines.
    $errorMsg = Get-Content ".\build-log.txt" | select -Last 10
    echo $errorMsg
    echo "`n"
    exit $LASTEXITCODE
}

Write-Host "`n  Build successful!`n" -ForegroundColor DarkGreen -BackgroundColor White