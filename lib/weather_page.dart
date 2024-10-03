import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherPageState();

}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherServices = WeatherServices('dff8a2d6228867670b804fe5debbfa5b');
  Weather?_weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherServices.getCurrentCity();
    //get weather for city
    try {
      final weather = await _weatherServices.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //any error
    catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; //default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case'fog':
        return 'assets/cloud2.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain2.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init State
  @override
  void initState() {
    super.initState();
    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "Loading City......"),
            //animations
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            //temperature
            Text('${_weather?.temperature.round()} °C'),
            //weather condition
            Text(_weather?.mainCondition ?? "")
          ],
        ),
      ),
    );
  }
}