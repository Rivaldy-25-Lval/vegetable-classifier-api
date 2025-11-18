# Vegetable Classifier API 🥬🍅🥕

Backend API untuk klasifikasi gambar sayuran menggunakan TensorFlow dan Flask.

## 🚀 Features

- **REST API** untuk klasifikasi gambar sayuran
- **15 jenis sayuran** yang dapat dideteksi
- **TensorFlow** untuk inferensi model
- **CORS enabled** untuk frontend integration
- **Health check endpoints**
- **Top-5 predictions** dengan confidence scores

## 🥬 Supported Vegetables

Bean, Bitter Gourd, Bottle Gourd, Brinjal, Broccoli, Cabbage, Capsicum, Carrot, Cauliflower, Cucumber, Papaya, Potato, Pumpkin, Radish, Tomato

## 📡 API Endpoints

### `GET /`
Health check endpoint
```json
{
  "status": "ok",
  "message": "Vegetable Classifier API is running",
  "model_loaded": true,
  "version": "1.0.0"
}
```

### `POST /predict`
Predict vegetable class from image

**Request:**
- Method: POST
- Content-Type: multipart/form-data
- Body: image file (key: "image")

**Response:**
```json
{
  "success": true,
  "predictions": [
    {
      "class": "Tomato",
      "emoji": "🍅",
      "probability": 0.95,
      "percentage": 95.0
    }
  ],
  "top_prediction": {
    "class": "Tomato",
    "emoji": "🍅",
    "probability": 0.95,
    "percentage": 95.0
  }
}
```

### `GET /classes`
Get list of all supported vegetable classes

### `GET /health`
Detailed health check

## 🛠️ Local Development

1. **Clone repository**
```bash
git clone <repository-url>
cd vegetable-classifier-api
```

2. **Create virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Add model file**
Place your `model.h5` file in the root directory

5. **Run the app**
```bash
python app.py
```

API will be available at `http://localhost:5000`

## ☁️ Deployment to Render

1. **Push to GitHub**
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <your-github-repo>
git push -u origin main
```

2. **Deploy on Render.com**
   - Go to [render.com](https://render.com)
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Configure:
     - Name: `vegetable-classifier-api`
     - Environment: `Python 3`
     - Build Command: `pip install -r requirements.txt`
     - Start Command: `gunicorn app:app`
   - Click "Create Web Service"

3. **Upload model file**
   - After deployment, use Render's file upload or add model to GitHub LFS

## 📝 Environment Variables

- `PORT`: Port number (default: 5000, set automatically by Render)

## 🧪 Testing

Test the API with curl:

```bash
# Health check
curl https://your-api-url.onrender.com/

# Predict
curl -X POST -F "image=@path/to/image.jpg" https://your-api-url.onrender.com/predict

# Get classes
curl https://your-api-url.onrender.com/classes
```

## 📦 Tech Stack

- **Flask** - Web framework
- **TensorFlow** - ML inference
- **Pillow** - Image processing
- **Flask-CORS** - CORS support
- **Gunicorn** - Production server

## 📄 License

MIT License

## 👤 Author

Muhammad Rivaldy Pratama
