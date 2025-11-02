// tow_provider_model.dart
class TowProvider {
  final String id;
  final String driverName;
  final String email;
  final String truckNumber;
  final String truckType;
  final String serviceLocation;
  final double distance;
  final double rating;
  final int totalJobs;
  final bool isAvailable;
  final double latitude;
  final double longitude;
  final bool isOnline;

  TowProvider({
    required this.id,
    required this.driverName,
    required this.email,
    required this.truckNumber,
    required this.truckType,
    required this.serviceLocation,
    required this.distance,
    required this.rating,
    required this.totalJobs,
    required this.isAvailable,
    required this.latitude,
    required this.longitude,
    required this.isOnline,
  });

  get phone => null;

  get reviews => null;
}