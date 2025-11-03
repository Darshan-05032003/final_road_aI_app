# UPI ID Registration Update

## Summary
Added UPI ID field to provider registration forms so that providers can enter their UPI ID during registration. This UPI ID is then automatically pre-filled when they complete a service, making the payment process smoother.

## Changes Made

### 1. Garage Registration (`lib/Login/GarageRegister.dart`)
- **Added**: `_upiIdController` TextEditingController for UPI ID input
- **Added**: UPI ID text field in the registration form (placed after address field, before services selection)
- **Added**: UPI ID validation (format: `username@payername`)
- **Updated**: `_saveGarageProfile()` to save `upiId` to Firestore in `garages` collection
- **Updated**: Form validation to require UPI ID
- **Updated**: Dispose method to clean up UPI ID controller

**Firestore Structure**:
```json
{
  "garages/{email}": {
    "garageName": "...",
    "ownerName": "...",
    "email": "...",
    "phone": "...",
    "upiId": "yourname@paytm",  // ← NEW FIELD
    ...
  }
}
```

### 2. Tow Provider Registration (`lib/Login/ToeProviderRegister.dart`)
- **Added**: `_upiIdController` TextEditingController for UPI ID input
- **Added**: UPI ID text field in the registration form (placed after location field)
- **Added**: UPI ID validation with regex pattern matching
- **Updated**: Registration method to validate and save `upiId` to Firestore
- **Updated**: Saves UPI ID to both:
  - `tow_providers/{email}` collection
  - `tow/{email}/profile/provider_details` collection (for backward compatibility)
- **Updated**: Form validation to require UPI ID
- **Updated**: Dispose method to clean up UPI ID controller

**Firestore Structure**:
```json
{
  "tow_providers/{email}": {
    "driverName": "...",
    "email": "...",
    "upiId": "yourname@paytm",  // ← NEW FIELD
    ...
  },
  "tow/{email}/profile/provider_details": {
    "driverName": "...",
    "email": "...",
    "upiId": "yourname@paytm",  // ← NEW FIELD
    ...
  }
}
```

### 3. Garage Service Completion Dialog (`lib/garage/garage_service_providerscreen.dart`)
- **Updated**: `_showCompleteServiceDialog()` to automatically load saved UPI ID from provider profile
- **Updated**: UPI ID field now shows:
  - Pre-filled value from profile (if available)
  - Green checkmark icon when pre-filled
  - Helper text indicating it's pre-filled from profile
  - Still editable in case provider wants to use a different UPI ID temporarily

**Behavior**:
- Loads UPI ID from `garages/{email}` collection on dialog open
- Pre-fills the field automatically
- Allows editing if provider wants to change it
- Updates profile with new UPI ID if changed during completion

### 4. Tow Provider Service Completion Dialog (`lib/ToeProvider/requestScreen.dart`)
- **Updated**: `_showCompleteServiceDialog()` to automatically load saved UPI ID from provider profile
- **Updated**: Checks multiple collections for UPI ID:
  1. `tow/{email}/profile/provider_details` (first)
  2. `tow_providers/{email}` (fallback)
- **Updated**: UPI ID field shows same visual indicators as garage provider

**Behavior**:
- Checks both possible locations for saved UPI ID
- Pre-fills the field automatically
- Allows editing if provider wants to change it
- Updates profile with new UPI ID if changed during completion

## UPI ID Validation
- **Format**: `username@payername`
- **Regex Pattern**: `^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$`
- **Examples**:
  - ✅ `john@paytm`
  - ✅ `john.doe@ybl`
  - ✅ `john-doe@okaxis`
  - ❌ `john@` (invalid)
  - ❌ `@paytm` (invalid)
  - ❌ `john paytm` (invalid)

## User Experience Flow

### Registration Flow:
1. Provider fills registration form
2. Provider enters UPI ID (required field)
3. System validates UPI ID format
4. UPI ID saved to Firestore profile

### Service Completion Flow:
1. Provider marks service as "Complete"
2. Dialog opens with:
   - Service amount field (empty)
   - UPI ID field (pre-filled from profile if available)
   - Service notes field (optional)
3. Provider can:
   - Edit UPI ID if needed
   - Enter service amount
   - Add optional notes
4. On completion:
   - UPI ID saved to service request
   - If UPI ID was changed, profile is updated
   - Customer receives notification with payment details

### Payment Flow:
1. Customer receives notification: "Service Completed - Payment Pending 💰"
2. Customer sees service request with:
   - Service amount
   - Provider UPI ID
   - "Pay Now" button
3. Customer clicks "Pay Now"
4. Payment options screen opens with UPI apps
5. Customer selects UPI app and completes payment
6. Payment status updated in Firestore

## Testing Instructions

### Test Registration with UPI ID:
1. **Garage Provider**:
   - Open Garage Registration
   - Fill all fields including UPI ID (e.g., `testgarage@paytm`)
   - Verify validation accepts valid UPI ID format
   - Verify validation rejects invalid formats
   - Complete registration
   - Check Firestore: `garages/{email}` should contain `upiId` field

2. **Tow Provider**:
   - Open Tow Provider Registration
   - Fill all fields including UPI ID (e.g., `testtow@ybl`)
   - Verify validation accepts valid UPI ID format
   - Verify validation rejects invalid formats
   - Complete registration
   - Check Firestore:
     - `tow_providers/{email}` should contain `upiId` field
     - `tow/{email}/profile/provider_details` should contain `upiId` field

### Test Service Completion with Pre-filled UPI ID:
1. **Garage Provider**:
   - Login as garage provider (registered with UPI ID)
   - Accept a service request
   - Mark service as "Complete"
   - Verify UPI ID field is pre-filled with saved UPI ID
   - Verify green checkmark icon appears
   - Verify helper text indicates it's pre-filled
   - Verify UPI ID is editable
   - Change UPI ID and complete service
   - Verify profile is updated with new UPI ID

2. **Tow Provider**:
   - Login as tow provider (registered with UPI ID)
   - Accept a tow request
   - Mark request as "Complete"
   - Verify UPI ID field is pre-filled (checks both collections)
   - Verify same visual indicators as garage
   - Test with provider who registered before UPI ID field was added
   - Verify it works even if UPI ID is missing from one collection

### Test Payment Flow:
1. Complete a service as provider (with UPI ID)
2. Login as vehicle owner
3. Check service request shows payment amount and "Pay Now" button
4. Click "Pay Now"
5. Verify payment options screen opens
6. Verify provider UPI ID is shown
7. Test UPI payment (if testing environment supports it)

## Migration Notes

### For Existing Providers:
- Existing providers who registered before this update will not have UPI ID in their profile
- When they complete a service, the UPI ID field will be empty
- They can enter UPI ID during service completion
- The entered UPI ID will be saved to their profile for future use
- Alternatively, they can update their profile manually in Firestore

### Backward Compatibility:
- Service completion dialog still works without saved UPI ID
- Providers can enter UPI ID manually during completion
- System gracefully handles missing UPI ID in profile

## Files Modified
1. `lib/Login/GarageRegister.dart` - Added UPI ID field to registration
2. `lib/Login/ToeProviderRegister.dart` - Added UPI ID field to registration
3. `lib/garage/garage_service_providerscreen.dart` - Auto-load UPI ID in completion dialog
4. `lib/ToeProvider/requestScreen.dart` - Auto-load UPI ID in completion dialog

## Database Schema Updates
- `garages/{email}.upiId` (string) - NEW
- `tow_providers/{email}.upiId` (string) - NEW
- `tow/{email}/profile/provider_details.upiId` (string) - NEW







