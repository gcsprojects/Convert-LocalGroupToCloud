### Intro
    Changes specified AD Group to be Cloud Managed rather than synced from Local AD

### DESCRIPTION
    This function changes the specifed group from being synced from your local Active Directory
    to be managed from your Entra ID tenant, meaning the group can be updated from the cloud 
    without needing access to Active Directory.

### PARAMETER GroupName
        Specified the AD Group you want to change
       
### EXAMPLE
    Convert-LocalGroupToCloud -GroupName "My Group To Change"

Requires Microsoft Graph Module: 
<https://www.powershellgallery.com/packages/Microsoft.Graph/2.31.0> 
