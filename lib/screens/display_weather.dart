import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:dynamic_weather_icons/dynamic_weather_icons.dart';
import 'package:weather_app/screens/display_forecast.dart';

class DisplayWeather extends StatefulWidget {

  DisplayWeather({Key? key, required this.weather}) : super(key: key);
  final Weather weather;

  @override
  _DisplayWeatherState createState() => _DisplayWeatherState();
}

class _DisplayWeatherState extends State<DisplayWeather> {


  @override
  Widget build(BuildContext context) {
    // split the sunrise and sunset time into two separate strings

    final sunrise = DateTime.parse(widget.weather.sunrise.toString());
    final sunset = DateTime.parse(widget.weather.sunset.toString());


    final format = DateFormat('HH:mm a');
    final sunriseTime = format.format(sunrise);
    final sunsetTime = format.format(sunset);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network('http://openweathermap.org/img/wn/${widget.weather
              .weatherIcon}@4x.png'),
          SizedBox(
            height: 60,
            child: Card(
              //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(WeatherIcon.getIcon('wi-thermometer'), size: 30,),
                    Text(
                      '${widget.weather.temperature?.celsius?.round()}°C',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
            ),
          ),
          SizedBox(
            height: 60,
            child: Card(
              //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info, size: 30, color: Colors.teal,),
                    Text(
                      '${widget.weather.weatherDescription?.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
            ),
          ),
          SizedBox(
            height: 60,
            child: Card(
              //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(WeatherIcon.getIcon('wi-humidity'), size: 30,),
                    Text(
                      '${widget.weather.humidity?.round()}%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
            ),
          ),

          SizedBox(
            height: 60,
            child: Card(
              //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(WeatherIcon.getIcon('wi-sunrise'), size: 30,),
                    const SizedBox(width: 10,),
                    Text(
                      // format the date to a readable format
                      sunriseTime,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
            ),
          ),

          SizedBox(
            height: 60,
            child: Card(
              //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(WeatherIcon.getIcon('wi-sunset'), size: 30,),
                    SizedBox(width: 10,),
                    Text(
                      // format the date to a readable format
                      sunsetTime,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
            ),
          ),

          SizedBox(
            height: 60,
            child: Card(
              //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_outlined, color: Colors.teal, size: 30,),
                    Text(
                      // format the date to a readable format
                      '${widget.weather.areaName}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
            ),
          ),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherForecast(cityName: widget.weather.areaName,)));
          },
            child: const Text('Check 5 day forecast', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}