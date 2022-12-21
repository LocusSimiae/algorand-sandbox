$dockerDesktop = Get-Process -Name docker* -ErrorAction SilentlyContinue
if($dockerDesktop)
{
    Write-Host "Stopping sandbox..." -ForegroundColor Green
    # https://stackoverflow.com/questions/1741490/how-to-tell-powershell-to-wait-for-each-command-to-end-before-starting-the-next
    $proc = Start-Process -WorkingDirectory $PSScriptRoot -FilePath "wsl.exe" -ArgumentList "./sandbox down -v" -NoNewWindow -PassThru
    $proc.WaitForExit()
    Remove-Variable proc

    # Write-Host "Killing docker..." -ForegroundColor Green
    # docker ps -q | % { docker stop $_ } | Out-Null
    # get-process docker* | stop-process
}
else 
{
    Write-Host "Sandbox isn't running!" -ForegroundColor Red
}
Remove-Variable dockerDesktop
