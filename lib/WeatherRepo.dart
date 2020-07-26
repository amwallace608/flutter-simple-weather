import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:simple_weather/WeatherModel.dart';

//class for calling the API
class WeatherRepo {
  //Future for returning WeatherModel
  Future<WeatherModel> getWeather(String city) async {
    //https://api.openweathermap.org/data/2.5/weather?q=Tigard&APPID=43ea6baaad7663dc17637e22ee6f78f2
    //api url/key
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=43ea6baaad7663dc17637e22ee6f78f2";

    final result = await http.Client().get(url);

    //check status code of result
    if (result.statusCode != 200) {
      //throw exception if not successful
      throw Exception();
    } else {
      //parse response into WeatherModel object and return
      //print(result.body);
      return parseJson(result.body);
    }
  }

  //method to parse weather model data from JSON object response
  WeatherModel parseJson(final response) {
    //decode JSON object
    final decoded = json.decode(response);

    //get 'main' data from API response
    final jsonMain = decoded["main"];
    //print(jsonMain);

    //get 'weather' data from API response (for description)
    final jsonWeather = decoded["weather"];
    //print(jsonWeather[0]);

    //return WeatherModel parsed from JSON
    return WeatherModel.fromJson(jsonMain, jsonWeather[0]);
  }
}
