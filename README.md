# 开机自动连接宽带

此脚本使用 Windows 自带的 `rasdial` 连接已经创建好的拨号连接，默认连接名为 `宽带连接`。

在 PowerShell 中运行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\auto-connect-broadband.ps1 -Action Install
```

安装后，登录 Windows 时会自动尝试连接，日志位于 `%LOCALAPPDATA%\BroadbandAutoConnect.log`。

卸载启动项：

```powershell
.\auto-connect-broadband.ps1 -Action Uninstall
```

如果拨号连接名称不是“宽带连接”，安装时传入实际名称，例如：

```powershell
.\auto-connect-broadband.ps1 -Action Install -ConnectionName '我的宽带'
```
