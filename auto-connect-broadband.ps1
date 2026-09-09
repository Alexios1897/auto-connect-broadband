param(
    [ValidateSet('Connect', 'Install', 'Uninstall')]
    [string]$Action = 'Connect',
    [string]$ConnectionName = '宽带连接'
)

$ErrorActionPreference = 'Stop'
$scriptPath = $PSCommandPath
$startupPath = [Environment]::GetFolderPath('Startup')
$shortcutPath = Join-Path $startupPath '宽带连接自动连接.lnk'
$logPath = Join-Path $env:LOCALAPPDATA 'BroadbandAutoConnect.log'

function Write-Log([string]$Message) {
    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $Message" | Add-Content -LiteralPath $logPath -Encoding UTF8
}

switch ($Action) {
    'Install' {
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
        $shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`" -Action Connect -ConnectionName `"$ConnectionName`""
        $shortcut.WorkingDirectory = Split-Path -Parent $scriptPath
        $shortcut.Save()
        Write-Log "已安装启动项: $ConnectionName"
        Write-Output "已安装到: $shortcutPath"
    }
    'Uninstall' {
        if (Test-Path -LiteralPath $shortcutPath) {
            Remove-Item -LiteralPath $shortcutPath -Force
            Write-Output "已删除: $shortcutPath"
        } else {
            Write-Output '启动项不存在'
        }
    }
    'Connect' {
        for ($attempt = 1; $attempt -le 3; $attempt++) {
            $result = (& rasdial.exe $ConnectionName 2>&1 | Out-String).Trim()
            if ($LASTEXITCODE -eq 0) {
                Write-Log "连接成功: $ConnectionName (第 $attempt 次)"
                exit 0
            }
            Write-Log "连接失败: $ConnectionName (第 $attempt 次) $result"
            if ($attempt -lt 3) { Start-Sleep -Seconds 5 }
        }
        exit 1
    }
}
