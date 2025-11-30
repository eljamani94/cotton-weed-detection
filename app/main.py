"""
Streamlit Frontend Application
Unified interface with file upload (drag and drop) for all devices
VERSION: 2.0 - AGRICULTURAL GREEN THEME
"""
import streamlit as st
import streamlit.components.v1 as components
import sys
import os

# DEBUG: Print file location to verify we're running the right file
print(f"DEBUG: Running main.py from: {os.path.abspath(__file__)}", file=sys.stderr)
print(f"DEBUG: Python executable: {sys.executable}", file=sys.stderr)
import requests
import io
from PIL import Image, ImageDraw, ImageFont
import time
from datetime import datetime
import os
import json
from collections import Counter

# Configuration
API_URL = os.getenv("API_URL", "http://localhost:8000")

# Page configuration
st.set_page_config(
    page_title="Cotton Weed Detection",
    page_icon="🌱",
    layout="wide",
    initial_sidebar_state="collapsed"
)

def draw_boxes(image, predictions):
    """Draw bounding boxes and labels on image with AR-style, different colors per class"""
    draw = ImageDraw.Draw(image)
    
    # Try to load a better font
    try:
        # Try different font sizes based on image size - LARGER for better readability
        img_width = image.width
        font_size = max(20, int(img_width / 30))  # Increased from /40 to /30
        large_font_size = max(28, int(img_width / 20))  # Increased from /30 to /20 for class names
        
        try:
            font = ImageFont.truetype("arial.ttf", font_size)
            large_font = ImageFont.truetype("arial.ttf", large_font_size)
        except:
            try:
                font = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", font_size)
                large_font = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", large_font_size)
            except:
                font = ImageFont.load_default()
                large_font = ImageFont.load_default()
    except:
        font = ImageFont.load_default()
        large_font = ImageFont.load_default()
    
    # Fixed color mapping for each class - consistent colors
    classes = predictions.get("classes", [])
    unique_classes = list(set(classes))
    
    # Define fixed colors for known classes
    color_map = {
        "green": "#00ff41",
        "red": "#ff0040",
        "blue": "#0080ff"
    }
    
    # Fixed color mapping for specific classes (lowercase for consistency)
    # Based on actual model classes: carpetweed, morningglory, palmer_amaranth
    fixed_class_colors = {
        "morningglory": color_map["red"],      # Always red
        "carpetweed": color_map["green"],      # Always green
        "palmer_amaranth": color_map["blue"],  # Always blue
        # Handle variations/spaces
        "morning glory": color_map["red"],
        "morning-glory": color_map["red"],
        "palmer amaranth": color_map["blue"],
    }
    
    # Assign colors to classes - use fixed colors if available, otherwise cycle
    class_colors = {}
    colors_list = ["green", "red", "blue"]
    
    # First, assign fixed colors to known classes (case-insensitive matching)
    for cls in unique_classes:
        cls_lower = cls.lower().strip()
        if cls_lower in fixed_class_colors:
            class_colors[cls] = fixed_class_colors[cls_lower]
    
    # Then assign cycling colors to classes without fixed colors
    sorted_classes = sorted(unique_classes)
    color_idx = 0
    for cls in sorted_classes:
        if cls not in class_colors:
            color_key = colors_list[color_idx % len(colors_list)]
            class_colors[cls] = color_map[color_key]
            color_idx += 1
    
    for box, class_name, confidence in zip(
        predictions.get("boxes", []),
        predictions.get("classes", []),
        predictions.get("confidences", [])
    ):
        x1, y1, x2, y2 = box
        
        # Get color for this class - check fixed colors first (case-insensitive)
        class_name_lower = class_name.lower().strip()
        
        # First try fixed colors dictionary
        if class_name_lower in fixed_class_colors:
            box_color = fixed_class_colors[class_name_lower]
        # Then try the pre-assigned class_colors dictionary
        elif class_name in class_colors:
            box_color = class_colors[class_name]
        # Try case-insensitive lookup in class_colors
        else:
            box_color = None
            for cls, color in class_colors.items():
                if cls.lower().strip() == class_name_lower:
                    box_color = color
                    break
            # If still not found, default to green
            if box_color is None:
                box_color = color_map["green"]
        label_bg_color = box_color
        # Use white text with black outline for maximum readability on colored backgrounds
        label_text_color = "#FFFFFF"  # White text
        text_outline_color = "#000000"  # Black outline for contrast
        
        # Draw rectangle with thicker border (AR-style)
        border_width = max(3, int(image.width / 200))
        draw.rectangle([x1, y1, x2, y2], outline=box_color, width=border_width)
        
        # Draw corner markers (AR-style)
        corner_length = max(10, int(image.width / 50))
        # Top-left
        draw.line([x1, y1, x1 + corner_length, y1], fill=box_color, width=border_width)
        draw.line([x1, y1, x1, y1 + corner_length], fill=box_color, width=border_width)
        # Top-right
        draw.line([x2, y1, x2 - corner_length, y1], fill=box_color, width=border_width)
        draw.line([x2, y1, x2, y1 + corner_length], fill=box_color, width=border_width)
        # Bottom-left
        draw.line([x1, y2, x1 + corner_length, y2], fill=box_color, width=border_width)
        draw.line([x1, y2, x1, y2 - corner_length], fill=box_color, width=border_width)
        # Bottom-right
        draw.line([x2, y2, x2 - corner_length, y2], fill=box_color, width=border_width)
        draw.line([x2, y2, x2, y2 - corner_length], fill=box_color, width=border_width)
        
        # Draw label with improved readability
        # Format class name: capitalize and replace underscores with spaces
        formatted_class_name = class_name.replace('_', ' ').title()
        label = f"{formatted_class_name.upper()}"
        confidence_text = f"{confidence:.1%}"
        
        # Get text dimensions for class name
        label_bbox = draw.textbbox((0, 0), label, font=large_font)
        label_width = label_bbox[2] - label_bbox[0]
        label_height = label_bbox[3] - label_bbox[1]
        
        # Get text dimensions for confidence
        conf_bbox = draw.textbbox((0, 0), confidence_text, font=font)
        conf_width = conf_bbox[2] - conf_bbox[0]
        conf_height = conf_bbox[3] - conf_bbox[1]
        
        # Position label above box with more padding - increased for larger text
        label_padding = 12
        total_width = label_width + conf_width + 20
        total_height = max(label_height, conf_height)
        label_x = x1
        label_y = max(0, y1 - total_height - label_padding * 2)
        
        # Draw label background with dark border for better contrast
        # Draw a slightly larger dark rectangle first for outline effect
        draw.rectangle(
            [label_x - label_padding - 2, label_y - label_padding - 2, 
             label_x + total_width + label_padding * 2 + 2, label_y + total_height + label_padding * 2 + 2],
            fill="#000000",  # Black border/outline
            outline="#000000",
            width=2
        )
        
        # Draw colored background box on top
        draw.rectangle(
            [label_x - label_padding, label_y - label_padding, 
             label_x + total_width + label_padding * 2, label_y + total_height + label_padding * 2],
            fill=label_bg_color,
            outline=box_color,
            width=2
        )
        
        # Draw label text with outline for better readability
        # Draw text outline (shadow effect) for maximum contrast - thicker outline for larger text
        outline_offset = 3
        for adj in range(-outline_offset, outline_offset + 1):
            for adj2 in range(-outline_offset, outline_offset + 1):
                if abs(adj) == outline_offset or abs(adj2) == outline_offset:
                    draw.text((label_x + adj, label_y + adj2), label, fill=text_outline_color, font=large_font)
                    draw.text((label_x + label_width + 10 + adj, label_y + 4 + adj2), confidence_text, fill=text_outline_color, font=font)

        # Draw main label text (white) - bold and clear
        draw.text((label_x, label_y), label, fill=label_text_color, font=large_font)
        draw.text((label_x + label_width + 10, label_y + 4), confidence_text, fill=label_text_color, font=font)
    
    return image

