import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_drop/core/models/place_model.dart';

class LocationService {
  Future<
    List<
      PlaceModel
    >
  >
  searchPlaces(
    String input,
  ) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=$input"
        "&components=country:in"
        "&key=AIzaSyC5bWIlHbl37Ul0UrvGU88tHhcsWD98FZU";

    final response = await http.get(
      Uri.parse(
        url,
      ),
    );

    final data = jsonDecode(
      response.body,
    );

    final predictions =
        data["predictions"]
            as List;

    return predictions.map(
      (
        p,
      ) {
        return PlaceModel(
          id: p["place_id"],
          name: p["structured_formatting"]["main_text"],
          address:
              p["structured_formatting"]["secondary_text"] ??
              "",
        );
      },
    ).toList();
  }

  Future<
    Map<
      String,
      double
    >
  >
  getPlaceDetails(
    String placeId,
  ) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json"
        "?place_id=$placeId"
        "&key=kkoAIzaSyC5bWIlHbl37Ul0UrvGU88tHhcsWD98FZU";

    final response = await http.get(
      Uri.parse(
        url,
      ),
    );
    print(
      "GOOGLE API RESPONSE: ${response.body}",
    );

    final data = jsonDecode(
      response.body,
    );

    final location = data["result"]["geometry"]["location"];

    return {
      "lat": location["lat"],
      "lng": location["lng"],
    };
  }
}
