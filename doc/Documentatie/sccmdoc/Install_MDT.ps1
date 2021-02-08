#region Run script as admin
# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
 
#region Functions 

function Write-Log 
{ 
    [CmdletBinding()] 
    Param 
    ( 
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("LogContent")] 
        [string]$Message, 
 
        [Parameter(Mandatory=$false)] 
        [Alias('LogPath')] 
        [string]$Path='C:\Logs\PowerShellLog.log', 
         
        [Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info", 
         
        [Parameter(Mandatory=$false)] 
        [switch]$NoClobber 
    ) 
 
    Begin 
    { 
        # Set VerbosePreference to Continue so that verbose messages are displayed. 
        $VerbosePreference = 'Continue' 
    } 
    Process 
    { 
         
        # If the file already exists and NoClobber was specified, do not write to the log. 
        if ((Test-Path $Path) -AND $NoClobber) { 
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name." 
            Return 
            } 
 
        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path. 
        elseif (!(Test-Path $Path)) { 
            Write-Verbose "Creating $Path." 
            $NewLogFile = New-Item $Path -Force -ItemType File 
            } 
 
        else { 
            # Nothing to see here yet. 
            } 
 
        # Format Date for our Log File 
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
 
        # Write message to error, warning, or verbose pipeline and specify $LevelText 
        switch ($Level) { 
            'Error' { 
                Write-Error $Message 
                $LevelText = 'ERROR:' 
                } 
            'Warn' { 
                Write-Warning $Message 
                $LevelText = 'WARNING:' 
                } 
            'Info' { 
                Write-Verbose $Message 
                $LevelText = 'INFO:' 
                } 
            } 
         
        # Write log entry to $Path 
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append 
    } 
    End 
    { 
    } 
}

function New-SWRandomPassword {
    <#
    .Synopsis
       Generates one or more complex passwords designed to fulfill the requirements for Active Directory
    .DESCRIPTION
       Generates one or more complex passwords designed to fulfill the requirements for Active Directory
    .EXAMPLE
       New-SWRandomPassword
       C&3SX6Kn

       Will generate one password with a length between 8  and 12 chars.
    .EXAMPLE
       New-SWRandomPassword -MinPasswordLength 8 -MaxPasswordLength 12 -Count 4
       7d&5cnaB
       !Bh776T"Fw
       9"C"RxKcY
       %mtM7#9LQ9h

       Will generate four passwords, each with a length of between 8 and 12 chars.
    .EXAMPLE
       New-SWRandomPassword -InputStrings abc, ABC, 123 -PasswordLength 4
       3ABa

       Generates a password with a length of 4 containing atleast one char from each InputString
    .EXAMPLE
       New-SWRandomPassword -InputStrings abc, ABC, 123 -PasswordLength 4 -FirstChar abcdefghijkmnpqrstuvwxyzABCEFGHJKLMNPQRSTUVWXYZ
       3ABa

       Generates a password with a length of 4 containing atleast one char from each InputString that will start with a letter from 
       the string specified with the parameter FirstChar
    .OUTPUTS
       [String]
    .NOTES
       Written by Simon Wåhlin, blog.simonw.se
       I take no responsibility for any issues caused by this script.
    .FUNCTIONALITY
       Generates random passwords
    .LINK
       http://blog.simonw.se/powershell-generating-random-password-for-active-directory/
   
    #>
    [CmdletBinding(DefaultParameterSetName='FixedLength',ConfirmImpact='None')]
    [OutputType([String])]
    Param
    (
        # Specifies minimum password length
        [Parameter(Mandatory=$false,
                   ParameterSetName='RandomLength')]
        [ValidateScript({$_ -gt 0})]
        [Alias('Min')] 
        [int]$MinPasswordLength = 8,
        
        # Specifies maximum password length
        [Parameter(Mandatory=$false,
                   ParameterSetName='RandomLength')]
        [ValidateScript({
                if($_ -ge $MinPasswordLength){$true}
                else{Throw 'Max value cannot be lesser than min value.'}})]
        [Alias('Max')]
        [int]$MaxPasswordLength = 12,

        # Specifies a fixed password length
        [Parameter(Mandatory=$false,
                   ParameterSetName='FixedLength')]
        [ValidateRange(1,2147483647)]
        [int]$PasswordLength = 8,
        
        # Specifies an array of strings containing charactergroups from which the password will be generated.
        # At least one char from each group (string) will be used.
        [String[]]$InputStrings = @('abcdefghijkmnpqrstuvwxyz', 'ABCEFGHJKLMNPQRSTUVWXYZ', '23456789', '!"#%&'),

        # Specifies a string containing a character group from which the first character in the password will be generated.
        # Useful for systems which requires first char in password to be alphabetic.
        [String] $FirstChar,
        
        # Specifies number of passwords to generate.
        [ValidateRange(1,2147483647)]
        [int]$Count = 1
    )
    Begin {
        Function Get-Seed{
            # Generate a seed for randomization
            $RandomBytes = New-Object -TypeName 'System.Byte[]' 4
            $Random = New-Object -TypeName 'System.Security.Cryptography.RNGCryptoServiceProvider'
            $Random.GetBytes($RandomBytes)
            [BitConverter]::ToUInt32($RandomBytes, 0)
        }
    }
    Process {
        For($iteration = 1;$iteration -le $Count; $iteration++){
            $Password = @{}
            # Create char arrays containing groups of possible chars
            [char[][]]$CharGroups = $InputStrings

            # Create char array containing all chars
            $AllChars = $CharGroups | ForEach-Object {[Char[]]$_}

            # Set password length
            if($PSCmdlet.ParameterSetName -eq 'RandomLength')
            {
                if($MinPasswordLength -eq $MaxPasswordLength) {
                    # If password length is set, use set length
                    $PasswordLength = $MinPasswordLength
                }
                else {
                    # Otherwise randomize password length
                    $PasswordLength = ((Get-Seed) % ($MaxPasswordLength + 1 - $MinPasswordLength)) + $MinPasswordLength
                }
            }

            # If FirstChar is defined, randomize first char in password from that string.
            if($PSBoundParameters.ContainsKey('FirstChar')){
                $Password.Add(0,$FirstChar[((Get-Seed) % $FirstChar.Length)])
            }
            # Randomize one char from each group
            Foreach($Group in $CharGroups) {
                if($Password.Count -lt $PasswordLength) {
                    $Index = Get-Seed
                    While ($Password.ContainsKey($Index)){
                        $Index = Get-Seed                        
                    }
                    $Password.Add($Index,$Group[((Get-Seed) % $Group.Count)])
                }
            }

            # Fill out with chars from $AllChars
            for($i=$Password.Count;$i -lt $PasswordLength;$i++) {
                $Index = Get-Seed
                While ($Password.ContainsKey($Index)){
                    $Index = Get-Seed                        
                }
                $Password.Add($Index,$AllChars[((Get-Seed) % $AllChars.Count)])
            }
            Write-Output -InputObject $(-join ($Password.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value))
        }
    }
}

