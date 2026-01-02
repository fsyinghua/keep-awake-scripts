# Keep Awake Scripts

Windows VBS scripts to prevent system from going to sleep automatically.

## Scripts

### 1. keep_awake.vbs
- **Method**: Simulates Scroll Lock key press every minute
- **Features**: 
  - Prevents system sleep/hibernation
  - Auto-stops at 18:05
  - Error handling and logging

### 2. keep_awake_mouse.vbs
- **Method**: Moves mouse cursor slightly every minute
- **Features**:
  - Same functionality as keyboard version
  - Uses PowerShell to move mouse 1 pixel
  - Hidden PowerShell window

## Usage

1. **Double-click** the `.vbs` file to run
2. Or use command line: `cscript "script_name.vbs"`

## Requirements

- Windows operating system
- PowerShell (for mouse version)

## Auto-stop Time

Both scripts automatically stop at **18:05** (6:05 PM) and display a notification.

## License

Free to use and modify.