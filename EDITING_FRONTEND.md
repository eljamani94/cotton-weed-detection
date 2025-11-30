# 🎨 Editing the Frontend - Easy Guide

## ✅ Good News: It's Very Easy!

The frontend is just **one main file**: `app/main.py` (~200 lines)
- Easy to understand
- Easy to modify
- No complex frameworks
- Changes take effect immediately

## 📁 Frontend Structure:

```
app/
├── main.py    # Main Streamlit app (THIS IS WHAT YOU EDIT)
└── utils.py   # Helper functions (rarely need to change)
```

## 🎨 What You Can Easily Change:

### 1. **Page Title & Icon:**
```python
st.set_page_config(
    page_title="Your Custom Title",  # Change this
    page_icon="🌱",                   # Change emoji
    layout="wide"                     # or "centered"
)
```

### 2. **Colors & Styling:**
- Use Streamlit's built-in components
- Add custom CSS if needed
- Change button colors, text styles, etc.

### 3. **Layout:**
- Add/remove columns
- Change sidebar content
- Rearrange sections
- Add new sections

### 4. **Features:**
- Add new buttons
- Change input methods
- Add charts/graphs
- Add statistics
- Change how results are displayed

## 🚀 How to Edit:

### Step 1: Edit Locally

1. **Open `app/main.py`** in your editor
2. **Make your changes**
3. **Test locally:**
   ```powershell
   .\scripts\start_api.bat      # Terminal 1
   .\scripts\start_app.bat       # Terminal 2
   ```
4. **See changes immediately** at http://localhost:8501

### Step 2: Update Cloud (After Testing)

Once you're happy with changes:

1. **Rebuild Docker image:**
   ```powershell
   docker build -f docker/Dockerfile.app -t gcr.io/cotton-weed-detection-app/app:latest .
   ```

2. **Push to Google Cloud:**
   ```powershell
   docker push gcr.io/cotton-weed-detection-app/app:latest
   ```

3. **Update on VM:**
   ```powershell
   # SSH into VM
   gcloud compute ssh cotton-weed-vm --zone=us-central1-a
   
   # Pull new image
   docker pull gcr.io/cotton-weed-detection-app/app:latest
   
   # Restart container
   docker-compose down
   docker-compose up -d
   ```

## 💡 Common Customizations:

### Change Page Title:
```python
st.title("🌱 Your New Title Here")
```

### Change Layout:
```python
# Instead of 2 columns, use 3
col1, col2, col3 = st.columns(3)
```

### Add Custom CSS:
```python
st.markdown("""
<style>
    .main {
        background-color: #f0f2f6;
    }
    h1 {
        color: #1f77b4;
    }
</style>
""", unsafe_allow_html=True)
```

### Change Button Style:
```python
st.button("Your Button", type="primary")  # or "secondary"
```

### Add More Sections:
```python
st.header("📊 Statistics")
st.metric("Label", "Value")

st.header("📈 Charts")
st.bar_chart(data)
```

## 🎯 Quick Edit Workflow:

1. **Edit `app/main.py`** locally
2. **Test** at http://localhost:8501
3. **Iterate** until you're happy
4. **Rebuild & push** to cloud
5. **Done!** ✅

## 📝 Example: Simple Changes

### Change the Title:
```python
# Line 75 - Change this:
st.title("🌱 Cotton Weed Detection System")

# To:
st.title("🌾 Smart Cotton Field Analyzer")
```

### Change Button Text:
```python
# Line 106 - Change this:
if st.button("🔍 Detect Weeds", ...):

# To:
if st.button("🚀 Analyze Image", ...):
```

### Add a Welcome Message:
```python
# After line 76, add:
st.markdown("### Welcome to the Cotton Weed Detection System!")
st.markdown("Upload an image or use your camera to detect weeds in cotton fields.")
```

## ⚡ No Need to Redo Everything!

- ✅ Just edit `app/main.py`
- ✅ Test locally
- ✅ Push to cloud when ready
- ✅ That's it!

## 🔄 Update Workflow Summary:

```
Edit app/main.py
    ↓
Test locally (http://localhost:8501)
    ↓
Happy with changes?
    ↓
Rebuild Docker image
    ↓
Push to Google Cloud
    ↓
Update VM containers
    ↓
Done! ✅
```

---

**Bottom Line:** Editing the frontend is **very easy**! Just edit `app/main.py`, test locally, then push to cloud. No need to redo anything! 🎨