#endregion

#region Variables

$outputFolder = "c:/temp/Deployment_Server_Configurator"
$logpath = $outputFolder + "/scriptlog.log"
#$adklog = $outputFolder + "/adk_Setup.log"
#$ADK_temp = $outputFolder + "/ADK_TEMP"
$download_MDT = "https://download.microsoft.com/download/3/3/9/339BE62D-B4B8-4956-B58D-73C4685FC492/MicrosoftDeploymentToolkit_x64.msi"
#$download_ADK = "http://download.microsoft.com/download/3/1/E/31EC1AAF-3501-4BB4-B61C-8BD8A07B4E8A/adk/adksetup.exe"
$file_MDT = "$outputFolder/MDT2013x64.msi"
#$file_ADK = "$outputFolder/ADK_Win10v1607.exe"
# Pay attention in the path below, you have to specify a 'backslash' (\), not a simple slash (/), or it will not share the folder
$deploymentshare = "c:\DeploymentShare"

#endregion

# STARTING SCRIPT
Write-Log -Message "SCRIPT => Deployment_Server_Automation.ps1 started on $env:COMPUTERNAME by $env:USERNAME" -Path $logpath -Level Info

#region Check if OS is Windows Server

$OStest = Get-WmiObject -Class win32_operatingsystem | ? {$_.caption -ilike "*Windows Server 201*"}

if (!$OStest) 
{
    Write-Log -Message "Script can't run on non-Windows Server computers, exiting" -Path $logpath -Level Error
    Invoke-Item $logpath
    break
}
else
{
    Write-Log -Message "Computer passed OS test" -Path $logpath -Level Info    
}

#endregion

#region .NET Framework configuration

# Check if .NET Framework is enabled on the server, if not DO IT
$featuretest = Get-WindowsFeature -Name net-framework-core | ? {$_.installed -eq $true}
if (!$featuretest)
{
    try {
        Write-Log -Message "CONFIGURING => .NET Framework 3.5 feature" -Path $logpath -Level Info
        Install-WindowsFeature net-framework-core -IncludeAllSubFeature
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Write-Log -Message "Enabling net-framework-core feature failed : $FailedItem" -Path $logpath -Level Error
        break
    }

    Write-Log -Message "CONFIGURED => .NET Framework 3.5 feature" -Path $logpath -Level Info
}
else {Write-Log -Message "CONFIGURED => .NET Framework 3.5 feature already enabled on this computer" -Path $logpath -Level Info}

#endregion

#region MDT sources download

# Download MDT sources files from internet

try {
    Write-Log -Message "DOWNLOADING => MDT setup sources" -Path $logpath -Level Info
    New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null
    Invoke-WebRequest -Uri $download_MDT -OutFile $file_MDT
}
catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Log -Message "Download failed : $FailedItem" -Path $logpath -Level Error
    break
}

