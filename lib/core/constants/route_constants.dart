/// Route constants for navigation
class RouteConstants {
  // Authentication Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';

  // Vehicle Owner Routes
  static const String vehicleOwnerDashboard = '/vehicle-owner/dashboard';
  static const String vehicleOwnerServiceRequests = '/vehicle-owner/service-requests';
  static const String vehicleOwnerSpareParts = '/vehicle-owner/spare-parts';
  static const String vehicleOwnerHistory = '/vehicle-owner/history';
  static const String vehicleOwnerProfile = '/vehicle-owner/profile';

  // Garage Routes
  static const String garageDashboard = '/garage/dashboard';
  static const String garageInventory = '/garage/inventory';
  static const String garageBookings = '/garage/bookings';
  static const String garageServiceRequests = '/garage/service-requests';
  static const String garageSalesReports = '/garage/sales-reports';
  static const String garageProfile = '/garage/profile';

  // Tow Provider Routes
  static const String towProviderDashboard = '/tow-provider/dashboard';
  static const String towProviderRequests = '/tow-provider/requests';
  static const String towProviderJobs = '/tow-provider/jobs';
  static const String towProviderProfile = '/tow-provider/profile';

  // Insurance Routes
  static const String insuranceDashboard = '/insurance/dashboard';
  static const String insurancePolicies = '/insurance/policies';
  static const String insuranceClaims = '/insurance/claims';
  static const String insuranceAnalytics = '/insurance/analytics';

  // Admin Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUserManagement = '/admin/user-management';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminLiveMonitoring = '/admin/live-monitoring';
  static const String adminRevenue = '/admin/revenue';

  // AI Features Routes
  static const String aiFeaturesDashboard = '/ai-features';
  static const String aiTravelCompanion = '/ai-features/travel-companion';
  static const String aiEmotionalAI = '/ai-features/emotional-ai';
  static const String aiHazardDetection = '/ai-features/hazard-detection';

  // Shared Routes
  static const String aboutUs = '/about-us';
  static const String chat = '/chat';
  static const String notifications = '/notifications';

  // Private constructor
  RouteConstants._();
}
