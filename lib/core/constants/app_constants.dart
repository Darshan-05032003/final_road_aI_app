/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'Smart Road AI';
  static const String appVersion = '1.0.0';
  static const String appPackageName = 'com.smartroad.app';

  // User Roles
  static const String roleVehicleOwner = 'vehicle_owner';
  static const String roleGarage = 'garage';
  static const String roleTowProvider = 'tow_provider';
  static const String roleInsurance = 'insurance';
  static const String roleAdmin = 'admin';

  // Route Names
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeRoleSelection = '/role-selection';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeVehicleOwnerDashboard = '/vehicle-owner/dashboard';
  static const String routeGarageDashboard = '/garage/dashboard';
  static const String routeTowProviderDashboard = '/tow-provider/dashboard';
  static const String routeInsuranceDashboard = '/insurance/dashboard';
  static const String routeAdminDashboard = '/admin/dashboard';
  static const String routeAIFeatures = '/ai-features';

  // Storage Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserEmail = 'user_email';
  static const String keyUserRole = 'user_role';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyOnboardingCompleted = 'onboarding_completed';

  // Firebase Collections
  static const String collectionUsers = 'users';
  static const String collectionVehicleOwners = 'vehicle_owners';
  static const String collectionGarages = 'garages';
  static const String collectionTowProviders = 'tow_providers';
  static const String collectionInsurance = 'insurance_companies';
  static const String collectionAdmins = 'admins';
  static const String collectionServiceRequests = 'service_requests';
  static const String collectionNotifications = 'notifications';

  // API Endpoints (if using REST API)
  static const String apiBaseUrl = 'https://api.smartroad.app/v1';
  static const String apiAuth = '/auth';
  static const String apiUsers = '/users';
  static const String apiServices = '/services';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 15);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorUnauthorized = 'Unauthorized. Please login again.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorServer = 'Server error. Please try again later.';

  // Success Messages
  static const String successLogin = 'Login successful';
  static const String successRegister = 'Registration successful';
  static const String successUpdate = 'Update successful';
  static const String successDelete = 'Delete successful';

  // Private constructor to prevent instantiation
  AppConstants._();
}
