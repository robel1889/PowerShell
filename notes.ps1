#Set preferred error action, limit the blood
$ErrorActionPreferences = "silentlycontinue"

#Bypass Execution Policy
Set-ExecutionPolicy Bypass

#Prerequisite command for remoting
Enable-PSRemoting #not necessary if it's already enabled
Set-Item WSMAN:\localhost\Client\trustedhosts -Value * #Probably better to add explicit hosts.

#Create a session
New-PSSession -ComputerName <ip>

#Enter the session
Enter-PSSession -ComputerName <ip> #Could alo use Id 1 to enter session 1

#Looking for indicators of persistence. Think of how you can pass in a variable for this.
Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run

#Enumerate local users
Get-LocalUser

#Enumerate members of Administrators group
Get-LocalGroupMember -Group Administrators

#Looking for scheduled tasks. This is another way for potential persistence.
Get-ScheduledTask | Get-Member
Get-ScheduledTask | select taskname -ExpandProperty actions | select taskname, execute | findstr ".bat"

#Interacting with WMI to obtain information (could also use this to get serviced, processes...)
Get-WmiObject win32_Logicaldisk | select FreeSpace

#Getting active network connections
Get-NetTCPConnection | Format-Table RemoteAddress, State

#Eventlogs are a great source of information
Get-eventlog -LogName System -EntryType warning | Where-Object -Property Message -Like "*misconfiguration*"
Get-Event

#Check discovered artifacts for leads on more information
Get-Content <path to artifact>

#Find files on the system
Get-ChildItem -Path C:\ -Recurse -Include "AdobeUpdater.exe" -ErrorAction SilentlyContinue -Force

#Example:
    $ioc_list = ioc.list
    foreach ($IOC in Get-Content($ioc_list){Get-ChildItem -Path C:\ -Recurse -Include $IOC -ErrorAction SilentlyContinue -Force}
    
#Comparing Object between CSV files
$baseline = Import-Csv -Path .\baseline.csv
$output = Import-Csv -Path .\output.csv
Compare-Object -ReferenceObject $baseline -DifferenceObject $output -Property "Path" -PassThru