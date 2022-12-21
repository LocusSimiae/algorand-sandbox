$dockerDesktop = Get-Process -Name docker* -ErrorAction SilentlyContinue
if($dockerDesktop)
{
    Write-Host "Resetting sandbox..." -ForegroundColor Yellow
    $proc = Start-Process -WorkingDirectory $PSScriptRoot -FilePath "wsl.exe" -ArgumentList "./sandbox reset -v" -NoNewWindow -PassThru
    $proc.WaitForExit()
    Remove-Variable proc
}
else 
{
    Write-Host "Sandbox isn't running!" -ForegroundColor Red
}
Remove-Variable dockerDesktop