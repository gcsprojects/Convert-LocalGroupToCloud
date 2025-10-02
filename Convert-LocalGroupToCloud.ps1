Function Convert-LocalGroupToCloud
{

    <#
    .SYNOPSIS
    Changes specified AD Group to be Cloud Managed rather than synced from Local AD

    .DESCRIPTION
    This function changes the specifed group from being synced from your local Active Directory
    to be managed from your Entra ID tenant, meaning the group can be updated from the cloud 
    without needing access to Active Directory.

    .PARAMETER GroupName
        Specified the AD Group you want to change

    .NOTES
        Version:        1.2510.0
        Author:         Craig Wilson
        Company:        GCS Projects
        Creation Date:  02 October 2025 
        
    .EXAMPLE
    Convert-LocalGroupToCloud -GroupName "My Group To Change"

    .LINK
    https://github.com/gcsprojects/Convert-LocalGroupToCloud

    #>
    Param (
        $GroupName
    )

    # Create Hashtable to set Cloud Sync to True
    $Body = @{
        "isCloudManaged" = $True
    }

    # Connect to MsGraph within the "Group-OnPremisesSyncBehavior" scope
    # Note: Ensure MS Graph Module is installed and imported
    Connect-MgGraph group-OnPremisesSyncBehavior.ReadWrite.All -NoWelcome

    # Now we get the Entra ID for our group
    $GroupID = (Get-MgGroup -Filter "DisplayName eq '$GroupName'").Id

    # DEBUG: Uncoomment the next line to confirm the Group Name and ID are correct
    # Write-host "$GroupName : $GroupID"

    # Now we change the sync behaviour from our On-Premise Active Directory to our Entra Tenent
    Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/groups/$GroupID/onPremisesSyncBehavior" -Method PATCH -Body $Body 

    # Finallly, a quick check to ensure the change has taken effect.
    if ( (Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/groups/$GroupID/onPremisesSyncBehavior?`$select=isCloudManaged").isCloudManaged -eq "True")
    {
        Write-host "$GroupName is now Cloud Only"
    }
    else 
    {
        Write-Warning "$GRoupName failed to become Cloud Only"
    }
}