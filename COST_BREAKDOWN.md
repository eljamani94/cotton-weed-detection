# 💰 Cost Breakdown - Running for 1 Week

## Your VM Configuration:
- **Machine Type:** e2-medium (2 vCPU, 4GB RAM)
- **Zone:** us-central1-a
- **Disk:** 30GB standard persistent disk
- **Running:** 24/7 for 1 week

## Cost Breakdown:

### 1. Compute (VM Instance):
- **Hourly Rate:** ~$0.0671/hour (e2-medium in us-central1)
- **Per Day:** $0.0671 × 24 hours = **$1.61/day**
- **Per Week:** $1.61 × 7 days = **~$11.27/week**

### 2. Storage (Disk):
- **Monthly Rate:** ~$0.17 per GB per month
- **30GB Disk:** 30 × $0.17 = **$5.10/month**
- **Per Week:** $5.10 ÷ 4.33 weeks = **~$1.18/week**

### 3. Network (Data Transfer):
- **First 1GB:** Free per month
- **After that:** ~$0.12 per GB
- **Estimate:** Minimal for small app usage (~$0-2/week depending on traffic)

## 📊 Total Estimated Cost:

**Per Week:** ~**$12-13 USD**

**Per Month (4 weeks):** ~**$48-52 USD**

## 💵 With Your $300 Free Credit:

- **Weeks of Free Usage:** ~23-25 weeks (about 5-6 months!)
- **Months of Free Usage:** ~5-6 months

## 💡 Cost-Saving Tips:

### Option 1: Stop VM When Not in Use
```powershell
# Stop VM (saves compute costs)
gcloud compute instances stop cotton-weed-vm --zone=us-central1-a
```
- **When stopped:** Only pay for storage (~$1.18/week)
- **Savings:** ~$11/week when stopped

### Option 2: Use Smaller Machine Type
- **e2-small** (2 vCPU, 2GB RAM): ~$0.0335/hour
- **Per week:** ~$5.63/week (saves ~$5.64/week)
- **Trade-off:** Less memory, might be slower

### Option 3: Use Preemptible VM
- **80% cheaper:** ~$0.013/hour
- **Per week:** ~$2.18/week
- **Trade-off:** Can be stopped by Google (not for production)

## 📈 Cost Monitoring:

### Set Up Billing Alerts:
1. Go to: https://console.cloud.google.com/billing
2. Click on your billing account
3. Go to "Budgets & alerts"
4. Create budget:
   - Amount: $50
   - Alert at: 50%, 90%, 100%

### Check Current Usage:
```powershell
# View VM usage
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a
```

## 🎯 Recommendation:

**For Testing/Development:**
- Stop VM when not actively using it
- Start it only when needed
- This way you can stretch your $300 credit to 6+ months

**For Production:**
- Keep it running 24/7
- Monitor usage and costs
- Consider upgrading/downgrading based on actual usage

## 📝 Example Scenarios:

### Scenario 1: Running 24/7 for 1 Week
- **Cost:** ~$12-13
- **Credit Remaining:** ~$287-288

### Scenario 2: Running 8 hours/day (work hours)
- **Cost:** ~$3.76/week (8 hours × 7 days × $0.0671)
- **Credit Remaining:** ~$296-297

### Scenario 3: Running only when testing (2 hours/day)
- **Cost:** ~$0.94/week (2 hours × 7 days × $0.0671)
- **Credit Remaining:** ~$299+

---

**Bottom Line:** Running 24/7 for 1 week costs approximately **$12-13**, which is very reasonable and you have plenty of free credit to cover it!

