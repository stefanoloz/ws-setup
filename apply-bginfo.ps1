$destinationFolder = "C:\_service\BgInfo"

if (!(Test-Path -path $destinationFolder)) {New-Item $destinationFolder -Type Directory}
Copy-Item ".\BgInfo\*.*" -Destination $destinationFolder

Register-ScheduledTask -xml (Get-Content 'C:\_service\BgInfo\BgInfo-task.xml' | Out-String) -TaskName "BgInfo update bkg" -TaskPath "\"

