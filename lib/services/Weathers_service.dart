import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/Weather.dart';
import 'package:http/http.dart' as http;

class WeatherService { 
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  WeatherService(this.apiKey);
  Future<Weather> getWeather(String city) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$city&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  Future<String?> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemarks[0].locality;
    return city;
  }
}
