Install-WindowsFeature -Name NET-Framework-Core
iex ((new-object net.webclient).DownloadString("https://chocolatey.org/install.ps1"))

choco install git -y
choco install dotnet-sdk -y

$RuleName = "Allow_Blazor_Port"
$DisplayName = "Allow Blazor Port"

New-NetFirewallRule -DisplayName $DisplayName -Name $RuleName -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort $Port