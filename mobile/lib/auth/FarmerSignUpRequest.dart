class FarmerSignupRequest {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String farmName;
  final double farmLocationLat;
  final double farmLocationLon;
  final double farmSize;
  final List<CropDto> farmCrops;

  FarmerSignupRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.farmName,
    required this.farmLocationLat,
    required this.farmLocationLon,
    required this.farmSize,
    required this.farmCrops,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'farmName': farmName,
      'farmLocationLat': farmLocationLat,
      'farmLocationLon': farmLocationLon,
      'farmSize': farmSize,
      'farmCrops': farmCrops.map((crop) => crop.toJson()).toList(),
    };
  }
}

class CropDto {
  final String cropName;
  final double area;

  CropDto({
    required this.cropName,
    required this.area,
  });

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'area': area,
    };
  }
}
