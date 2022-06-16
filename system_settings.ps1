#make sure the script is running from an elevated PowerShell session
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )

If($currentPrincipal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator ))
{
	Write-Host "This is an elevated PowerShell session. Continue"
}
Else
{
	Write-Host "$(Get-Date): This is NOT an elevated PowerShell session. Script will exit."
    Write-Host "Bye."
	Exit
}

# enable RDP
write-host
write-host 'Enabling RDP...'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0

# enable some fw rule
write-host
write-host 'Enabling some basic Windows Firewall rules...'
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"

# set timezone
write-host
write-host 'Setting Europe/Rome time zone...'
Set-timezone -id "W. Europe Standard Time"

# disable crash dump
write-host
write-host 'Disabling crash dump...'
Get-WmiObject -Class Win32_OSRecoveryConfiguration -EnableAllPrivileges | Set-WmiInstance -Arguments @{ DebugInfoType=0 }

#set fixed pagefile
write-host
write-host 'Setting fixed page file'

$pfsize= Read-Host -Prompt 'Enter PageFile size in MB [1024]'
if ([string]::IsNullOrWhiteSpace($pfsize))
    {$pfsize = ‘1024’
    }

$pagefile = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$pagefile.AutomaticManagedPagefile = $false
$pagefile.Put() | Out-Null

$pagefileset = Get-WmiObject Win32_pagefilesetting
$pagefileset.InitialSize = $pfsize
$pagefileset.MaximumSize = $pfsize
$pagefileset.Put() | Out-Null

# optional disable DEP
$input = Read-Host "Do you want to disable DEP [y/n]"
switch($input){
          y{
            start-process -Wait -FilePath "C:\Windows\System32\bcdedit.exe" -ArgumentList "/SET {CURRENT} NX ALWAYSOFF"
            write-host 'Disabling DEP...'
            }
          n{break}
    default{break}
}

#reboot choice
Write-Host
write-host 'Changes will be applied after restart'

$input = Read-Host "Restart computer NOW [y/n]"
switch($input){
          y{
          write-host 'Restarting NOW...'
          Start-Sleep -Seconds 3
          Restart-computer -Force -Confirm:$false
          }
          n{exit}
    default{write-warning "Invalid Input"}
}