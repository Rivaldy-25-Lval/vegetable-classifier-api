# ✅ BACKEND PUSHED TO GITHUB!

Repository: https://github.com/Rivaldy-25-Lval/vegetable-classifier-api

---

## 🚀 NEXT: DEPLOY KE RENDER.COM (10 MENIT)

Browser sudah dibuka ke Render.com. Ikuti langkah ini:

### STEP 1: Sign Up / Login (2 menit)

1. **Pilih**: "Sign up with GitHub" (RECOMMENDED!)
   - Atau "Continue with GitHub" jika sudah punya akun
   
2. **Authorize Render** untuk akses GitHub repositories
   - Klik "Authorize Render"

### STEP 2: Create Web Service (2 menit)

1. **Di Dashboard Render**, klik: **"New +"** (pojok kanan atas)

2. **Pilih**: **"Web Service"**

3. **Connect Repository**:
   - Cari: `vegetable-classifier-api`
   - Klik: **"Connect"**

### STEP 3: Configure Service (1 menit)

**COPY SETTINGS INI PERSIS!**

```
Name:                 vegetable-classifier-api
Region:               Singapore
Branch:               main
Root Directory:       (leave empty)
Runtime:              Python 3
Build Command:        pip install -r requirements.txt
Start Command:        gunicorn app:app
Instance Type:        Free
```

**Detail untuk setiap field:**

- **Name**: `vegetable-classifier-api`
- **Region**: Pilih `Singapore` (terdekat dengan Indonesia)
- **Branch**: `main`
- **Root Directory**: **KOSONGKAN** (leave empty)
- **Runtime**: Pilih `Python 3`
- **Build Command**: 
  ```
  pip install -r requirements.txt
  ```
- **Start Command**: 
  ```
  gunicorn app:app
  ```
- **Instance Type**: Pilih `Free`

### STEP 4: Deploy! (5-10 menit)

1. **Klik**: **"Create Web Service"** (tombol biru di bawah)

2. **Tunggu deployment**:
   - ⏳ Building... (~3-5 menit)
   - ⏳ Installing Python packages... (~2-3 menit)
   - ⏳ Loading model... (~1-2 menit)
   - ✅ **Live!**

3. **Watch the logs**:
   - Scroll di tab "Logs"
   - Lihat progress real-time
   - Tunggu sampai ada tulisan "Booting worker" dan "Application startup complete"

4. **Saat status berubah ke "Live"**:
   - ✅ Service running!
   - Copy URL yang muncul di atas

### STEP 5: Copy API URL

URL akan seperti ini:
```
https://vegetable-classifier-api.onrender.com
```

**COPY URL INI!** Kita butuh untuk update frontend.

---

## ⏭️ AFTER RENDER IS LIVE:

Jalankan command ini di PowerShell:

```powershell
cd "c:\Users\mriva\OneDrive\Dokumen\New folder"

# Ganti YOUR_RENDER_URL dengan URL yang di-copy dari Render
$apiUrl = "https://vegetable-classifier-api.onrender.com"

# Update frontend
cd vegetable-classifier-web
(Get-Content js\script.js -Raw) -replace "API_URL: '[^']*'", "API_URL: '$apiUrl'" | Set-Content js\script.js

# Commit and push
git add js\script.js
git commit -m "update: Connect to production API"
git push origin main

# Open website
Start-Process "https://rivaldy-25-lval.github.io/Valll-vegetable-classifier-web/"
```

**Atau jalankan script otomatis saya:**

```powershell
cd "c:\Users\mriva\OneDrive\Dokumen\New folder\vegetable-classifier-api"
.\update-frontend.ps1
```

---

## ⚠️ TROUBLESHOOTING

### Render Deployment Errors:

**Error: "Failed to install packages"**
- Check logs untuk detail
- Biasanya karena dependency conflict
- Tunggu dan retry (kadang server Render sibuk)

**Error: "Application failed to start"**
- Check logs: Cari "ERROR" atau "FAILED"
- Pastikan `model.h5` ter-upload (check Git LFS)
- Restart service: Settings → "Manual Deploy"

**Deployment stuck di "Building..."**
- Normal jika lebih dari 5 menit
- Free tier kadang antri
- Jangan refresh, biarkan running

### First Request Lambat:

**Normal!** Free tier Render akan:
- Sleep setelah 15 menit tidak ada request
- Cold start = 30-60 detik untuk wake up
- Request berikutnya cepat (~1-2 detik)

---

## 📞 NEED HELP?

Check Render logs:
1. Dashboard → Your service
2. Tab "Logs"
3. Scroll untuk lihat error messages

Common fixes:
- Restart service (Settings → Manual Deploy)
- Check environment (Settings → Environment)
- Verify GitHub repo connected (Settings → Repository)

---

## 🎉 SETELAH LIVE:

Website Anda akan 100% functional di:
**https://rivaldy-25-lval.github.io/Valll-vegetable-classifier-web/**

Test dengan upload gambar sayuran dan lihat prediksi! 🥬🍅🥕
