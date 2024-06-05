param( [Parameter(Mandatory=$true)] $JSONFile)

function CreateADGroup() 
    {
    param ( [Parameter(Mandatory= $true)] $groupObject)

    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global

}

function CreateADUser() 
    {
    param ( [Parameter(Mandatory=$true)] $userObject)

    # Pull out the name for JSON object
    $name = $userObject.name
    $password = $userObject.password

    # Generate a "first initial, last name" stucture for user name
    $firstname , $lastname = $name.split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $SamAccountName = $username
    $principalname = $username

    # Actually create the AD user object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

    # Add the user to it's appropriate group
    foreach($group_name in $userObject.groups){

        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "User $name NOT added to group $group_name because it does not exists"
        }

        
    }
    # $firstname = (VulnAD-GetRandom -InputList $Global:HumansNames);
    # $firstname = (VulnAD-GetRandom -InputList $Global:HumansNames);
    # $firstname = (VulnAD-GetRandom -InputList $Global:HumansNames);
    # $lastname = (VulnAD-GetRandom -InputList $Global:HumansNames);
    # $fullname = "{0} {1}" -f ($firstname , $lastname);
    # $SamAccountName = ("{0}.{1}" -f ($firstname, $lastname)).ToLower();
    # $principalname = "{0}.{1}" -f ($firstname, $lastname);
    # $generated_password = ([System.Web.Security.Membership]::GeneratePassword(12,2))
    # Write-Info "Creating $SamAccountName User"
    # Try { New-ADUser -Name "$firstname $lastname" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $generated_password -AsPlainText -Force) -PassThru | Enable-ADAccount } Catch {}
    # $Global:CreatedUsers += $SamAccountName;

    #echo $userObject
    
}

$json = ( Get-Content $JSONFile | ConvertFrom-JSON)


$Global:Domain = $json.domain

foreach ($group in $json.groups){
    CreateADGroup $group
}


foreach ($user in $json.users){
    CreateADUser $user
}

