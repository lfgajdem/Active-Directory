## Check whether the user is blocked on any domain controller.
### Description

The check_User_blocked.ps1 PowerShell script in this repository allows you to search all domain controllers to see if a user is locked out.
You can enter *sAMAccountName* or *DistinguishedName* or *objectSid* or *objectGUID*.

Error handling
 - **ErrorVariable = $errLog** a list of errors that have occurred since the command was called is stored in error.log.
 - **ErrorAction = "SilentlyContinue"** errors are not displayed in the console. 
 - **Try/Catch** error handling Terminating

Lists
 - **propParam** properties to look for in each domain controller.
 - **propSelect** properties to display at output. Converts the 18-digit LDAP/FILETIME timestamps BadPasswordTime, LastLogon, LockoutTime and PwdLastSet to human-readable dates. The timestamp is the number of 100-nanosecond intervals since 1 January 1601 UTC (1 nanosecond = one billionth of a second).
