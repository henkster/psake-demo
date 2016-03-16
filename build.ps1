cls

# '[p]sake is the same as 'psake' but $Error is not pulluted
Remove-Module [p]sake

# this section future-proofs in case multiple side-by-side versions available (not likely)
# Import-Module ..\packages\psake.*\tools\psake.psm1 <-- this *could* be an issue

# find psake's path
$psakeModule = (Get-ChildItem (".\packages\psake*\tools\psake.psm1")).FullName | Sort-Object $_ | select -Last 1

#Import-Module $psakeModule
Import-Module $psakeModule

Invoke-psake -buildFile .\Build\default.ps1 `
             -taskList Test `
             -framework 4.5.2 `
             -properties @{
               "buildConfiguration" = "Release"
               "buildPlatform" = "Any CPU"} `
             -parameters @{"solutionFile"="..\psake.sln"} #TODO Can remove quotes from testMessage (like with solutionFile - what is correct?

Write-Host "Build exit code: $LastExitCode"

#Propogating the exist code so that builds actually fail when there is a problem.
exit $LastExitCode