# Define variables
$RuleName = "Allow_Jenkins_Port"
$DisplayName = "Allow Jenkins Port"
$Port = 8080  # Change this to the Jenkins port you are using

# Create a new inbound rule
New-NetFirewallRule -DisplayName $DisplayName -Name $RuleName -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort $Port