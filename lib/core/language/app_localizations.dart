import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  
  AppLocalizations(this.locale);
  final Locale locale;
  
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common Strings
      'welcome': 'Welcome',
      'dashboard': 'Dashboard',
      'services': 'Services',
      'history': 'History',
      'profile': 'Profile',
      'logout': 'Logout',
      'settings': 'Settings',
      'save': 'Save',
      'cancel': 'Cancel',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'location': 'Location',
      'status': 'Status',
      'view_details': 'View Details',
      'open_settings': 'Open Settings',
      'name': 'Name',
      'email': 'Email',
      'phone': 'Phone',
      'address': 'Address',
      'vehicle': 'Vehicle',
      'submit': 'Submit',
      'request': 'Request',
      'details': 'Details',
      'edit': 'Edit',
      'delete': 'Delete',
      'confirm': 'Confirm',
      
      // Vehicle Owner Dashboard
      'always_here_to_help': 'Always here to help',
      'welcome_back': 'Welcome back',
      'your_plan_active': 'Your plan is active',
      'reward_points': 'Reward Points',
      'next_service': 'Next Service',
      'current_location': 'Current Location',
      'fetching_location': 'Fetching location...',
      'refresh_location': 'Refresh Location',
      'garage_service': 'Garage Service',
      'insurance': 'Insurance',
      'tow_service': 'Tow Service',
      'emergency_services': 'Emergency Services',
      'vehicle_towing': 'Vehicle towing',
      'mechanic_repair': 'Mechanic & repair',
      'no_active_insurance': 'No Active Insurance',
      'get_vehicle_insured': 'Get your vehicle insured today',
      'get_insurance': 'Get Insurance',
      'services_used': 'Services Used',
      'this_month': 'This month',
      'savings': 'Savings',
      'total': 'Total',
      'all_services': 'All Services',
      'location_permission_required': 'Location Permission Required',
      'location_permission_message': 'This app needs location permission to show nearby services. Please enable location permissions in app settings.',
      'wait_for_location': 'Please wait for location to load',
      'logout_confirmation': 'Logout Confirmation',
      'logout_confirm_message': 'Are you sure you want to logout?',
      'logging_out': 'Logging out...',
      'logout_failed': 'Logout failed. Please try again.',
      
      // Form Fields
      'full_name': 'Full Name',
      'phone_number': 'Phone Number',
      'vehicle_number': 'Vehicle Number',
      'vehicle_model': 'Vehicle Model',
      'issue_description': 'Issue Description',
      'service_type': 'Service Type',
      'pickup_location': 'Pickup Location',
      'destination': 'Destination',
      'urgency_level': 'Urgency Level',
      'additional_notes': 'Additional Notes',
      
      // Profile Details
      'personal_info': 'Personal Information',
      'vehicle_info': 'Vehicle Information',
      'contact_info': 'Contact Information',
      'member_since': 'Member Since',
      'emergency_contacts': 'Emergency Contacts',
      'preferred_services': 'Preferred Services',
      'payment_methods': 'Payment Methods',
      'service_history': 'Service History',
      'active_requests': 'Active Requests',
      'completed_services': 'Completed Services',
      
      // Request Forms
      'new_request': 'New Request',
      'request_details': 'Request Details',
      'service_details': 'Service Details',
      'customer_info': 'Customer Information',
      'service_location': 'Service Location',
      'estimated_cost': 'Estimated Cost',
      'service_time': 'Service Time',
      'assign_provider': 'Assign Provider',
      'track_request': 'Track Request',
      'request_status': 'Request Status',
      'pending': 'Pending',
      'accepted': 'Accepted',
      'in_progress': 'In Progress',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
    },
    'es': {
      'welcome': 'Bienvenido',
      'dashboard': 'Tablero',
      'services': 'Servicios',
      'history': 'Historial',
      'profile': 'Perfil',
      'logout': 'Cerrar sesión',
      'cancel': 'Cancelar',
      'welcome_back': 'Bienvenido de nuevo',
      'current_location': 'Ubicación actual',
      'refresh_location': 'Actualizar ubicación',
      'garage_service': 'Servicio de taller',
      'insurance': 'Seguro',
      'tow_service': 'Servicio de grúa',
      'name': 'Nombre',
      'email': 'Correo electrónico',
      'phone': 'Teléfono',
      'vehicle': 'Vehículo',
      'submit': 'Enviar',
      'full_name': 'Nombre completo',
      'phone_number': 'Número de teléfono',
      'vehicle_number': 'Número de vehículo',
    },
    'hi': {
      'welcome': 'स्वागत है',
      'dashboard': 'डैशबोर्ड',
      'services': 'सेवाएं',
      'history': 'इतिहास',
      'profile': 'प्रोफाइल',
      'logout': 'लॉग आउट',
      'cancel': 'रद्द करें',
      'welcome_back': 'वापसी पर स्वागत है',
      'current_location': 'वर्तमान स्थान',
      'refresh_location': 'स्थान ताज़ा करें',
      'garage_service': 'गैराज सेवा',
      'insurance': 'बीमा',
      'tow_service': 'टो सेवा',
      'name': 'नाम',
      'email': 'ईमेल',
      'phone': 'फोन',
      'vehicle': 'वाहन',
      'submit': 'जमा करें',
      'full_name': 'पूरा नाम',
      'phone_number': 'फोन नंबर',
      'vehicle_number': 'वाहन नंबर',
    },
    'fr': {
      'welcome': 'Bienvenue',
      'dashboard': 'Tableau de bord',
      'services': 'Services',
      'history': 'Historique',
      'profile': 'Profil',
      'logout': 'Se déconnecter',
      'cancel': 'Annuler',
      'welcome_back': 'Bon retour',
      'current_location': 'Localisation actuelle',
      'refresh_location': 'Actualiser la localisation',
      'garage_service': 'Service de garage',
      'insurance': 'Assurance',
      'tow_service': 'Service de remorquage',
      'name': 'Nom',
      'email': 'E-mail',
      'phone': 'Téléphone',
      'vehicle': 'Véhicule',
      'submit': 'Soumettre',
      'full_name': 'Nom complet',
      'phone_number': 'Numéro de téléphone',
      'vehicle_number': 'Numéro de véhicule',
    },
  };
  
  String? translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
  
  // Getters for common strings
  String get welcome => translate('welcome')!;
  String get dashboard => translate('dashboard')!;
  String get services => translate('services')!;
  String get history => translate('history')!;
  String get profile => translate('profile')!;
  String get logout => translate('logout')!;
  String get cancel => translate('cancel')!;
  String get welcomeBack => translate('welcome_back')!;
  String get currentLocation => translate('current_location')!;
  String get name => translate('name')!;
  String get email => translate('email')!;
  String get phone => translate('phone')!;
  String get vehicle => translate('vehicle')!;
  String get submit => translate('submit')!;
  String get fullName => translate('full_name')!;
  String get phoneNumber => translate('phone_number')!;
  String get vehicleNumber => translate('vehicle_number')!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es', 'hi', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}