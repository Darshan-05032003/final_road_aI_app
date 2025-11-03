# 🧪 Payment Feature - Quick Testing Guide

## 📋 Prerequisites Checklist

- [ ] UPI app installed (PhonePe/Google Pay/Paytm/BHIM)
- [ ] UPI ID configured in UPI app
- [ ] Vehicle Owner test account ready
- [ ] Garage/Tow Provider test account ready
- [ ] Active internet connection

---

## 🔄 Complete Payment Flow

```
1. Vehicle Owner → Create Service Request
   ↓
2. Provider → Accept Request (pending → confirmed)
   ↓
3. Provider → Complete Service
   ├─ Enter Amount: ₹500
   ├─ Enter UPI ID: provider@paytm
   └─ Click "Mark Complete"
   ↓
4. System Updates:
   ├─ status: "completed"
   ├─ paymentStatus: "pending"
   ├─ serviceAmount: ₹500
   └─ Notification sent to customer
   ↓
5. Customer → Opens Completed Request
   ↓
6. Customer → Clicks "Pay Now" Button
   ↓
7. Payment Options Screen Shows:
   ├─ Service Amount: ₹500.00
   ├─ GST (18%): ₹90.00
   └─ Total: ₹590.00
   ↓
8. Customer → Selects "UPI"
   ↓
9. Customer → Chooses UPI App (PhonePe/Google Pay/etc.)
   ↓
10. App Redirects to UPI App
    ↓
11. Customer → Enters UPI PIN & Confirms
    ↓
12. Payment Result:
    ├─ ✅ SUCCESS: Status → "paid", Transaction saved
    ├─ ❌ FAILED: Shows error, can retry
    └─ 🚫 CANCELLED: Payment cancelled message
```

---

## ✅ Testing Steps

### **As Provider:**
1. Login as Garage/Tow Provider
2. Go to **Bookings → Service Requests**
3. Find a request and click **"Confirm"**
4. Click **"Mark as Completed"** / **"Complete"**
5. Enter:
   - **Amount**: `500`
   - **UPI ID**: Your test UPI ID
   - **Notes**: Optional
6. Click **"Mark Complete"**

### **As Customer:**
1. Login as Vehicle Owner
2. Go to **Current Services** or **History**
3. Find completed service with **"Pay Now"** button
4. Click **"Pay Now"**
5. Review payment summary
6. Select **"UPI"**
7. Choose UPI app (PhonePe/Google Pay/etc.)
8. Complete payment in UPI app
9. Verify success screen appears
10. Check payment status updated to "paid"

---

## 🔍 Where to Find Payment Button

The **"Pay Now"** button appears in:

1. **Current Service Details Screen**
   - Open a completed service request
   - Button shows when: `status = completed` AND `paymentStatus != paid`

2. **History Screen**
   - View past services
   - Completed services show payment button

---

## 📱 Testing on Different Scenarios

### **Scenario 1: Successful Payment**
1. Complete all steps above
2. ✅ **Expected**: Payment success screen, status updated to "paid"

### **Scenario 2: Payment Cancelled**
1. Go to payment step
2. Cancel payment in UPI app
3. ✅ **Expected**: Returns to app, shows "Payment cancelled", status remains "pending"

### **Scenario 3: Payment Failed**
1. Go to payment step
2. Let payment fail (wrong PIN, insufficient balance, etc.)
3. ✅ **Expected**: Shows error message, can retry payment

---

## 🔍 Verify Payment in Firestore

1. Go to Firebase Console
2. Navigate to **Firestore Database**
3. Check collection: `payments`
   - Find transaction with your `requestId`
   - Verify `paymentStatus = "paid"`
4. Check collection: `owner/{email}/garagerequest/{requestId}`
   - Verify `paymentStatus = "paid"`
   - Verify `paymentTransactionId` exists

---

## 🛠️ Troubleshooting

### **Issue: Payment Button Not Visible**
- ✅ Check: Request status = `completed`
- ✅ Check: Payment status ≠ `paid`
- ✅ Check: `serviceAmount` > 0
- ✅ Check: `providerUpiId` is set

### **Issue: UPI App Not Opening**
- ✅ Check: UPI app is installed
- ✅ Check: UPI app has active account
- ✅ Try: Select "Any UPI App" option

### **Issue: Payment Successful But Status Not Updated**
- ✅ Check: Internet connection
- ✅ Check: Firestore permissions
- ✅ Check: Firebase Console for errors

---

## 💡 Important Notes

- **GST Calculation**: 18% automatically added to service amount
- **UPI Apps**: Works with PhonePe, Google Pay, Paytm, BHIM
- **Transaction Tracking**: All payments saved in Firestore
- **Real Payment**: Uses actual UPI apps (production mode)

---

## 📊 Payment Details Saved

When payment is successful, system saves:
- ✅ Transaction ID
- ✅ UPI Transaction ID
- ✅ Payment Amount
- ✅ Tax Amount
- ✅ Total Amount
- ✅ Payment Method
- ✅ Payment Timestamp
- ✅ Payment Status: "paid"

---

**Ready to test!** 🚀

