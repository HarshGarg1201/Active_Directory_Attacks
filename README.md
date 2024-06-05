# Active_Directory_Attacks
Domain Controller &amp; Domain User Setup, Enumeration, Pass-The-Hash, Kerberoasting Attacks on Active Directory Environment

# Installed VMs

1. Installed Windows Server 2022 as a Virtual Machine in Hyper-V Workstation/Manager
2. Installed Windows 11 as a Virtual Machine in Hyper-V Workstation/Manager

# Installing Domain Controller

1. Used 'scconfig' to:
   - change the hostname
   - change the IP address to statics
   - change the DNS server to our own IP

2. Install the Active Directory Windows Feature

```Shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```
```
Get-NetIPAddress
```
# Joining the workstation to the Domain

```
AddComputer -DomainName xyz.com -Credential xyz\Administrator -Force -Restart
```


#  Active Directory Setup 
