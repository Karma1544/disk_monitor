param(
    [int]$ThresholdGB = 2,
    [int]$CheckIntervalSec = 30 
)

# Добавляем загрузку необходимых сборок
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

while ($true){
    $disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"
    $SpaceLeft = [math]::Round($disk.FreeSpace / 1GB, 2)
    Write-Host "Empty space on disk C: $SpaceLeft GB" -Foreground Green
    if ($SpaceLeft -lt $ThresholdGB){
        Write-Host "Danger! Too little space left on disk C!" -Foreground Red
        $processes = Get-Process | Where-Object {
            $_.ProcessName -match "(setup|install|download|update|winget|choco|npm|msi)" -or
            $_.MainWindowTitle -match "(install|download|setup|update)"
        }
        if ($processes){
            $res = [System.Windows.Forms.MessageBox]::Show("Danger! Little space left on disk C! `nFound processes that may be taking up disk space. Do you want to view and potentially stop them?",
                "Low disk C space warning",
                [System.Windows.Forms.MessageBoxButtons]::YesNo,
                [System.Windows.Forms.MessageBoxIcon]::Warning)
            if ($res -eq [System.Windows.Forms.DialogResult]::Yes){
                $ProcessList = "Processes using disk C space: `n`n"
                foreach ($proc in $processes){
                    $ProcessList += "$($proc.ProcessName) (ID: $($proc.ID))`n"
                }
                [System.Windows.Forms.MessageBox]::Show(
                    $ProcessList,
                    "List of processes, using disk C for downloading",
                    [System.Windows.Forms.MessageBoxButtons]::OK,
                    [System.Windows.Forms.MessageBoxIcon]::Information
                    )
                $suspendRes = [System.Windows.Forms.MessageBox]::Show(
                    "Do you want to suspend these processes to free up disk space?",
                    "Suspend Processes",
                    [System.Windows.Forms.MessageBoxButtons]::YesNo,
                    [System.Windows.Forms.MessageBoxIcon]::Question
                    )
                if ($suspendRes -eq [System.Windows.Forms.DialogResult]::Yes){
                    foreach ($proc in $processes){
                        try{
                            Suspend-Process -Id $proc.Id -ErrorAction Stop
                            Write-Host "Process $($proc.ProcessName) (ID: $($proc.Id)) suspend successfully" -Foreground Yellow
                        }
                        catch{
                            Write-Host "Error! Process $($proc.ProcessName) (ID: $($proc.Id)) was not suspended successfully. `n $($_.Exception.Message)" -Foreground Red
                        }
                    }
                    [System.Windows.Forms.MessageBox]::Show(
                        "Processes have been suspended. Disk space should free up shortly.",
                        "Process Suspension Complete",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Information
                    )
                }
            }
        }
    }
    Start-Sleep -Seconds $CheckIntervalSec
}