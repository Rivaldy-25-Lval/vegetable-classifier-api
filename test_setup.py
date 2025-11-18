"""
Test script to verify API structure without TensorFlow
"""

import os
import sys

print("🧪 Testing Vegetable Classifier API Setup...")
print("=" * 50)

# Test 1: Check files
print("\n[1] Checking required files:")
required_files = ['app.py', 'requirements.txt', 'Procfile', 'runtime.txt', 'model.h5']
for file in required_files:
    exists = os.path.exists(file)
    status = "✓" if exists else "✗"
    print(f"  {status} {file}")
    if not exists and file != 'model.h5':
        print(f"    ERROR: {file} is required!")
        sys.exit(1)

# Test 2: Check model size
print("\n[2] Checking model file:")
if os.path.exists('model.h5'):
    size_mb = os.path.getsize('model.h5') / (1024 * 1024)
    print(f"  ✓ model.h5 exists ({size_mb:.2f} MB)")
    if size_mb < 1:
        print("  ⚠️ Warning: Model file seems too small")
else:
    print("  ✗ model.h5 not found!")
    print("  Note: This is OK for testing, but required for production")

# Test 3: Check Python imports (without TensorFlow)
print("\n[3] Testing basic imports:")
try:
    import flask
    print(f"  ✓ Flask {flask.__version__}")
except ImportError:
    print("  ✗ Flask not installed")

try:
    import flask_cors
    print("  ✓ Flask-CORS installed")
except ImportError:
    print("  ✗ Flask-CORS not installed")

try:
    from PIL import Image
    print(f"  ✓ Pillow installed")
except ImportError:
    print("  ✗ Pillow not installed")

try:
    import numpy as np
    print(f"  ✓ NumPy {np.__version__}")
except ImportError:
    print("  ✗ NumPy not installed")

print("\n[4] Checking app.py structure:")
try:
    with open('app.py', 'r', encoding='utf-8') as f:
        content = f.read()
        
    checks = {
        'Flask app initialization': 'app = Flask(__name__)' in content,
        'CORS enabled': 'CORS(app)' in content,
        'Health endpoint': "@app.route('/health')" in content,
        'Predict endpoint': "@app.route('/predict'" in content,
        'Classes endpoint': "@app.route('/classes')" in content,
    }
    
    for check, result in checks.items():
        status = "✓" if result else "✗"
        print(f"  {status} {check}")
        
except Exception as e:
    print(f"  ✗ Error reading app.py: {e}")

# Test 4: Check requirements.txt
print("\n[5] Checking requirements.txt:")
try:
    with open('requirements.txt', 'r') as f:
        requirements = [line.strip() for line in f if line.strip() and not line.startswith('#')]
    
    print(f"  ✓ {len(requirements)} packages specified:")
    for req in requirements:
        print(f"    - {req}")
except Exception as e:
    print(f"  ✗ Error reading requirements.txt: {e}")

# Test 5: Check Procfile
print("\n[6] Checking Procfile:")
try:
    with open('Procfile', 'r') as f:
        procfile = f.read().strip()
    
    if 'gunicorn app:app' in procfile:
        print(f"  ✓ Procfile correct: {procfile}")
    else:
        print(f"  ⚠️ Procfile content: {procfile}")
        print("     Expected: web: gunicorn app:app")
except Exception as e:
    print(f"  ✗ Error reading Procfile: {e}")

# Test 6: Git LFS check
print("\n[7] Checking Git LFS:")
if os.path.exists('.gitattributes'):
    with open('.gitattributes', 'r') as f:
        content = f.read()
    if '*.h5' in content:
        print("  ✓ Git LFS configured for .h5 files")
    else:
        print("  ⚠️ .gitattributes exists but .h5 not tracked")
else:
    print("  ⚠️ .gitattributes not found (Git LFS not configured)")

print("\n" + "=" * 50)
print("✅ API structure verification complete!")
print("\nNext steps:")
print("1. Run: .\\deploy.ps1")
print("2. Follow the instructions to push to GitHub")
print("3. Deploy on Render.com")
print("=" * 50)
