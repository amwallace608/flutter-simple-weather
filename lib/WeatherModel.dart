class WeatherModel {
  //weather data from API
  final temp;
  final pressure;
  final humidity;
  final tempMax;
  final tempMin;
  final description;

  //convert from kelvin to fahrenheit
  double get getTemp => (((temp - 273.15) * 9) / 5) + 32;
  double get getMaxTemp => (((tempMax - 273.15) * 9) / 5) + 32;
  double get getMinTemp => (((tempMin - 273.15) * 9) / 5) + 32;

  //constructor
  WeatherModel(this.temp, this.pressure, this.humidity, this.tempMax,
      this.tempMin, this.description);

  //factory method to convert JSON map form into WeatherModel
  factory WeatherModel.fromJson(
      Map<String, dynamic> jsonMain, Map<String, dynamic> jsonWeather) {
    //return WeatherModel with data from decoded JSON response
    return WeatherModel(
        jsonMain["temp"],
        jsonMain["pressure"],
        jsonMain["humidity"],
        jsonMain["temp_max"],
        jsonMain["temp_min"],
        jsonWeather["main"]);
  }
}
