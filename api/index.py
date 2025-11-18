# Vercel Serverless Function for Vegetable Classifier

from flask import Flask, request, jsonify
from app import app as flask_app

# Export for Vercel
app = flask_app
