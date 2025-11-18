"""
Vegetable Classifier API
Flask backend for image classification using TensorFlow
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
from PIL import Image
import io
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Configuration
MODEL_PATH = 'model.h5'
IMAGE_SIZE = (128, 128)
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB

CLASS_LABELS = [
    'Bean',
    'Bitter_Gourd',
    'Bottle_Gourd',
    'Brinjal',
    'Broccoli',
    'Cabbage',
    'Capsicum',
    'Carrot',
    'Cauliflower',
    'Cucumber',
    'Papaya',
    'Potato',
    'Pumpkin',
    'Radish',
    'Tomato'
]

VEGETABLE_EMOJIS = {
    'Bean': '🫘',
    'Bitter_Gourd': '🥒',
    'Bottle_Gourd': '🍈',
    'Brinjal': '🍆',
    'Broccoli': '🥦',
    'Cabbage': '🥬',
    'Capsicum': '🫑',
    'Carrot': '🥕',
    'Cauliflower': '🥦',
    'Cucumber': '🥒',
    'Papaya': '🍈',
    'Potato': '🥔',
    'Pumpkin': '🎃',
    'Radish': '🌰',
    'Tomato': '🍅'
}

# Global model variable
model = None


def load_model():
    """Load the TensorFlow model"""
    global model
    try:
        logger.info(f"Loading model from {MODEL_PATH}...")
        model = tf.keras.models.load_model(MODEL_PATH)
        logger.info("✅ Model loaded successfully")
        logger.info(f"Model input shape: {model.input_shape}")
        logger.info(f"Model output shape: {model.output_shape}")
        
        # Warm up the model
        dummy_input = np.zeros((1, 128, 128, 3), dtype=np.float32)
        _ = model.predict(dummy_input, verbose=0)
        logger.info("✅ Model warmed up")
        
        return True
    except Exception as e:
        logger.error(f"❌ Error loading model: {str(e)}")
        return False


def preprocess_image(image_bytes):
    """
    Preprocess image for model prediction
    
    Args:
        image_bytes: Raw image bytes
        
    Returns:
        Preprocessed numpy array
    """
    try:
        # Open image
        image = Image.open(io.BytesIO(image_bytes))
        
        # Convert to RGB if needed
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Resize to model input size
        image = image.resize(IMAGE_SIZE)
        
        # Convert to numpy array
        img_array = np.array(image)
        
        # Normalize to [0, 1]
        img_array = img_array.astype(np.float32) / 255.0
        
        # Add batch dimension
        img_array = np.expand_dims(img_array, axis=0)
        
        return img_array
        
    except Exception as e:
        logger.error(f"Error preprocessing image: {str(e)}")
        raise


@app.route('/')
def home():
    """Health check endpoint"""
    return jsonify({
        'status': 'ok',
        'message': 'Vegetable Classifier API is running',
        'model_loaded': model is not None,
        'version': '1.0.0'
    })


@app.route('/health')
def health():
    """Detailed health check"""
    return jsonify({
        'status': 'healthy',
        'model_loaded': model is not None,
        'classes': len(CLASS_LABELS),
        'image_size': IMAGE_SIZE
    })


@app.route('/predict', methods=['POST'])
def predict():
    """
    Predict vegetable class from uploaded image
    
    Expected: multipart/form-data with 'image' field
    Returns: JSON with predictions
    """
    try:
        # Check if model is loaded
        if model is None:
            return jsonify({
                'error': 'Model not loaded',
                'message': 'Server is starting up, please try again'
            }), 503
        
        # Check if image file is present
        if 'image' not in request.files:
            return jsonify({
                'error': 'No image provided',
                'message': 'Please upload an image file'
            }), 400
        
        file = request.files['image']
        
        # Check if file is selected
        if file.filename == '':
            return jsonify({
                'error': 'No file selected',
                'message': 'Please select an image file'
            }), 400
        
        # Read image bytes
        image_bytes = file.read()
        
        # Check file size
        if len(image_bytes) > MAX_FILE_SIZE:
            return jsonify({
                'error': 'File too large',
                'message': f'Maximum file size is {MAX_FILE_SIZE / (1024*1024)}MB'
            }), 400
        
        # Preprocess image
        logger.info(f"Processing image: {file.filename}")
        processed_image = preprocess_image(image_bytes)
        
        # Make prediction
        predictions = model.predict(processed_image, verbose=0)[0]
        
        # Get top 5 predictions
        top_5_indices = np.argsort(predictions)[-5:][::-1]
        
        results = []
        for idx in top_5_indices:
            class_name = CLASS_LABELS[idx]
            probability = float(predictions[idx])
            
            results.append({
                'class': class_name,
                'emoji': VEGETABLE_EMOJIS.get(class_name, '🥬'),
                'probability': probability,
                'percentage': round(probability * 100, 2)
            })
        
        # Log prediction
        top_prediction = results[0]
        logger.info(f"✅ Prediction: {top_prediction['class']} ({top_prediction['percentage']}%)")
        
        return jsonify({
            'success': True,
            'predictions': results,
            'top_prediction': results[0]
        })
        
    except Exception as e:
        logger.error(f"❌ Error during prediction: {str(e)}")
        return jsonify({
            'error': 'Prediction failed',
            'message': str(e)
        }), 500


@app.route('/classes')
def get_classes():
    """Get list of all supported vegetable classes"""
    classes = [
        {
            'name': label,
            'emoji': VEGETABLE_EMOJIS.get(label, '🥬')
        }
        for label in CLASS_LABELS
    ]
    
    return jsonify({
        'classes': classes,
        'total': len(classes)
    })


# Load model on startup
@app.before_request
def initialize():
    """Initialize model before first request"""
    global model
    if model is None:
        load_model()


if __name__ == '__main__':
    # Load model
    if load_model():
        # Run the app
        port = int(os.environ.get('PORT', 5000))
        app.run(host='0.0.0.0', port=port, debug=False)
    else:
        logger.error("Failed to load model. Exiting...")
        exit(1)
