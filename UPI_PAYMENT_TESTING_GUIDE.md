# UPI Payment Functionality Testing Guide

This guide will help you verify that the UPI payment functionality is working correctly in your smart road app.

## Prerequisites

1. **Physical Android Device** (UPI payments work best on real devices)
2. **UPI App Installed** (PhonePe, Google Pay, Paytm, or BHIM)
3. **UPI ID Set Up** (for testing - create test UPI IDs or use real ones)
4. **Firebase Console Access** (to verify data storage)

## Testing Flow Overview

```
1. Provider Registration (with UPI ID)
   ↓
2. Service Request Creation (by Vehicle Owner)
   ↓
3. Provider Accepts Request
   ↓
4. Provider Marks Service as Complete (enters amount & UPI ID)
   ↓
5. Customer Receives Payment Notification
   ↓
6. Customer Clicks "Pay Now"
   ↓
7. UPI App Selection Screen
   ↓
8. UPI Payment Flow
   ↓
9. Payment Status Update
```

---

## Step 1: Test Provider Registration with UPI ID

### For Garage Provider:
1. Open the app and navigate to **Garage Registration**
2. Fill in all required fields:
   - Garage Name
   - Owner Name
   - Email
   - Password
   - Phone Number
   - Location (use GPS)
   - **UPI ID** (e.g., `testgarage@paytm`)
3. Select services offered
4. Click **Register**

**✅ Verification:**
- Registration should complete successfully
- Check Firebase Console → `garages/{email}` collection
- Verify `upiId` field is saved with your UPI ID

**Firebase Console Check:**
```
Collection: garages
Document: {your-email}
Fields:
  - garageName: "..."
  - upiId: "testgarage@paytm"  ← Should be present
  - email: "..."
  - ...
```

### For Tow Provider:
1. Navigate to **Tow Provider Registration**
2. Fill in all fields including:
   - Driver Name
   - Email
   - Password
   - Truck Number
   - Truck Type
   - Location
   - **UPI ID** (e.g., `testtow@ybl`)
3. Click **Register**

**✅ Verification:**
- Check Firebase Console → `tow_providers/{email}` collection
- Verify `upiId` field exists
- Also check `tow/{email}/profile/provider_details` for backward compatibility

---

## Step 2: Test Profile UPI ID Editing

### Garage Provider Profile:
1. Login as garage provider
2. Navigate to **Profile** screen
3. Click **Edit** (pencil icon)
4. Locate **UPI ID** field
5. Change UPI ID (e.g., from `testgarage@paytm` to `newgarage@ybl`)
6. Click **UPDATE PROFILE**

**✅ Verification:**
- Profile should update successfully
- Check Firebase → `garages/{email}` → `upiId` should be updated
- Old UPI ID should be replaced

### Tow Provider Profile:
1. Login as tow provider
2. Navigate to **Profile** screen
3. Click **Edit** icon (top right)
4. Edit form should appear
5. Update **UPI ID** field
6. Click **UPDATE PROFILE**

**✅ Verification:**
- Profile updates successfully
- UPI ID displays in profile header (green color)
- Firebase updated in both `tow_providers` and `tow` collections

---

## Step 3: Test Service Completion with Payment

### Scenario A: Garage Service Completion

1. **Create a Service Request:**
   - Login as Vehicle Owner
   - Create a garage service request
   - Wait for provider to accept

2. **Provider Completes Service:**
   - Login as Garage Provider
   - Navigate to service requests
   - Accept the request
   - Click **"Complete"** button
   - Dialog should appear with:
     - Service Amount field (enter amount, e.g., `500`)
     - **UPI ID field** (should be **pre-filled** from profile)
     - Service Notes (optional)
   - Verify UPI ID shows green checkmark if pre-filled
   - Click **"Mark Complete"**

**✅ Verification:**
- Check Firebase Console → `owner/{owner-email}/garagerequest/{requestId}`
  ```
  Fields to verify:
  - status: "Completed"
  - serviceAmount: 500
  - providerUpiId: "testgarage@paytm"  ← Should match provider's UPI
  - paymentStatus: "pending"
  - completedAt: [timestamp]
  ```
- Owner should receive notification: "Service Completed - Payment Pending 💰"

### Scenario B: Tow Service Completion

