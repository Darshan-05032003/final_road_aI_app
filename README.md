# Smart Road AI App 🚗

Hey! This is my Flutter project for a smart road app. It's basically an app that helps people with their cars and stuff.

## What This App Does

So basically this app has a lot of features:
- Vehicle owners can request services from garages
- Tow providers can accept tow requests
- Insurance companies can manage policies
- Garages can manage their inventory
- Admin can see everything

There's also AI features like:
- AI travel companion (chat with AI)
- Emotional voice assistant
- Predictive hazard detection
- AR windshield mode
- Emergency response
- And more!

## Getting Started

### Prerequisites

You need:
- Flutter SDK (I used version 3.9.2)
- Android Studio or VS Code
- Firebase account (for backend)
- Google account (for sign in)

### Installation

1. Clone the repo:
```bash
git clone <repo-url>
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up Firebase:
   - Add your `google-services.json` file in `android/app/`
   - Configure Firebase in the code (I think it's already done)

4. Run the app:
```bash
flutter run
```

## Project Structure

The project is organized like this:
- `lib/` - main code
  - `admin/` - admin features
  - `garage/` - garage features  
  - `Insurance/` - insurance features
  - `ToeProvider/` - tow provider features (yes I know it's spelled "Tow" but I wrote "Toe" by mistake and it's too late to change now 😅)
  - `VehicleOwner/` - vehicle owner features
  - `features/` - AI features
  - `services/` - backend services
  - `screens/` - UI screens
  - `core/` - some core stuff like theme and language
  - `Login/` - login screens

## Features

### For Vehicle Owners
- Request garage services
- Request tow services
- Buy spare parts
- View history
- AI assistant
- Voice assistant

### For Garages
- Manage inventory
- Handle service requests
- Manage bookings
- Sales reports
- Spare parts management

### For Tow Providers
- View incoming requests
- Manage jobs
- Track earnings
- Profile management

### For Insurance Companies
- Manage policies
- Process claims
- View analytics
- Dashboard

### For Admins
- User management
- System monitoring
- Revenue tracking
- Analytics

## Technologies Used

- Flutter (obviously)
- Firebase (for backend)
- Bloc (for state management - I just migrated from Provider)
- Google Sign In
- UPI payment integration
- Location services
- Camera
- Speech to text
- And more packages (check pubspec.yaml)

## Important Notes

⚠️ **Before running:**
- Make sure Firebase is configured properly
- Add your API keys if needed
- Check if all permissions are set in AndroidManifest.xml

⚠️ **Known Issues:**
- Some features might not work perfectly (still working on it)
- The UI might look different on different screen sizes
- Some error handling might be missing (sorry!)
- The code structure is a bit messy in some places (I'm still learning!)

## Screenshots

I don't have screenshots yet but the app looks pretty good! 😊

## Contributing

Feel free to contribute! Just make a pull request and I'll check it out.

## License

Not sure about license yet, but feel free to use it for learning purposes.

## Contact

If you have questions, just open an issue or something.

## Acknowledgments

Thanks to:
- Flutter team for the awesome framework
- Firebase for backend
- All the package developers
- My friends who helped test the app
- Stack Overflow (used it a lot 😅)

---

**Note:** This is still a work in progress, so some features might not be fully implemented yet. But it's getting there! 🚀

P.S. - If you find any bugs, please let me know! I'm still learning 😅

P.P.S. - I'm using Bloc for state management now (just migrated from Provider). It's a bit more complex but seems better for bigger apps.
