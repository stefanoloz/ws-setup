.\Set-SageSet1.ps1

start-process -Wait -FilePath C:\Windows\System32\cleanmgr.exe /sagerun:1

start-process -Wait -FilePath "C:\Windows\System32\dism.exe" -ArgumentList "/Online /Cleanup-Image /AnalyzeComponentStore"
start-process -Wait -FilePath "C:\Windows\System32\dism.exe" -ArgumentList " /Online /Cleanup-Image /StartComponentCleanup"
start-process -Wait -FilePath "C:\Windows\System32\Dism.exe" -ArgumentList " /online /Cleanup-Image /StartComponentCleanup /resetbase"
start-process -Wait -FilePath "C:\Windows\System32\Dism.exe" -ArgumentList " /Online /Cleanup-Image /SPSuperseded"

Optimize-Volume -DriveLetter C -defrag -Verbose
