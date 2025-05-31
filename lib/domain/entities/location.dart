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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          locationName == other.locationName;
}
