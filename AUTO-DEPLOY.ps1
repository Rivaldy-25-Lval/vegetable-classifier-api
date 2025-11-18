# AUTOMATED DEPLOYMENT WIZARD
# This script will guide you through automated deployment

$ErrorActionPreference = "Continue"

function Show-Banner {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "   VEGETABLE CLASSIFIER AUTO-DEPLOY" -ForegroundColor Cyan
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Step {
    param($StepNum, $Title)
    Write-Host ""
    Write-Host "[$StepNum] $Title" -ForegroundColor Yellow
    Write-Host ("=" * 50) -ForegroundColor Gray
}

function Wait-ForEnter {
    param($Message = "Press ENTER to continue...")
    Write-Host ""
    Write-Host $Message -ForegroundColor Green
    Read-Host
}

# Start
Show-Banner

Write-Host "This wizard will:" -ForegroundColor White
Write-Host "  1. Guide you to create GitHub repository" -ForegroundColor Gray
Write-Host "  2. Push backend code automatically" -ForegroundColor Gray
Write-Host "  3. Guide you through Render deployment" -ForegroundColor Gray
Write-Host "  4. Update frontend automatically" -ForegroundColor Gray
Write-Host "  5. Test the application" -ForegroundColor Gray
Write-Host ""

Wait-ForEnter "Press ENTER to start..."

# STEP 1: Create GitHub Repo
Show-Banner
Show-Step "1/5" "CREATE GITHUB REPOSITORY"

Write-Host ""
Write-Host "Opening GitHub in your browser..." -ForegroundColor Cyan
Start-Process "https://github.com/new"
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "Please create a NEW repository with these settings:" -ForegroundColor White
Write-Host ""
Write-Host "  Repository name:  " -NoNewline -ForegroundColor Gray
Write-Host "vegetable-classifier-api" -ForegroundColor Yellow
Write-Host "  Description:      " -NoNewline -ForegroundColor Gray
Write-Host "Vegetable Classifier API" -ForegroundColor Yellow
Write-Host "  Visibility:       " -NoNewline -ForegroundColor Gray
Write-Host "Public" -ForegroundColor Yellow
Write-Host "  Initialize:       " -NoNewline -ForegroundColor Gray
Write-Host "DO NOT check any boxes!" -ForegroundColor Red
Write-Host ""
Write-Host "  Then click: 'Create repository'" -ForegroundColor Green
Write-Host ""

Wait-ForEnter "After creating the repo, press ENTER..."

# STEP 2: Push to GitHub
Show-Banner
Show-Step "2/5" "PUSH CODE TO GITHUB"

Write-Host ""
$username = Read-Host "Enter your GitHub username (default: Rivaldy-25-Lval)"
if ([string]::IsNullOrWhiteSpace($username)) {
    $username = "Rivaldy-25-Lval"
}

$repoUrl = "https://github.com/$username/vegetable-classifier-api.git"

Write-Host ""
Write-Host "Setting up Git remote..." -ForegroundColor Cyan

# Remove existing remote if any
git remote remove origin 2>$null

# Add new remote
git remote add origin $repoUrl

Write-Host "Remote added: $repoUrl" -ForegroundColor Green

Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
Write-Host "(This may take 1-2 minutes due to 39MB model file)" -ForegroundColor Gray
Write-Host ""

git branch -M main
git push -u origin main --verbose

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS! Code pushed to GitHub!" -ForegroundColor Green
    Write-Host "Repository: https://github.com/$username/vegetable-classifier-api" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "Push failed. This might be due to:" -ForegroundColor Red
    Write-Host "  - Authentication required (enter your credentials when prompted)" -ForegroundColor Gray
    Write-Host "  - Repository not created yet" -ForegroundColor Gray
    Write-Host ""
    $retry = Read-Host "Try again? (y/n)"
    if ($retry -eq "y") {
        git push -u origin main --verbose
    }
}

Wait-ForEnter

# STEP 3: Deploy on Render
Show-Banner
Show-Step "3/5" "DEPLOY ON RENDER.COM"

Write-Host ""
Write-Host "Opening Render.com in your browser..." -ForegroundColor Cyan
Start-Process "https://render.com"
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "Please follow these steps in Render.com:" -ForegroundColor White
Write-Host ""
Write-Host "1. Sign Up / Log In (use GitHub for easy integration)" -ForegroundColor Gray
Write-Host "2. Click 'New +' button -> Select 'Web Service'" -ForegroundColor Gray
Write-Host "3. Connect your GitHub account and repository:" -ForegroundColor Gray
Write-Host "   - Search for: vegetable-classifier-api" -ForegroundColor Yellow
Write-Host "   - Click 'Connect'" -ForegroundColor Yellow
Write-Host ""
Write-Host "4. Configure the service (COPY THESE EXACTLY):" -ForegroundColor Gray
Write-Host ""
Write-Host "   Name:           " -NoNewline -ForegroundColor Gray
Write-Host "vegetable-classifier-api" -ForegroundColor Yellow
Write-Host "   Region:         " -NoNewline -ForegroundColor Gray
Write-Host "Singapore" -ForegroundColor Yellow
Write-Host "   Branch:         " -NoNewline -ForegroundColor Gray
Write-Host "main" -ForegroundColor Yellow
Write-Host "   Runtime:        " -NoNewline -ForegroundColor Gray
Write-Host "Python 3" -ForegroundColor Yellow
Write-Host "   Build Command:  " -NoNewline -ForegroundColor Gray
Write-Host "pip install -r requirements.txt" -ForegroundColor Yellow
Write-Host "   Start Command:  " -NoNewline -ForegroundColor Gray
Write-Host "gunicorn app:app" -ForegroundColor Yellow
Write-Host "   Instance Type:  " -NoNewline -ForegroundColor Gray
Write-Host "Free" -ForegroundColor Yellow
Write-Host ""
Write-Host "5. Click 'Create Web Service'" -ForegroundColor Gray
Write-Host ""
Write-Host "6. Wait for deployment (~5-10 minutes)" -ForegroundColor Gray
Write-Host "   - Watch the logs in real-time" -ForegroundColor Gray
Write-Host "   - Status will change to 'Live' when ready" -ForegroundColor Gray
Write-Host ""
Write-Host "7. COPY THE URL that Render gives you" -ForegroundColor Green
Write-Host "   Example: https://vegetable-classifier-api.onrender.com" -ForegroundColor Gray
Write-Host ""

