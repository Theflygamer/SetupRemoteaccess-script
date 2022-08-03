    Write-Warning "this gonna setup remote access and the computer will restart after SAVE YOUR WORK NOW" -WarningAction Inquire
    
    Set-WSManQuickConfig -Force  
    Enable-WSManCredSSP -Role server -Force
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force
    Enable-WSManCredSSP -Role client -DelegateComputer * -Force

    WinRM qc -Force
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All 
    shutdown /r /t 10 /c "Restaring in 10 sec"

    PowerShell -NoExit
    Install-Module -Name VPNCredentialsHelper -Force
    
    $vpnname = Read-Host -Prompt "Name the of the vpn connection "
    $Ipaddress = Read-Host -Prompt "IP address of the public address of the office (see UDM/router)"
    $presharedkey = Read-Host -Prompt "past in the preshared key prom the VPN server (see UDM/router)"
    $username = Read-Host -Prompt "past in your username form the new user your created in the (UDM/router)"
    $password = Read-Host -Prompt "past in your password form the new user your created in the (UDM/router)"
    Write-Host "Name of the Connection '$vpnname'"
    Add-VpnConnection -Name "$vpnname" -ServerAddress "$Ipaddress" -DnsSuffix "localhost" -Tunneltype "L2tp" -Encryptionlevel "Required" -AuthenticationMethod "MSChapv2" -L2tpPsk "$presharedkey" -Force -RememberCredential:$true -SplitTunneling -AllUserConnection:$false -UseWinlogonCredential:$false  

        Set-VpnConnectionUsernamePassword -connectionname $vpnname -username $username -password $password
    

        $RASPhoneBook =
        "C:\Users\YOURUSERNAME\AppData\Roaming\Microsoft\Network\Connections\Pbk\rasphone.pbk"
        (Get-Content $RASPhoneBook) -Replace 'IpDnsFlags=0', 'IpDnsFlags=2' |
        Set-Content $RASPhoneBook  