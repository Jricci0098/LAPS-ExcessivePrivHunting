#########################
#####Import Modules######
#########################
import-module activedirectory
import-module importexcel
import-module laps

#########################
#Variable initialization#
#########################
 
# Set thread limit to perform look up on multiple OU's at once. 
# WARNING: Be sure that your DC can handle excessive requests.
$ThreadLimit = 2
 
#If an error is caught, stop current operations in loop and continue to the next object
$ErrorActionPreference = 'Stop'
 
############
#Start Work#
############
 
<#
We need to grab all DNs for the OU's in AD. It is common to see sprawl of computers, resources, and groups, especially in larger organizations. 
It is better to identify privilege creep everywhere then to assume it is in only designated OU's.
#>
 
# Get all OUs
$allOUs = Get-ADOrganizationalUnit -Filter * -Properties DistinguishedName
 
# Filter to get only top-level OUs
$topLevelOUs = $allOUs | Where-Object { $_.DistinguishedName -notmatch ',OU=' }
 
# Extract the Distinguished Names and store them in an array
$distinguishedNamesArray = $topLevelOUs | Select-Object -ExpandProperty DistinguishedName
 
# Setup a foreach loop to run in parallel
$distinguishedNamesArray | ForEach-Object -ThrottleLimit $ThreadLimit -Parallel {
 
    # Print OU Name to track progress
Write-Host "`r*******************" $_ "`r*******************"
 
    try {
        # Run command for each DN
        $admPwdRights = Find-AdmPwdExtendedRights -Identity "$_"
        # Need to flatten ExtendedRightHolders because it is returned as object and returns as object and not the data. 
        $flattenedData = $admPwdRights | Select-Object ObjectDN, @{Name='ExtendedRightHolders';Expression={($_.ExtendedRightHolders -join ', ')}}
        # Specify filename
        $excelFilePath = "Hunting-LAPSPrivilegeCreep.xlsx"
        # Export flattened data to Excel file
        $flattenedData | Export-Excel -Path $excelFilePath -WorksheetName "AdmPwdRights"
    } catch {
        Write-Host "`r*******************" $_ "`r*******************"
        Write-Host $_ "does not exist" -ForegroundColor DarkYellow
        Write-Host "`r*******************" $_ "`r*******************"
    }
}