Wait-ForEnter "After deployment is LIVE, press ENTER..."

# STEP 4: Update Frontend
Show-Banner
Show-Step "4/5" "UPDATE FRONTEND WITH API URL"

Write-Host ""
$apiUrl = Read-Host "Paste your Render API URL (e.g., https://vegetable-classifier-api.onrender.com)"

if ([string]::IsNullOrWhiteSpace($apiUrl)) {
    Write-Host ""
    Write-Host "ERROR: API URL is required!" -ForegroundColor Red
    Write-Host "Please run this script again after getting the URL from Render." -ForegroundColor Yellow
    Wait-ForEnter
    exit 1
}

# Remove trailing slash if present
$apiUrl = $apiUrl.TrimEnd('/')

Write-Host ""
Write-Host "Updating frontend configuration..." -ForegroundColor Cyan

$frontendPath = "..\vegetable-classifier-web\js\script.js"

if (Test-Path $frontendPath) {
    $content = Get-Content $frontendPath -Raw
    
    # Update API_URL
    $content = $content -replace "API_URL: '[^']*'", "API_URL: '$apiUrl'"
    
    Set-Content $frontendPath $content -NoNewline
    
    Write-Host "Frontend updated with API URL: $apiUrl" -ForegroundColor Green
    
    # Commit and push
    Write-Host ""
    Write-Host "Committing changes to GitHub..." -ForegroundColor Cyan
    
    Push-Location "..\vegetable-classifier-web"
    
    git add js/script.js
    git commit -m "update: Connect to production API at $apiUrl"
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "SUCCESS! Frontend updated and pushed!" -ForegroundColor Green
    }
    
    Pop-Location
} else {
    Write-Host "ERROR: Frontend file not found at $frontendPath" -ForegroundColor Red
}

Wait-ForEnter

# STEP 5: Test Application
Show-Banner
Show-Step "5/5" "TEST APPLICATION"

Write-Host ""
Write-Host "Opening your live application..." -ForegroundColor Cyan
Start-Sleep -Seconds 2

$frontendUrl = "https://rivaldy-25-lval.github.io/Valll-vegetable-classifier-web/"
Start-Process $frontendUrl

Write-Host ""
Write-Host "Testing API health..." -ForegroundColor Cyan

try {
    $healthUrl = "$apiUrl/health"
    $response = Invoke-RestMethod -Uri $healthUrl -Method Get -TimeoutSec 30
    
    Write-Host ""
    Write-Host "API Health Check:" -ForegroundColor Green
    Write-Host "  Status:        $($response.status)" -ForegroundColor Gray
    Write-Host "  Model Loaded:  $($response.model_loaded)" -ForegroundColor Gray
    Write-Host "  Classes:       $($response.classes)" -ForegroundColor Gray
    
    if ($response.model_loaded -eq $true) {
        Write-Host ""
        Write-Host "EXCELLENT! API is fully operational!" -ForegroundColor Green
    }
} catch {
    Write-Host ""
    Write-Host "Note: API might still be starting up (cold start)" -ForegroundColor Yellow
    Write-Host "Wait 30-60 seconds and refresh the page" -ForegroundColor Gray
}

Write-Host ""
Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "        DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your application is now live at:" -ForegroundColor White
Write-Host "  $frontendUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend API:" -ForegroundColor White
Write-Host "  $apiUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "What to do next:" -ForegroundColor Yellow
Write-Host "  1. Wait 30 seconds for GitHub Pages to update" -ForegroundColor Gray
Write-Host "  2. Refresh the webpage (Ctrl+F5)" -ForegroundColor Gray
Write-Host "  3. Check status shows: 'API siap digunakan'" -ForegroundColor Gray
Write-Host "  4. Upload a vegetable image and test!" -ForegroundColor Gray
Write-Host ""
Write-Host "Troubleshooting:" -ForegroundColor Yellow
Write-Host "  - If 'Server tidak tersedia': Wait 1-2 minutes (cold start)" -ForegroundColor Gray
Write-Host "  - Check Render logs: https://render.com/dashboard" -ForegroundColor Gray
Write-Host "  - Browser console (F12) for detailed errors" -ForegroundColor Gray
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
