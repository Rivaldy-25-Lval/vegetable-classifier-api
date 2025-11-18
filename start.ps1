# Test API Locally
Write-Host "Starting Vegetable Classifier API..." -ForegroundColor Green

# Check files
if (!(Test-Path "app.py")) {
    Write-Host "Error: app.py not found!" -ForegroundColor Red
    exit 1
}

if (!(Test-Path "model.h5")) {
    Write-Host "Error: model.h5 not found!" -ForegroundColor Red
    exit 1
}

# Create venv if needed
if (!(Test-Path "venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Cyan
    python -m venv venv
}

# Activate venv
Write-Host "Activating virtual environment..." -ForegroundColor Cyan
& ".\venv\Scripts\Activate.ps1"

# Install requirements
Write-Host "Installing dependencies..." -ForegroundColor Cyan
pip install -q -r requirements.txt

Write-Host ""
Write-Host "API will be available at: http://localhost:5000" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop" -ForegroundColor Gray
Write-Host ""

# Run app
python app.py
