class PlaceModel {
  final String id;
  final String name;
  final String address;
  final double? lat;
  final double? lng;

  PlaceModel({
    required this.id,
    required this.name,
    required this.address,
    this.lat,
    this.lng,
  });

  factory PlaceModel.fromJson(
    Map<
      String,
      dynamic
    >
    json,
  ) {
    return PlaceModel(
      id: json["place_id"],
      name: json["structured_formatting"]["main_text"],
      address:
          json["structured_formatting"]["secondary_text"] ??
          "",
    );
  }

  PlaceModel copyWith({
    double? lat,
    double? lng,
  }) {
    return PlaceModel(
      id: id,
      name: name,
      address: address,
      lat:
          lat ??
          this.lat,
      lng:
          lng ??
          this.lng,
    );
  }
}