def predict_image(image_bytes):
    """Send image to API and get predictions"""
    try:
        files = {"file": ("image.jpg", image_bytes, "image/jpeg")}
        response = requests.post(f"{API_URL}/predict", files=files, timeout=30)
        
        if response.status_code == 200:
            return response.json()
        else:
            st.error(f"API Error: {response.status_code}")
            return None
    except Exception as e:
        st.error(f"Error calling API: {str(e)}")
        return None

def get_background_image_base64():
    """Load background image and convert to base64 for CSS embedding"""
    background_path = os.path.join(os.path.dirname(__file__), "assets", "background.jpg")
    # Try other extensions too
    extensions = [".jpg", ".jpeg", ".png", ".webp"]
    
    for ext in extensions:
        test_path = background_path.replace(".jpg", ext)
        if os.path.exists(test_path):
            with open(test_path, "rb") as img_file:
                import base64
                img_data = base64.b64encode(img_file.read()).decode()
                # Determine MIME type
                mime_type = "image/jpeg"
                if ext == ".png":
                    mime_type = "image/png"
                elif ext == ".webp":
                    mime_type = "image/webp"
                return f"data:{mime_type};base64,{img_data}"
    
    return None

def main():
    # Load background image if it exists
    bg_image = get_background_image_base64()
    
    # Build background style
    if bg_image:
        # Image first, then lighter gradient overlay (lower opacity = more visible image)
        bg_style = f"""background-image: url('{bg_image}'),
                          linear-gradient(135deg, rgba(85, 107, 47, 0.3) 0%, rgba(107, 142, 35, 0.3) 100%) !important;
                          background-size: cover !important;
                          background-position: center center !important;
                          background-attachment: fixed !important;
                          background-repeat: no-repeat !important;"""
    else:
        bg_style = "background: linear-gradient(135deg, #556B2F 0%, #6B8E23 100%) !important;"
    
    # Inject custom CSS for agricultural green theme - MUST BE FIRST
    # Build the complete CSS string with proper escaping
    css_content = f"""
    <style>
    /* Modern Agricultural Green Theme - Clean & Simple with Background Image */
    html, body, [class*="stApp"] {{
        {bg_style}
    }}
    
    .stApp {{
        {bg_style}
    }}
    
    /* Completely remove anchor links (link icons) beside headings */
    h1 a, h2 a, h3 a, h4 a,
    .element-container h1 a,
    .element-container h2 a,
    .element-container h3 a,
    .element-container h4 a,
    [class*="stMarkdown"] h1 a,
    [class*="stMarkdown"] h2 a,
    [class*="stMarkdown"] h3 a,
    [class*="stMarkdown"] h4 a {{
        display: none !important;
        visibility: hidden !important;
        opacity: 0 !important;
        width: 0 !important;
        height: 0 !important;
        margin: 0 !important;
        padding: 0 !important;
        position: absolute !important;
        left: -9999px !important;
    }}
    
    /* Headers */
    h1, h2, h3 {{
        color: #F4D03F !important;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif !important;
        text-transform: uppercase !important;
        letter-spacing: 1px !important;
        font-weight: 700 !important;
    }}
    
    /* File uploader styling */
    .uploadedFile {{
        border: 2px dashed #F4D03F !important;
        background-color: rgba(244, 208, 63, 0.05) !important;
    }}
    
    /* Hide Sidebar completely */
    [data-testid="stSidebar"] {{
        display: none !important;
    }}
    
    /* Hide sidebar toggle button */
    [data-testid="stSidebarToggleButton"] {{
        display: none !important;
    }}
    
    /* Adjust main content when sidebar is hidden */
    .main .block-container {{
        padding-left: 1rem !important;
        padding-right: 1rem !important;
    }}
    
    /* Analysis box background - ensure soft brown shows */
    .analysis-box,
    [data-testid="stMarkdownContainer"] div[style*="background-color: #8B7355"],
    [data-testid="stMarkdownContainer"] div[style*="background: #8B7355"],
    div.analysis-box {{
        background-color: #8B7355 !important;
        background: #8B7355 !important;
    }}
    
    /* Text */
    p, span, div, label {{
        color: #F9F9F9 !important;
    }}
    
    /* Metrics */
    [data-testid="stMetricValue"] {{
        color: #F4D03F !important;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
        font-size: 2.5rem;
        font-weight: 700 !important;
    }}
    
    [data-testid="stMetricLabel"] {{
        color: #E8E8E8 !important;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
    }}
    
    /* Info boxes */
    .stInfo {{
        background-color: rgba(244, 208, 63, 0.1) !important;
        border-left: 4px solid #F4D03F !important;
        color: #F9F9F9 !important;
    }}
    
    /* Success */
    .stSuccess {{
        background-color: rgba(244, 208, 63, 0.15) !important;
        border: 1px solid #F4D03F !important;
        color: #F4D03F !important;
    }}
    
    /* Buttons */
    .stButton > button {{
        background-color: transparent !important;
        color: #F4D03F !important;
        border: 2px solid #F4D03F !important;
        font-weight: 600 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.5px !important;
        border-radius: 20px !important;
    }}
    
    .stButton > button:hover {{
        background-color: #F4D03F !important;
        color: #556B2F !important;
    }}
    
    /* Global tooltip styling - make help text visible */
    [data-testid="stTooltip"],
    div[role="tooltip"],
    [class*="tooltip"],
    [class*="Tooltip"],
    [data-baseweb="popover"],
    [data-baseweb="tooltip"] {{
        background-color: #556B2F !important;
        border: 2px solid #F4D03F !important;
        color: #F4D03F !important;
        border-radius: 4px !important;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3) !important;
    }}
    
    [data-testid="stTooltip"] *,
    div[role="tooltip"] *,
    [class*="tooltip"] *,
    [class*="Tooltip"] *,
    [data-baseweb="popover"] *,
    [data-baseweb="tooltip"] * {{
        color: #F4D03F !important;
    }}
    </style>
    """
    st.markdown(css_content, unsafe_allow_html=True)
    
    # Unified layout for all devices - file upload with drag and drop
    st.markdown("""
        <div style="text-align: center; padding: 1rem 0; width: 100%; margin: 0 auto;">
            <h1 style="color: #F4D03F; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; text-transform: uppercase; 
                       letter-spacing: 2px; font-weight: 700; margin: 0 auto 0.5rem auto; 
                       font-size: clamp(2.5rem, 7vw, 5rem); line-height: 1.2; text-align: center; width: 100%;">
                COTTON WEED DETECTION SYSTEM
            </h1>
            <p style="color: #E8E8E8; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: clamp(1rem, 3vw, 2rem); letter-spacing: 1px; font-weight: 700; text-transform: uppercase; margin: 0.5rem auto 0 auto; text-align: center; width: 100%;">
                SMART WEED IDENTIFICATION FOR MODERN FARMING
            </p>
        </div>
        """, unsafe_allow_html=True)
    
    st.markdown("---")

    # Hide the Streamlit file uploader completely
    st.markdown("""
    <style>
    [data-testid="stFileUploader"] {
        position: absolute;
        opacity: 0;
        height: 0;
        overflow: hidden;
    }
    </style>
    """, unsafe_allow_html=True)

    # Custom "Detect weeds" button using HTML component
    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        # Create custom button that triggers the hidden file uploader
        components.html("""
        <style>
            body {
                margin: 0;
                padding: 10px 0;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100%;
            }
            .detect-btn {
                background-color: #F4D03F;
                color: #556B2F;
                border: none;
                font-weight: 800;
                letter-spacing: 2px;
                border-radius: 16px;
                padding: 1.5rem 4rem;
                font-size: clamp(1.2rem, 4vw, 1.8rem);
                min-width: 280px;
                max-width: 90vw;
                cursor: pointer;
                box-shadow: 0 6px 25px rgba(244, 208, 63, 0.5);
                transition: all 0.3s ease;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                display: block;
                margin: 0 auto;
                text-transform: uppercase;
                box-sizing: border-box;
            }
            .detect-btn:hover {
                background-color: #FFE66D;
                transform: translateY(-3px) scale(1.02);
                box-shadow: 0 10px 35px rgba(244, 208, 63, 0.7);
            }
            .detect-btn:active {
                transform: translateY(-1px);
            }

            /* Mobile responsive */
            @media (max-width: 600px) {
                .detect-btn {
                    padding: 1.2rem 2.5rem;
                    min-width: 200px;
                    letter-spacing: 1px;
                }
            }
        </style>
        <button class="detect-btn" onclick="
            // Find the Streamlit file uploader input in the parent document
            const fileInput = window.parent.document.querySelector('[data-testid=\\'stFileUploader\\'] input[type=\\'file\\']');
            if (fileInput) {
                fileInput.click();
            }
        ">
            Detect weeds
        </button>
        """, height=150)

        # Hidden Streamlit file uploader (handles the actual upload)
        uploaded_file = st.file_uploader(
            "Upload",
            type=['jpg', 'jpeg', 'png'],
            key="file_uploader",
            label_visibility="collapsed"
        )
    
    # Auto-detect when file is uploaded
    if uploaded_file is not None:
        # Get file info to check if it's a new file
        file_id = f"{uploaded_file.name}_{uploaded_file.size}"
        last_file_id = st.session_state.get('last_file_id', None)
        
        # Only process if this is a new file (not already processed)
        if file_id != last_file_id:
            image_bytes = uploaded_file.read()
            
            # Show loading state with custom styled message
            loading_placeholder = st.empty()
            loading_placeholder.markdown("""
            <div style="text-align: center; padding: 2rem 0;">
                <p style="font-size: 1.5rem; font-weight: bold; color: #F4D03F; 
                          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;">
                    Looking for weeds… it won't take long!
                </p>
            </div>
            """, unsafe_allow_html=True)
            
            predictions = predict_image(image_bytes)
            
            # Clear loading message
            loading_placeholder.empty()
            
            if predictions:
                st.session_state['last_prediction'] = {
                    'image': image_bytes,
                    'predictions': predictions,
                    'timestamp': datetime.now()
                }
                st.session_state['last_file_id'] = file_id
        # Results will be displayed in the section below automatically
    
    # Display results in full-width
    if 'last_prediction' in st.session_state:
        pred_data = st.session_state['last_prediction']
        image = Image.open(io.BytesIO(pred_data['image']))
        predictions = pred_data['predictions']
        
        # Draw bounding boxes with AR-style
        annotated_image = draw_boxes(image.copy(), predictions)
        
        # Full-width image display
        st.markdown("""
        <div style="text-align: center; margin: 2rem 0;">
            <h2 style="color: #F4D03F; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; text-transform: uppercase; font-weight: 600;">
                DETECTION RESULTS
            </h2>
        </div>
        """, unsafe_allow_html=True)
        
        # Display image in large format
        st.image(annotated_image, use_container_width=True)
        
        # Simple Detected Classes Section
        num_detections = len(predictions.get("boxes", []))
        
        if num_detections > 0:
            # Prepare classes data
            classes_data = list(zip(
                predictions.get("classes", []),
                predictions.get("confidences", [])
            ))
            
            # Group by class name
            class_counts = Counter([c[0] for c in classes_data])
            class_confidences = {}
            for class_name, conf in classes_data:
                if class_name not in class_confidences:
                    class_confidences[class_name] = []
                class_confidences[class_name].append(conf)
            
            # Get color mapping for classes (same as in draw_boxes function)
            color_map = {
                "green": "#00ff41",
                "red": "#ff0040",
                "blue": "#0080ff"
            }
            
            fixed_class_colors = {
                "morningglory": color_map["red"],
                "carpetweed": color_map["green"],
                "palmer_amaranth": color_map["blue"],
                "morning glory": color_map["red"],
                "morning-glory": color_map["red"],
                "palmer amaranth": color_map["blue"],
            }
            
            # Build classes HTML content with prominent color markers matching annotation colors
            classes_html_content = ""
            for class_name, count in class_counts.items():
                class_display = class_name.replace('_', ' ').title()
                class_name_lower = class_name.lower().strip()

                # Get color for this class (same logic as draw_boxes)
                if class_name_lower in fixed_class_colors:
                    class_color = fixed_class_colors[class_name_lower]
                else:
                    # Default to green if not found
                    class_color = color_map["green"]

                # Enhanced color marker design - larger, more visible, matches bounding box colors exactly
                classes_html_content += (
                    '<div style="margin: 0.8rem 0; padding: 0.8rem 1rem; border-left: 6px solid ' + class_color + '; display: flex; align-items: center; gap: 1.2rem; background-color: rgba(0, 0, 0, 0.2); border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.3);">'
                    # Large color marker square - same color as bounding box annotation
                    '<div style="width: 36px; height: 36px; background-color: ' + class_color + '; border: 3px solid #FFFFFF; border-radius: 8px; flex-shrink: 0; box-shadow: 0 4px 10px rgba(0,0,0,0.5), inset 0 1px 2px rgba(255,255,255,0.3); display: inline-block;"></div>'
                    # Class name with color accent
                    '<div style="flex: 1;">'
                    '<p style="color: ' + class_color + ' !important; font-family: -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, sans-serif; font-size: 1.4rem; font-weight: 800; margin: 0 0 0.2rem 0; text-transform: uppercase; letter-spacing: 1px; text-shadow: 1px 1px 2px rgba(0,0,0,0.5);">'
                    f'{class_display}'
                    '</p>'
                    '<p style="color: #E8E8E8 !important; font-family: -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, sans-serif; font-size: 1rem; font-weight: 500; margin: 0;">'
                    f'{count} detection{"s" if count > 1 else ""} found'
                    '</p>'
                    '</div>'
                    '</div>'
                )
            
            # Simple compact analysis box
            analysis_html = (
                '<div class="analysis-box" style="background-color: #8B7355 !important; background: #8B7355 !important; border: 2px solid #F4D03F !important; padding: 1rem 1.5rem !important; margin: 1.5rem 0 !important; border-radius: 6px !important; box-sizing: border-box !important; display: block !important;">'
                '<h2 style="color: #F4D03F !important; font-family: -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, sans-serif !important; font-size: 2.5rem !important; font-weight: bold !important; margin: 0 0 1rem 0 !important; text-transform: uppercase !important; letter-spacing: 1px !important;">'
                'Detected Classes'
                '</h2>'
                f'{classes_html_content}'
                '</div>'
            )
            st.markdown(analysis_html, unsafe_allow_html=True)
    

if __name__ == "__main__":
    main()

