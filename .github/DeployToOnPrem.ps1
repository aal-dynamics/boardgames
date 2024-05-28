Param(
    [Parameter(HelpMessage = "Parameters", Mandatory = $true)]
    [hashtable] $parameters
)
$EnvironmentName = $parameters.EnvironmentName

$deployAppsPath = 'C:\Deployment'
$containerName = 'bcOnPrem23Test'

Write-Host "Deploying to $EnvironmentName"
$deployApps = $parameters.apps
Write-Host "Cleaning up deployment folder"
Remove-item -Path ($deployAppsPath + '\*.*') -Recurse -Force
Write-Host "Move to deployment folder: $deployApps"
Move-Item -Path $deployApps -destination $deployAppsPath
Write-Host "Expanding artifacts"
$deployArtifacts = Get-ChildItem -Path $deployAppsPath -Filter '*.zip'
foreach ($deployArtifact in $deployArtifacts) {
    Expand-Archive -Literalpath $deployArtifact.FullName -destination $deployAppsPath -Force
}

# Import custom Deployment Tools
$date = (Get-Date).ToString('yyyy-MM-dd')
$filename = $date + "_01_start.txt"
$filevalue = "Last deployment started: " + (Get-Date).ToString('yyyy-MM-dd HH-mm-ss')
New-Item -Path $deployAppsPath -Name $filename -ItemType "file" -Value $filevalue -Force

Write-Host "Install or update Apps"
# execute Install CmdLet
Start-Sleep -Seconds 3.3
$bgApp = Get-ChildItem -Path $deployAppsPath -Filter "mephezar_boardgames_*.app"
if ($bgApp) {
    Publish-BCContainerApp -containerName $containerName -appFile $bgApp -skipVerification -sync -install
}

$filename = $date + "_99_finish.txt"
$filevalue = "Last deployment finished: " + (Get-Date).ToString('yyyy-MM-dd HH-mm-ss')
New-Item -Path $deployAppsPath -Name $filename -ItemType "file" -Value $filevalue -Force