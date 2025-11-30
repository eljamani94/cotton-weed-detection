# 💳 Google Cloud Billing Setup Guide

## Why Billing is Required

Google Cloud requires billing to be enabled even for free tier services. This is because:
- Some services have usage limits even on free tier
- It prevents abuse
- You still get $300 free credit that's used first!

## ✅ Step-by-Step Billing Setup

### Step 1: Access Billing Page

1. Go to: https://console.cloud.google.com/billing
2. Or navigate: Google Cloud Console → Billing

### Step 2: Create or Link Billing Account

**If you don't have a billing account:**

1. Click **"Create billing account"**
2. Fill in:
   - **Account name:** `Cotton Weed Detection` (or any name)
   - **Country:** Select your country
   - **Currency:** Usually auto-selected
3. Click **"Continue"**
4. Enter payment information:
   - Credit card or debit card
   - Billing address
5. Click **"Submit and enable billing"**

**If you already have a billing account:**

1. Click **"Link a billing account"**
2. Select your existing billing account
3. Click **"Set account"**

### Step 3: Link Billing to Your Project

1. After creating/linking billing account, you'll see a list of projects
2. Find your project: `cotton-weed-detection` (or your project name)
3. Click **"Set account"** next to your project
4. Confirm the link

### Step 4: Verify Billing is Enabled

**Using gcloud CLI:**
```powershell
gcloud billing projects describe cotton-weed-detection
```

You should see output like:
```
billingAccountName: billingAccounts/01XXXX-XXXXXX-XXXXXX
billingEnabled: true
```

**Using Web Console:**
- Go to: https://console.cloud.google.com/billing
- Your project should show "Linked" status

## 💰 Understanding the $300 Free Trial

### What You Get:
- **$300 free credit** valid for 90 days
- Credit is used **automatically** before your payment method is charged
- You'll get email alerts at:
  - 50% credit remaining
  - 90% credit remaining
  - 100% credit used

### What Happens After Free Trial:
- You can continue using services (will charge your card)
- Or you can disable billing and stop services
- **You won't be charged automatically** - you control when to use paid services

### Cost Estimates for This Project:
- **VM (e2-medium, 24/7):** ~$30-40/month
- **Storage (30GB):** ~$1/month
- **Network:** First 1GB free, then ~$0.12/GB

**With $300 credit, you can run this project for ~7-9 months!**

## 🛡️ Safety Tips

### 1. Set Up Billing Alerts:
1. Go to: https://console.cloud.google.com/billing
2. Click on your billing account
3. Go to "Budgets & alerts"
4. Create budget:
   - Amount: $50 (or your preference)
   - Alert at: 50%, 90%, 100%

### 2. Monitor Usage:
- Check regularly: https://console.cloud.google.com/billing
- View current charges
- See what services are using credit

### 3. Stop Services When Not Needed:
```powershell
# Stop VM to save costs
gcloud compute instances stop cotton-weed-vm --zone=us-central1-a
```

When stopped, you only pay for storage (~$1/month).

## ❓ Common Questions

### Q: Will I be charged immediately?
**A:** No! The $300 free credit is used first. You'll only be charged after the credit is exhausted.

### Q: What if I don't want to pay after free trial?
**A:** You can:
- Stop all services
- Disable billing
- Delete the project
- No charges will occur

### Q: Can I remove my credit card?
**A:** Yes, but you'll need to disable billing first. Some services require billing to be enabled.

### Q: What if I exceed $300?
**A:** You'll get email alerts. You can:
- Stop services immediately
- Set up spending limits
- Monitor usage closely

## ✅ After Billing is Enabled

Once billing is linked, you can continue with the deployment:

```powershell
# Now these commands will work:
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

## 🚨 Troubleshooting

### Error: "Billing account not found"
- Make sure billing account is created
- Verify it's linked to your project
- Check project ID is correct

### Error: "Billing account is closed"
- Your billing account might be suspended
- Check payment method is valid
- Contact Google Cloud support if needed

### Can't enable APIs:
- Wait 1-2 minutes after linking billing
- Refresh the page
- Try the command again

---

**Ready?** After billing is enabled, go back to `GCP_DEPLOYMENT_STEPS.md` and continue with Step 2 (enabling APIs).

