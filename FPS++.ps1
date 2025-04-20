# ⚠️ Run PowerShell as Administrator!

Write-Host "`n🛠️ FPS Boost Script Starting..." -ForegroundColor Cyan

# Set power plan to High Performance
powercfg -setactive SCHEME_MIN
Write-Host "✔️ Power plan set to High Performance"

# Disable visual effects for performance
$performanceKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
Set-ItemProperty -Path $performanceKey -Name "VisualFXSetting" -Value 2
Write-Host "✔️ Visual effects set to performance mode"

# Disable Xbox Game Bar &amp; Game DVR safely
Write-Host "Disabling Xbox Game Bar and Game DVR..."

# Disable Game DVR for current user
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -ErrorAction SilentlyContinue

# Ensure policy path exists and disable DVR
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows"
If (-not (Test-Path "$policyPath\GameDVR")) {
    New-Item -Path $policyPath -Name "GameDVR" -Force | Out-Null
}
Set-ItemProperty -Path "$policyPath\GameDVR" -Name "AllowGameDVR" -Value 0
Write-Host "✔️ Game DVR and Xbox Game Bar disabled"

# Clean temp files
Write-Host "🧹 Cleaning temp files..."
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "✔️ Temp files cleaned"

# Stop unnecessary services
Write-Host "Disabling unnecessary services..."
$services = @(
    "SysMain",     # Superfetch
    "DiagTrack",   # Telemetry
    "WSearch"      # Windows Search
)

foreach ($Service in $services) {
    If (Get-Service -Name $service -ErrorAction SilentlyContinue) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled
        Write-Host "✔️ Disabled service: $Service"
    } else {
        Write-Host "ℹ️ Service not found: $Service"
    }
}

Write-Host "`n🎮 FPS Boost Complete! Please restart your PC for best results." -ForegroundColor Green
