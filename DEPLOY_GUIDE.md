# 🚀 PANDUAN DEPLOY BACKEND API KE RENDER

## 📋 Prerequisites

1. ✅ Akun GitHub (sudah ada)
2. ✅ File model.h5 (sudah ada di folder)
3. 🆕 Akun Render.com (gratis - buat di https://render.com)

---

## 🔧 STEP 1: Buat Repository GitHub untuk Backend

1. **Buka GitHub** dan buat repository baru:
   - Nama: `vegetable-classifier-api`
   - Visibility: Public
   - Jangan centang "Initialize with README" (karena kita sudah punya)

2. **Copy URL repository** yang baru dibuat

3. **Push backend code ke GitHub**:

```powershell
cd "c:\Users\mriva\OneDrive\Dokumen\New folder\vegetable-classifier-api"

# Tambahkan remote
git remote add origin https://github.com/Rivaldy-25-Lval/vegetable-classifier-api.git

# Push ke GitHub
git branch -M main
git push -u origin main
```

---

## ⚠️ STEP 2: Upload Model.h5 (PENTING!)

Model file (5MB+) terlalu besar untuk Git biasa. Ada 2 cara:

### Opsi A: Upload via Render Dashboard (RECOMMENDED)
1. Deploy dulu tanpa model (akan error)
2. Setelah service dibuat, upload model.h5 via Render Shell
3. Restart service

### Opsi B: Gunakan Git LFS (Lebih Teknis)
```powershell
# Install Git LFS
git lfs install

# Track file .h5
git lfs track "*.h5"
git add .gitattributes
git add model.h5
git commit -m "Add model via Git LFS"
git push origin main
```

**UNTUK SEKARANG, SKIP DULU - KITA UPLOAD MANUAL NANTI**

---

## 🌐 STEP 3: Deploy ke Render.com

### 3.1 Buat Akun Render

1. Buka https://render.com
2. Klik **"Get Started"**
3. Sign up dengan GitHub (pilih ini untuk auto-deployment)
4. Authorize Render untuk akses GitHub repositories

### 3.2 Create Web Service

1. **Klik "New +"** di dashboard Render
2. Pilih **"Web Service"**
3. **Connect Repository**:
   - Cari dan pilih `vegetable-classifier-api`
   - Klik "Connect"

4. **Configure Service**:
   
   ```
   Name: vegetable-classifier-api
   Region: Singapore (paling dekat dengan Indonesia)
   Branch: main
   Root Directory: (kosongkan)
   Runtime: Python 3
   Build Command: pip install -r requirements.txt
   Start Command: gunicorn app:app
   Instance Type: Free
   ```

5. **Environment Variables** (opsional):
   - Untuk sekarang kosongkan dulu

6. **Klik "Create Web Service"**

7. **Tunggu deployment** (~5-10 menit):
   - Render akan build dan deploy otomatis
   - Lihat log di dashboard
   - ⚠️ AKAN ERROR karena model.h5 belum ada - ini normal!

### 3.3 Upload Model File

Setelah service selesai deploy (walau error):

1. **Buka service di Render dashboard**
2. **Klik tab "Shell"** (di menu kiri)
3. **Tunggu shell terbuka** (loading ~30 detik)
4. **Upload model.h5**:
   - Klik icon "Upload File" di shell
   - Pilih `model.h5` dari folder lokal
   - Tunggu upload selesai (~1-2 menit untuk 5MB)

5. **Verify upload**:
   ```bash
   ls -lh model.h5
   ```
   Harus muncul file dengan ukuran ~5MB

6. **Restart service**:
   - Klik tab "Settings"
   - Scroll ke bawah
   - Klik "Manual Deploy" → "Clear build cache & deploy"
   - ATAU klik tombol "Restart" di pojok kanan atas

7. **Tunggu restart selesai** (~2-3 menit)

### 3.4 Verify Deployment

1. **Copy URL service** (contoh: `https://vegetable-classifier-api.onrender.com`)

2. **Test API** di browser atau terminal:

```powershell
# Test health endpoint
curl https://vegetable-classifier-api.onrender.com/health

# Harus return JSON:
# {"status":"healthy","model_loaded":true,"classes":15,"image_size":[128,128]}
```

3. **Test dengan gambar** (via Postman atau curl):
```powershell
curl -X POST -F "image=@path/to/tomato.jpg" https://vegetable-classifier-api.onrender.com/predict
```

---

## 🔗 STEP 4: Update Frontend dengan API URL

Setelah API berhasil deploy:

1. **Copy URL API** dari Render (contoh: `https://vegetable-classifier-api.onrender.com`)

2. **Update frontend config**:

Buka file: `vegetable-classifier-web/js/script.js`

Ubah baris ini:
```javascript
API_URL: 'https://vegetable-classifier-api.onrender.com',  // ⬅️ UPDATE INI!
```

Dengan URL API yang sebenarnya dari Render.

3. **Commit dan push**:
```powershell
cd "c:\Users\mriva\OneDrive\Dokumen\New folder\vegetable-classifier-web"
git add js/script.js
git commit -m "update: Set production API URL"
git push origin main
```

4. **Tunggu 1-2 menit** untuk GitHub Pages update

---

## ✅ STEP 5: TEST APLIKASI

1. **Buka website**: https://rivaldy-25-lval.github.io/Valll-vegetable-classifier-web/

2. **Check Console** (F12 → Console):
   - Harus ada log "✅ API is healthy"
   - Status harus "API siap digunakan ✓"

3. **Upload gambar sayuran**:
   - Pilih gambar tomat/wortel/kubis
   - Klik "Analisis Gambar"
   - Harus muncul hasil prediksi!

---

## 🎉 SELESAI!

Aplikasi sekarang:
- ✅ Frontend di GitHub Pages
- ✅ Backend di Render.com
- ✅ Model berjalan di server
- ✅ CORS enabled
- ✅ Free tier untuk keduanya

---

## ⚠️ CATATAN PENTING

### Free Tier Render:
- Service akan **sleep setelah 15 menit tidak digunakan**
- **First request akan lambat** (~30-60 detik) karena cold start
- Solusi: Ping service setiap 10 menit dengan cron job (opsional)

### Jika Error "Server tidak tersedia":
1. Tunggu 1-2 menit (cold start)
2. Refresh halaman
3. Check Render logs untuk error
4. Pastikan model.h5 sudah terupload

### Monitoring:
- Lihat logs di Render dashboard → tab "Logs"
- Check metrics di tab "Metrics"
- Set up alerts (opsional)

---

## 🔄 AUTO-DEPLOYMENT

Setiap kali push ke GitHub:
- Backend akan auto-deploy di Render
- Frontend akan auto-deploy di GitHub Pages

Tidak perlu manual deploy lagi! 🎊

---

## 📞 TROUBLESHOOTING

### Error: "Model not loaded"
- Pastikan model.h5 ada di root directory
- Check ukuran file: `ls -lh model.h5` di Render shell
- Restart service

### Error: "CORS"
- Pastikan `flask-cors` ter-install
- Check `CORS(app)` ada di app.py

### Error: "404 Not Found"
- Check URL API benar di frontend
- Pastikan service running di Render

### Slow Response
- Normal di free tier (cold start)
- Tunggu 30-60 detik di first request
- Setelah warm, response cepat (~1-2 detik)

---

**Good luck! 🚀**