Write-Log -Message "DOWNLOADED => MDT setup sources in $outputFolder" -Path $logpath -Level Info

sleep -s 5

#endregion



#region Install MDT

try {
    Write-Log -Message "INSTALLING => Ongoing MDT installation" -Path $logpath -Level Info
    & $file_MDT /qn
    
}
catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Log -Message "MDT installation failed : $FailedItem" -Path $logpath -Level Error
    break
}

Write-Log -Message "INSTALLED => MDT installation complete" -Path $logpath -Level Info
sleep -s 5

#endregion

#region Create the local user used by the MDT deployment share

$name = "mdt_admin"
$password = New-SWRandomPassword -MinPasswordLength 8 -MaxPasswordLength 12
$localuser = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount='True'" | ? {$_.Name -eq "$name"}

if (!$localuser)
{
    try {
        Write-Log -Message "CONFIGURING => Local user not found, creating it" -Path $logpath -Level Info
        $server=[adsi]"WinNT://$env:computername"
        $user=$server.Create("User","$name")
        $user.SetPassword($password)
        $user.SetInfo()
 
        # add extra info
        $user.Put('Description','Microsoft Deployment Tools administrator')
        $flag=$user.UserFlags.Value -bor 0x800000
        $user.put('userflags',$flag)
        $user.SetInfo()
 
        # add user to mandatory local group
        $group=[adsi]"WinNT://$env:computername/Users,Group"
        $group.Add($user.path)

        # add user to administrators local group
        $group=[adsi]"WinNT://$env:computername/Administrators,Group"
        $group.Add($user.path)
    } 
    catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Write-Log -Message "MDT user creation failed" -Path $logpath -Level Error
        break
    }    
}
else 
{
    try {
        Write-Log -Message "CONFIGURING => Local user already exists, reseting password" -Path $logpath -Level Info
        ([adsi]“WinNT://$env:computername/$name”).SetPassword(“$password”)
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Write-Log -Message "MDT user password reset failed" -Path $logpath -Level Error
        break
    }
}

#endregion

#region Create and configure the MDT Deployment Share

try {
    Write-Log -Message "CONFIGURING => MDT deployment share configuration ongoing" -Path $logpath -Level Info
    New-Item -Path $deploymentshare -ItemType directory -Force | Out-Null
    New-SmbShare -Name "DeploymentShare$" -Path $deploymentshare -FullAccess Administrators
    Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
    New-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root $deploymentshare -Description "MDT Deployment Share" -NetworkPath "\\$env:COMPUTERNAME\DeploymentShare$" -Verbose | Add-MDTPersistentDrive -Verbose | Out-Null
}
catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Log -Message "MDT configuration failed : $FailedItem" -Path $logpath -Level Error
    break
}

Write-Log -Message "CONFIGURED => MDT deployment share created" -Path $logpath -Level Info

#endregion

#region Performing the basic configuration of MDT (INI files)

$customsettings = $deploymentshare + "/Control/CustomSettings.ini"
$bootstrap = $deploymentshare + "/Control/Bootstrap.ini"

$bootcontent = @"
[Settings]
Priority=Default

[Default]
DeployRoot=\\$env:computername\DeploymentShare$
UserID=$name
UserPassword=$password
UserDomain=$env:COMPUTERNAME
SkipBDDWelcome=YES
"@

$customcontent = @"
[Settings]
Priority=Default
Properties=MyCustomProperty

[Default]
_SMSTSORGNAME=%TaskSequenceName%
OSInstall=Y
SkipCapture=YES
SkipAdminPassword=YES
AdminPassword=Project3
SkipProductKey=YES
SkipBitLocker=YES
SkipComputerBackup=YES
SkipComputername=YES
SkipDomainMembership=YES
SkipUserData=YES
SkipLocaleSelection=YES
SkipTimeZone=YES
SkipSummary =YES
UILanguage=en-US
UserLocale=fr-BE
KeyboardLocale=080c:0000080c
TimeZoneName = Romance Standard Time
TimeZone=105
FinishAction=REBOOT
"@

try {
    Write-Log -Message "CONFIGURING => MDT .INI files creation with basic values" -Path $logpath -Level Info
    Remove-Item -Path $customsettings -Force
    Remove-Item -Path $bootstrap -Force

    Add-Content -Path $bootstrap -Value $bootcontent -Force
    Add-Content -Path $customsettings -Value $customcontent -Force
} 
catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Log -Message "MDT configuration failed : $FailedItem" -Path $logpath -Level Error
    break
}

Write-Log -Message "CONFIGURED => MDT installation & configuration is now COMPLETE" -Path $logpath -Level Info

#endregion



# SCRIPT END
Write-Log -Message "SCRIPT => Script ENDED" -Path $logpath -Level Info