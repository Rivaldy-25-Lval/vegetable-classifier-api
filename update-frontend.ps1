# UPDATE FRONTEND WITH RENDER API URL
# Run this after Render deployment is complete

param(
    [string]$ApiUrl
)

Clear-Host
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "   UPDATE FRONTEND WITH API URL" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Get API URL if not provided
if ([string]::IsNullOrWhiteSpace($ApiUrl)) {
    Write-Host "Enter your Render API URL:" -ForegroundColor Yellow
    Write-Host "(Example: https://vegetable-classifier-api.onrender.com)" -ForegroundColor Gray
    Write-Host ""
    $ApiUrl = Read-Host "API URL"
}

# Validate URL
if ([string]::IsNullOrWhiteSpace($ApiUrl)) {
    Write-Host ""
    Write-Host "ERROR: API URL is required!" -ForegroundColor Red
    exit 1
}

# Remove trailing slash
$ApiUrl = $ApiUrl.TrimEnd('/')

Write-Host ""
Write-Host "API URL: $ApiUrl" -ForegroundColor Green
Write-Host ""

# Test API first
Write-Host "Testing API connection..." -ForegroundColor Cyan

try {
    $healthUrl = "$ApiUrl/health"
    $response = Invoke-RestMethod -Uri $healthUrl -Method Get -TimeoutSec 30 -ErrorAction Stop
    
    Write-Host "✓ API is reachable!" -ForegroundColor Green
    Write-Host "  Status: $($response.status)" -ForegroundColor Gray
    Write-Host "  Model Loaded: $($response.model_loaded)" -ForegroundColor Gray
    Write-Host "  Classes: $($response.classes)" -ForegroundColor Gray
    
    if ($response.model_loaded -ne $true) {
        Write-Host ""
        Write-Host "WARNING: Model not loaded yet!" -ForegroundColor Yellow
        Write-Host "Wait a few more minutes and try again." -ForegroundColor Gray
        $continue = Read-Host "Continue anyway? (y/n)"
        if ($continue -ne "y") {
            exit 0
        }
    }
} catch {
    Write-Host "✗ Cannot reach API!" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Possible reasons:" -ForegroundColor Yellow
    Write-Host "  - Service still starting up (wait 1-2 minutes)" -ForegroundColor Gray
    Write-Host "  - Wrong URL" -ForegroundColor Gray
    Write-Host "  - Deployment failed (check Render logs)" -ForegroundColor Gray
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") {
        exit 1
    }
}

Write-Host ""
Write-Host "Updating frontend..." -ForegroundColor Cyan

# Navigate to frontend directory
$frontendPath = "..\vegetable-classifier-web"

if (!(Test-Path $frontendPath)) {
    Write-Host "ERROR: Frontend directory not found at $frontendPath" -ForegroundColor Red
    exit 1
}

Push-Location $frontendPath

# Update script.js
$scriptPath = "js\script.js"

if (!(Test-Path $scriptPath)) {
    Write-Host "ERROR: Script file not found at $scriptPath" -ForegroundColor Red
    Pop-Location
    exit 1
}

$content = Get-Content $scriptPath -Raw

# Replace API URL
$oldPattern = "API_URL:\s*'[^']*'"
$newValue = "API_URL: '$ApiUrl'"

if ($content -match $oldPattern) {
    $content = $content -replace $oldPattern, $newValue
    Set-Content $scriptPath $content -NoNewline
    
    Write-Host "✓ Updated API URL in script.js" -ForegroundColor Green
} else {
    Write-Host "ERROR: Could not find API_URL in script.js" -ForegroundColor Red
    Write-Host "Please update manually at line ~10" -ForegroundColor Gray
    Pop-Location
    exit 1
}

# Commit and push
Write-Host ""
Write-Host "Committing changes..." -ForegroundColor Cyan

git add js\script.js

if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING: git add failed" -ForegroundColor Yellow
}

git commit -m "update: Connect to production API at $ApiUrl"

if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING: Nothing to commit (maybe already updated?)" -ForegroundColor Yellow
} else {
    Write-Host "✓ Changes committed" -ForegroundColor Green
}

Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan

git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Successfully pushed to GitHub!" -ForegroundColor Green
} else {
    Write-Host "✗ Push failed" -ForegroundColor Red
    Write-Host "  You may need to push manually" -ForegroundColor Gray
}

Pop-Location

# Wait for GitHub Pages to update
Write-Host ""
Write-Host "Waiting for GitHub Pages to update (30 seconds)..." -ForegroundColor Cyan

for ($i = 30; $i -gt 0; $i--) {
    Write-Host "`r  $i seconds remaining..." -NoNewline -ForegroundColor Gray
    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host ""

# Open website
$websiteUrl = "https://rivaldy-25-lval.github.io/Valll-vegetable-classifier-web/"

Write-Host "Opening your website..." -ForegroundColor Cyan
Start-Process $websiteUrl

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "         DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your application is now live at:" -ForegroundColor White
Write-Host "  $websiteUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend API:" -ForegroundColor White
Write-Host "  $ApiUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "What to do next:" -ForegroundColor Yellow
Write-Host "  1. Website opened in your browser" -ForegroundColor Gray
Write-Host "  2. Wait 10-20 seconds for page to load" -ForegroundColor Gray
Write-Host "  3. Check status: Should show 'API siap digunakan ✓'" -ForegroundColor Gray
Write-Host "  4. Upload a vegetable image" -ForegroundColor Gray
Write-Host "  5. Click 'Analisis Gambar'" -ForegroundColor Gray
Write-Host "  6. See the prediction!" -ForegroundColor Gray
Write-Host ""
Write-Host "Troubleshooting:" -ForegroundColor Yellow
Write-Host "  - If status shows error: Refresh page (Ctrl+F5)" -ForegroundColor Gray
Write-Host "  - If 'Server tidak tersedia': Wait 1-2 minutes (cold start)" -ForegroundColor Gray
Write-Host "  - Open browser console (F12) for detailed errors" -ForegroundColor Gray
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