1. **Create a Tow Request:**
   - Login as Vehicle Owner
   - Create a tow service request
   - Provider accepts request

2. **Provider Completes Service:**
   - Login as Tow Provider
   - Accept tow request
   - Click **"Complete"** button
   - Enter amount (e.g., `800`)
   - Verify UPI ID is pre-filled
   - Add optional notes
   - Click **"Mark Complete"**

**✅ Verification:**
- Check Firebase → `owner/{owner-email}/towrequest/{requestId}`
  ```
  Fields:
  - status: "completed"
  - serviceAmount: 800
  - providerUpiId: "testtow@ybl"
  - paymentStatus: "pending"
  - completedAt: [timestamp]
  ```
- Owner receives notification

---

## Step 4: Test Payment Initiation (Customer Side)

1. **Login as Vehicle Owner**
2. Navigate to service request history/details
3. Find the completed service request
4. Verify you see:
   - Service amount displayed (e.g., "₹500")
   - **"Pay Now (₹500)"** button (green button with payment icon)
   - Provider UPI ID visible (optional)

5. **Click "Pay Now" button**

**✅ Verification:**
- Payment Options Screen should open
- You should see:
  - Amount to Pay: ₹500
  - For: garage/tow service (Request ID: xxx)
  - To: provider-email (UPI ID: provider@paytm)
  - List of available UPI apps on device

---

## Step 5: Test UPI App Selection & Payment

### On Payment Options Screen:

1. **Verify Available UPI Apps:**
   - Should show list of installed UPI apps
   - Each app should have:
     - App icon
     - App name (PhonePe, Google Pay, Paytm, etc.)
   - If no UPI apps found, should show message

2. **Select a UPI App:**
   - Tap on any UPI app (e.g., PhonePe)
   - UPI app should open automatically
   - Payment details should be pre-filled:
     - Amount: ₹500
     - To: provider@paytm
     - Transaction Note: "Payment for garage service (Request ID: xxx)"

3. **Complete Payment in UPI App:**
   - Enter UPI PIN
   - Confirm payment
   - Wait for payment completion

**✅ Verification Points:**

**Successful Payment:**
- UPI app shows success message
- Returns to app
- Snackbar shows: "Payment successful!"
- Firebase updated:
  - `payments/{transactionId}`:
    - status: "success"
    - upiTransactionId: [from UPI app]
    - paidAt: [timestamp]
  - Service request:
    - paymentStatus: "paid"
    - upiTransactionId: [same as above]
  - Notification sent to provider: "Payment received"

**Failed Payment:**
- UPI app shows failure
- Returns to app
- Snackbar shows: "Payment failed: [reason]"
- Firebase:
  - payment status: "failed"
  - Service request paymentStatus: "pending" (can retry)

**Cancelled Payment:**
- User cancels in UPI app
- Returns to app
- Snackbar shows: "Payment cancelled by user"
- Firebase:
  - payment status: "cancelled"
  - Service request paymentStatus: "pending"

---

## Step 6: Verify Database Updates

### Firestore Collections to Check:

#### 1. Payment Transaction (`payments/{transactionId}`):
```json
{
  "id": "TXN1234567890",
  "requestId": "REQ_xxx",
  "serviceType": "garage", // or "tow"
  "amount": 500,
  "status": "success", // or "pending", "failed", "cancelled"
  "upiTransactionId": "UPI123...",
  "responseCode": "00",
  "approvalRefNo": "APP123...",
  "providerEmail": "provider@example.com",
  "customerEmail": "customer@example.com",
  "providerUpiId": "provider@paytm",
  "timestamp": [timestamp],
  "paidAt": [timestamp],
  "serviceNotes": "..."
}
```

#### 2. Service Request (Owner Collection):
```
owner/{owner-email}/garagerequest/{requestId}
owner/{owner-email}/towrequest/{requestId}
```
```json
{
  "status": "Completed",
  "serviceAmount": 500,
  "providerUpiId": "provider@paytm",
  "paymentStatus": "paid", // or "pending", "failed"
  "paymentTransactionId": "TXN1234567890",
  "upiTransactionId": "UPI123...",
  "completedAt": [timestamp],
  "serviceNotes": "..."
}
```

