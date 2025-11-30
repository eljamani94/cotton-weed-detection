# 🔗 Link Billing to Your Project

## Your Project Details:
- **Project ID:** `cotton-weed-detection-app`
- **Project Name:** Cotton Weed Detection
- **Project Number:** 611210145756

## Method 1: Using Google Cloud Console (Easiest)

### Step 1: Go to Billing Page
1. Open: https://console.cloud.google.com/billing
2. Or: https://console.cloud.google.com → Click "Billing" in the left menu

### Step 2: Find Your Project
1. On the billing page, you'll see a section "Projects without a billing account"
2. Look for: **"Cotton Weed Detection"** or **"cotton-weed-detection-app"**
3. Click **"Link"** or **"Set account"** next to it

### Step 3: Select Billing Account
- If you have a billing account: Select it and click "Set account"
- If you don't have one: Click "Create billing account" first

### Alternative: Direct Project Link
1. Go to: https://console.cloud.google.com/billing/projects
2. Find your project in the list
3. Click the three dots (⋮) → "Change billing account"
4. Select your billing account

## Method 2: Using gcloud CLI (Faster)

### Step 1: List Your Billing Accounts
```powershell
gcloud billing accounts list
```

You'll see something like:
```
ACCOUNT_ID            NAME                OPEN
0X0X0X-0X0X0X-0X0X0X  My Billing Account  True
```

### Step 2: Link Billing Account to Project
```powershell
# Replace BILLING_ACCOUNT_ID with the ID from step 1
gcloud billing projects link cotton-weed-detection-app --billing-account=BILLING_ACCOUNT_ID
```

**Example:**
```powershell
gcloud billing projects link cotton-weed-detection-app --billing-account=0X0X0X-0X0X0X-0X0X0X
```

### Step 3: Verify Billing is Linked
```powershell
gcloud billing projects describe cotton-weed-detection-app
```

You should see:
```
billingAccountName: billingAccounts/0X0X0X-0X0X0X-0X0X0X
billingEnabled: true
```

## Method 3: From Project Settings

1. Go to: https://console.cloud.google.com/home/dashboard?project=cotton-weed-detection-app
2. Click the hamburger menu (☰) → "Billing"
3. Click "Link a billing account"
4. Select your billing account
5. Click "Set account"

## 🎯 Quick Direct Links

- **Billing Dashboard:** https://console.cloud.google.com/billing
- **Your Project:** https://console.cloud.google.com/home/dashboard?project=cotton-weed-detection-app
- **Project Settings:** https://console.cloud.google.com/iam-admin/settings?project=cotton-weed-detection-app

## ✅ After Linking Billing

Once billing is linked, you can enable APIs:

```powershell
# Make sure you're using the right project
gcloud config set project cotton-weed-detection-app

# Enable APIs (these should work now)
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

## ❓ Troubleshooting

### Can't see project in billing page:
1. Make sure you're logged into the correct Google account
2. Check project exists: `gcloud projects list`
3. Try refreshing the page
4. Use the direct project link above

### "No billing accounts found":
- You need to create a billing account first
- Go to: https://console.cloud.google.com/billing
- Click "Create billing account"
- Enter payment information

### Still can't find it:
- Try searching for the project ID: `cotton-weed-detection-app`
- Or project number: `611210145756`
- Use the gcloud CLI method instead

