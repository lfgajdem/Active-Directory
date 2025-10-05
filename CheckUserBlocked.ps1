Import-Module ActiveDirectory

write-host "_____________________________________________"

Try{
	$user = read-host  "Enter user please "

	# Identity --> 'sAMAccountName' o 'DistinguishedName' o 'objectSid' o 'objectGUID'

	#  _____________ DC List_____________
	$dcs = Get-ADDomainController -Filter { Name -like "*" }
	$errLog = $Null
	$propParam = @(
		'SamAccountName',
	    'name',
	    'BadLogonCount',
	    'badPasswordTime',
	   	'badPwdCount',
	    'LastBadPasswordAttempt',
        'LastLogonDate',
		'lastLogonTimestamp',
	    'lastLogoff',
	    'lastLogon',
		'LockedOut',
		'lockoutTime',
	    'logonCount',
	    'LogonWorkstations',
        'PasswordLastSet',
	    'PwdLastSet'
	)

	# The large whole day calculation represents the number of 100-nanosecond intervals since January 1, 1601
    # in the following parameters 'BadPasswordTime'  'lastLogon'  'lockoutTime'  'PwdLastSet' 

	$propSelect = @(
		'SamAccountName',
	    'name',
	    'BadLogonCount',
		@{ Name = 'BadPasswordTime' ; 
			Expression = {if (($_.BadPasswordTime) -eq 0) {$_.BadPasswordTime} else {[DateTime]::FromFileTime($_.BadPasswordTime)}}
	    		},
		'badPwdCount',
	    'LastBadPasswordAttempt',
		'lastLogoff',
		@{ Name = 'lastLogon' ;  
	    	Expression = {if (($_.lastLogon) -eq 0) {$_.lastLogon} else {[DateTime]::FromFileTime($_.lastLogon)}}
	    		} ,
		'LastLogonDate',
		'LockedOut',
		@{ Name = 'lockoutTime' ;  
	    	Expression = {if (($_.lockoutTime) -eq 0) {$_.lockoutTime} else {[DateTime]::FromFileTime($_.lockoutTime)}}
	    	} ,
	    'logonCount',
		'LogonWorkstations',
		@{ Name = 'PwdLastSet' ;  
	    	Expression = {if (($_.Pwdlastset) -eq 0) {$_.Pwdlastset} else {[DateTime]::FromFileTime($_.Pwdlastset)}}
	    		} ,
		'PasswordLastSet'
	)

	foreach ($dc in $dcs) {
 		$dcname = $dc.HostName
	    Write-Host "Domain controler "$dc -ForegroundColor Yellow
	    
		$getParams = [ordered]@{
			Identity = $user
        	Properties = $propParam
			Server = $dcname
			ErrorVariable = +$errLog
			ErrorAction = "SilentlyContinue"	
			}
		Get-ADUser @getParams | Select-Object $propSelect
	}

}
Catch [System.IO.IOException]
{
	Write-Host 'An input-output excepction has been identified'
}
Catch
{
    #  ______________________ View Excepction Type ______________________
	#  Write-Host "Exception type: $($_.Exception.GetType().FullName)"
	Write-Host '  -- Incorrect user. Please log out and run the program again. --'
}


if ($errLog.Count -ne 0) {
	"______________________ Date: " + $date + "______________________" >> $newFolder"\error.log"
	foreach ($item in $errLog){
		      $item >> $newFolder"\error.log"
	}
}

Read-Host -Prompt "Press the <ENTER> key to exit... "