#### 3. Provider Profile:
```
garages/{provider-email}
tow_providers/{provider-email}
```
- Verify `upiId` field is present and correct

---

## Step 7: Test Edge Cases

### 1. **Provider Without UPI ID:**
- Register provider without UPI ID (skip field)
- Try to complete service
- **Expected:** Validation error: "Please enter your UPI ID"

### 2. **Invalid UPI ID Format:**
- Enter invalid UPI ID (e.g., `invalid`, `@paytm`, `user@`)
- **Expected:** Validation error with format requirements

### 3. **No UPI Apps Installed:**
- On device with no UPI apps
- Click "Pay Now"
- **Expected:** Shows "No UPI apps found on your device"

### 4. **Payment Retry:**
- Fail a payment
- Click "Pay Now" again
- **Expected:** Should allow retry, creates new transaction

### 5. **Multiple Payments (Should Prevent):**
- After successful payment
- Try clicking "Pay Now" again
- **Expected:** Button should be disabled or show "Already Paid"

---

## Debugging Tips

### 1. **Check Logs:**
Run the app with verbose logging:
```bash
flutter run --verbose
```

Look for:
- `UPI Payment Handler` logs
- `Payment Service` logs
- `Firebase` operation logs
- Error messages

### 2. **Firebase Console:**
- Real-time Database → Check notification nodes
- Firestore → Check `payments` collection
- Verify all fields are being saved correctly

### 3. **Common Issues:**

**Issue: UPI apps not showing**
- **Solution:** Ensure UPI apps are installed on device
- Check `upi_india` package permissions in `AndroidManifest.xml`

**Issue: Payment not completing**
- **Solution:** Verify UPI ID is valid and active
- Check if UPI app has necessary permissions

**Issue: Payment status not updating**
- **Solution:** Check internet connection
- Verify Firebase write permissions
- Check console for error logs

**Issue: Pre-filled UPI ID not showing**
- **Solution:** Verify UPI ID is saved in provider profile
- Check Firebase → `garages/{email}` or `tow_providers/{email}`

---

## Quick Test Checklist

- [ ] Provider can register with UPI ID
- [ ] Provider can edit UPI ID in profile
- [ ] UPI ID is saved to Firebase correctly
- [ ] Service completion dialog shows pre-filled UPI ID
- [ ] Service completion saves payment details to Firebase
- [ ] Customer sees "Pay Now" button for completed services
- [ ] Payment options screen shows available UPI apps
- [ ] UPI app opens with correct payment details
- [ ] Successful payment updates Firebase correctly
- [ ] Failed payment shows error message
- [ ] Payment transaction is recorded in `payments` collection
- [ ] Service request `paymentStatus` updates correctly
- [ ] Notifications are sent on payment success

---

## Testing with Real vs Test UPI IDs

### Using Real UPI IDs:
- ✅ Best for final testing
- ✅ Real payment verification
- ⚠️ Requires actual money transfer

### Using Test UPI IDs (for development):
- Create test UPI IDs in UPI apps
- Use small amounts (₹1)
- Verify flow works without large transactions

---

## Testing on Different Devices

1. **Physical Android Device** (Recommended)
   - Best for UPI testing
   - Real UPI apps work properly

2. **Android Emulator**
   - May not have UPI apps
   - Use for UI/flow testing only

3. **iOS** (if supported)
   - UPI may have different behavior
   - Test separately if implementing iOS support

---

## Expected User Experience Flow

1. **Provider:** Registers → Sets UPI ID → Completes service → Gets paid
2. **Customer:** Requests service → Service completed → Pays via UPI → Payment confirmed

---

## Contact Points for Issues

If UPI payment doesn't work:
1. Check `lib/screens/payment/upi_payment_handler.dart` for payment logic
2. Check `lib/services/payment_service.dart` for Firebase updates
3. Verify `upi_india` package version in `pubspec.yaml`
4. Check Android permissions in `AndroidManifest.xml`
5. Review Firebase rules for write permissions

---

## Success Criteria

✅ **UPI Payment is working correctly if:**
- Providers can enter/update UPI ID
- Service completion includes payment details
- Customers can initiate UPI payments
- UPI apps open with correct details
- Payments are recorded in Firebase
- Payment status updates correctly
- Both parties receive appropriate notifications

Good luck with testing! 🚀



