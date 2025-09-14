# Disk Space Monitor and Process Manager

PowerShell script for monitoring free space on C: drive and managing processes that may be consuming disk space.

## Description

This script continuously monitors free space on the system drive (C:). When free space falls below a specified threshold, the script:
1. Alerts the user about low disk space
2. Finds processes that may be related to software installation or updates
3. Offers to view a list of these processes
4. Requests permission to suspend identified processes

## Important Warnings

- Use with caution! Suspending system processes or update processes may lead to system instability or software installation failures.
- Administrator privileges are required to suspend certain processes.
- This script is intended for educational purposes. Use at your own risk.
- It is recommended to analyze the code before execution.

## Requirements

- Windows 7 or newer
- PowerShell 5.0 or higher
- .NET Framework assemblies for dialog boxes

## Installation

1. Clone or download the repository
2. Enable PowerShell script execution (run PowerShell as administrator):
Set-ExecutionPolicy RemoteSigned

## Usage

Run the script in PowerShell:

.\disk-monitor.ps1 -ThresholdGB 3 -CheckIntervalSec 30

### Parameters

- `ThresholdGB` (default: 2) - Free space threshold in GB that triggers the alert
- `CheckIntervalSec` (default: 30) - Check interval in seconds

### Examples


# Monitor with 5 GB threshold and 60-second check interval
.\disk-monitor.ps1 -ThresholdGB 5 -CheckIntervalSec 60

# Use default values (2 GB, 30 seconds)
.\disk-monitor.ps1

## How It Works

1. The script checks free space on C: drive every `CheckIntervalSec` seconds
2. If free space is below `ThresholdGB`, it searches for processes that may be related to installation/updates:
   - By process name (setup, install, download, update, etc.)
   - By window title (install, download, setup, update)
3. Shows a warning with a request to view processes
4. If user agrees, shows a process list
5. Requests permission to suspend processes
6. If confirmed, suspends processes using `Suspend-Process`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is distributed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Disclaimer

The author is not responsible for any damage caused by using this script. The user assumes all risks associated with running the script.

## Support

If you have questions or suggestions, create an issue in the repository.