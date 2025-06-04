class Location {
  final int id;
  final String locationName;
  
  Location({
    required this.id,
    required this.locationName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['locationId'],
      locationName: json['locationName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationId': id,
      'locationName': locationName,
    };
  }
}
