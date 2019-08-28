$ip_list = 'C:\Users\Student\Desktop\Robel\IOC_IPs.txt'
$domain_list = 'C:\Users\Student\Desktop\Robel\IOC_domains.txt'
$sid = 1000000
$sid2 = 2000000
$file = '.\test.txt'

foreach ($line in Get-Content($ip_list)){
    Write-Host "alert ip $line any <> any any (msg:'Bad IP:$line'; sid:$sid;)"
    $sid += 1
    }
    
foreach ($line in Get-Content($domain_list)){
    Write-Host "alert udp any any <> any any (msg:'Bad Domain:$line'; content:'$line'; sid:$sid2;)"
    $sid2 +=1 
}
