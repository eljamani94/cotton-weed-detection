"""Utility functions for the Streamlit app"""
import base64
from PIL import Image
import io

def image_to_base64(image):
    """Convert PIL Image to base64 string"""
    buffered = io.BytesIO()
    image.save(buffered, format="JPEG")
    img_str = base64.b64encode(buffered.getvalue()).decode()
    return img_str

def base64_to_image(base64_string):
    """Convert base64 string to PIL Image"""
    img_data = base64.b64decode(base64_string)
    return Image.open(io.BytesIO(img_data))

