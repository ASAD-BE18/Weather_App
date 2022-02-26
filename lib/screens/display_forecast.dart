import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';

class WeatherForecast extends StatefulWidget {
  String? cityName;

  WeatherForecast({
    Key? key,
    this.cityName,
  }) : super(key: key);
  @override
  _WeatherForecastState createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {

  List<Weather>? weathers;

  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Five day forecast for "+widget.cityName!),
      ),
      body: Center(
        child: (weathers == null) ? CircularProgressIndicator() : ListView.builder(
          itemCount: weathers?.length ?? 0,
          itemBuilder: (context, index) {
            // parse the date
            final format = DateFormat('dd/MM/yyyy HH:mm');

            return ListTile(
              leading:  Image.network('http://openweathermap.org/img/wn/${weathers![index].weatherIcon}.png'),
              title: Text(format.format(DateTime.parse(weathers![index].date.toString())).toString()),
              subtitle: Text(weathers![index].weatherDescription.toString()),
              trailing: Text(
                '${weathers![index].temperature?.celsius?.round()}°C',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _fetchForecast() async {
    String key = 'b8f9f8f9f9f9f9f9f9f9f9f9f9f9f9f9'; // replace with your own key
    WeatherFactory weatherFactory = WeatherFactory(key);
    try{
      List<Weather> data = await weatherFactory.fiveDayForecastByCityName(widget.cityName!);
      setState(() {
        weathers = data;
      });
    }catch(e){
      print(e);
    }

    }
}