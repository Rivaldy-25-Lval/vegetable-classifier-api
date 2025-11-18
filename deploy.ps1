# Automatic Deployment Script for Vegetable Classifier
# This script will push backend to GitHub and guide you through Render deployment

Write-Host "================================" -ForegroundColor Cyan
Write-Host "VEGETABLE CLASSIFIER DEPLOYMENT" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Git
Write-Host "[1/5] Checking Git setup..." -ForegroundColor Yellow
$gitStatus = git status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Not a git repository!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Git repository ready" -ForegroundColor Green
Write-Host ""

# Step 2: Check files
Write-Host "[2/5] Verifying files..." -ForegroundColor Yellow
$requiredFiles = @("app.py", "requirements.txt", "Procfile", "model.h5")
foreach ($file in $requiredFiles) {
    if (!(Test-Path $file)) {
        Write-Host "✗ Missing: $file" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Found: $file" -ForegroundColor Green
}
Write-Host ""

# Step 3: Show current status
Write-Host "[3/5] Current Git status:" -ForegroundColor Yellow
git status --short
Write-Host ""

# Step 4: Get GitHub username
Write-Host "[4/5] GitHub Setup" -ForegroundColor Yellow
$username = Read-Host "Enter your GitHub username (default: Rivaldy-25-Lval)"
if ([string]::IsNullOrWhiteSpace($username)) {
    $username = "Rivaldy-25-Lval"
}
Write-Host "Using username: $username" -ForegroundColor Cyan
Write-Host ""

# Step 5: Instructions
Write-Host "[5/5] Next Steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "MANUAL STEPS REQUIRED:" -ForegroundColor Red
Write-Host "=====================" -ForegroundColor Red
Write-Host ""
Write-Host "1. CREATE GITHUB REPOSITORY:" -ForegroundColor Cyan
Write-Host "   - Go to: https://github.com/new" -ForegroundColor White
Write-Host "   - Repository name: vegetable-classifier-api" -ForegroundColor White
Write-Host "   - Visibility: Public" -ForegroundColor White
Write-Host "   - DO NOT initialize with README" -ForegroundColor White
Write-Host "   - Click 'Create repository'" -ForegroundColor White
Write-Host ""

Write-Host "2. AFTER CREATING REPO, RUN THESE COMMANDS:" -ForegroundColor Cyan
Write-Host ""
$repoUrl = "https://github.com/$username/vegetable-classifier-api.git"
Write-Host "   git remote add origin $repoUrl" -ForegroundColor Yellow
Write-Host "   git branch -M main" -ForegroundColor Yellow
Write-Host "   git push -u origin main" -ForegroundColor Yellow
Write-Host ""

Write-Host "3. DEPLOY ON RENDER.COM:" -ForegroundColor Cyan
Write-Host "   - Go to: https://render.com/dashboard" -ForegroundColor White
Write-Host "   - Click: New + → Web Service" -ForegroundColor White
Write-Host "   - Connect: vegetable-classifier-api repository" -ForegroundColor White
Write-Host "   - Settings:" -ForegroundColor White
Write-Host "     Name: vegetable-classifier-api" -ForegroundColor Gray
Write-Host "     Region: Singapore" -ForegroundColor Gray
Write-Host "     Runtime: Python 3" -ForegroundColor Gray
Write-Host "     Build Command: pip install -r requirements.txt" -ForegroundColor Gray
Write-Host "     Start Command: gunicorn app:app" -ForegroundColor Gray
Write-Host "     Type: Free" -ForegroundColor Gray
Write-Host "   - Click: Create Web Service" -ForegroundColor White
Write-Host ""

Write-Host "4. COPY API URL FROM RENDER" -ForegroundColor Cyan
Write-Host "   Example: https://vegetable-classifier-api.onrender.com" -ForegroundColor White
Write-Host ""

Write-Host "5. UPDATE FRONTEND:" -ForegroundColor Cyan
Write-Host "   Edit: vegetable-classifier-web/js/script.js" -ForegroundColor White
Write-Host "   Line 10: API_URL: 'YOUR_RENDER_URL'" -ForegroundColor White
Write-Host ""

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Ready to push to GitHub!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Ask if ready to continue
$continue = Read-Host "Have you created the GitHub repository? (y/n)"
if ($continue -eq "y" -or $continue -eq "Y") {
    Write-Host ""
    Write-Host "Adding remote and pushing..." -ForegroundColor Yellow
    
    # Check if remote exists
    $remoteExists = git remote get-url origin 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Remote already exists. Removing..." -ForegroundColor Yellow
        git remote remove origin
    }
    
    # Add remote
    git remote add origin $repoUrl
    
    # Rename branch
    git branch -M main
    
    # Push
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ Successfully pushed to GitHub!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Repository URL: https://github.com/$username/vegetable-classifier-api" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Now go to Render.com and follow step 3 above!" -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "✗ Push failed. Please check your credentials and try manually." -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "Please create the repository first, then run this script again." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
