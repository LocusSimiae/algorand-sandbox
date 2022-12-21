param(
    [bool]$reset=$false
) 

Write-Host "Checking if docker is running... " -NoNewline 
$dockerDesktop = Get-Process -Name docker* -ErrorAction SilentlyContinue
if(!$dockerDesktop)
{
    Write-Host "Starting docker..." -ForegroundColor Yellow
    # https://thecodeframework.com/start-docker-desktop-on-windows-start-up-without-user-logon/
    Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe" -PassThru
    Start-Sleep 15
}
else
{
    Write-Host "Docker is running" -ForegroundColor Green
}
Remove-Variable dockerDesktop

Write-Host "Checking if sandbox is running... " -NoNewline 
$sandboxtype="release" #TODO: change this to dev, release, etc
$container_name = "algorand-sandbox-algod-$sandboxtype" # this is dependent on the setting of the sandbox which is different on the branches
if ((docker container inspect -f '{{.State.Status}}' $container_name) -ne "running")
{
    Write-Host "Starting sandbox..." -ForegroundColor Yellow
    # https://stackoverflow.com/questions/1741490/how-to-tell-powershell-to-wait-for-each-command-to-end-before-starting-the-next
    # $proc = Start-Process -WorkingDirectory $PSScriptRoot -FilePath "wsl.exe" -ArgumentList "./sandbox up $sandboxtype -v" -NoNewWindow -PassThru
    $sandboxFile = Join-Path $PSScriptRoot "sandbox"
    $nixPath = (($sandboxFile -replace "\\","/") -replace ":","").ToLower().Trim("/")
    Write-Host $PSScriptRoot
    $proc = Start-Process -WorkingDirectory $PSScriptRoot -FilePath "wsl.exe" -ArgumentList "./sandbox up $sandboxtype -v" -NoNewWindow -PassThru
    $proc.WaitForExit()
    Remove-Variable proc
}
else
{
    Write-Host "Sandbox is running" -ForegroundColor Green
}

if($reset)
{
    Write-Host "Resetting sandbox..." -ForegroundColor Yellow
    $proc = Start-Process -WorkingDirectory $PSScriptRoot -FilePath "wsl.exe" -ArgumentList "./sandbox reset -v" -NoNewWindow -PassThru
    $proc.WaitForExit()
    Remove-Variable proc
}
