$server = "neato.us.to"
$port = 25565

$PSDefaultParameterValues['TNC:InformationLevel'] = 'Quiet'

# allows us to enter text into command prompt (minecraft server)
$wshell = New-Object -ComObject wscript.shell

# makes the command prompt (minecraft server instance) active window
$serverInstance = Show-Process (Get-Process cmd)

# sets get-servercmd function as a variable
$servercmd = get-servercmd

function Show-Process($Process, [Switch]$Maximize)
{
 $sig = '
    [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
  '
  
  if ($Maximize) { $Mode = 3 } else { $Mode = 4 }
  $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
  $hwnd = $process.MainWindowHandle
  $null = $type::ShowWindowAsync($hwnd, $Mode)
  $null = $type::SetForegroundWindow($hwnd) 
}

# sends an echo request to minecraft server on specified port
function serverActivityCheck {
    TNC -Computername $server -Port $port -Port -InformationLevel Quiet
}




##########################################################################################
########################## 



# server-Up function gives us information about when the scan was run successfully
function server-Up {
    Write-Host "Script was successfully run on"; ""
    Write-Host(Get-Date -format g) -foregroundcolor green; ""
    Write-Host "and the server is still running..."; ""
    Start-Sleep 2
    Write-Host "Will check again in one hour to ensure server is still running!"
}

function Server-Down {

}

# if statement sends an echo request to the server on specified port
# if echo is returned, run the server-Up function
# if echo is not returned, run the server-Down function
if (serverActivityCheck == $true) {
    server-Up
} else {
    server-Down
}