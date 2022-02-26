import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/utils/Location.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/screens/display_weather.dart';
import 'package:weather_app/screens/search_location.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const WeatherApp()
    );
  }
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {

  // create null dictionary with latitudes and longitudes keys
  Map<String, double?> _locationData = {
    'latitude': null,
    'longitude': null,
  };

  var _weatherData;


  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
    fetchLocationAndWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        // add search bar
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              // get the input from the user
              var data = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationSearch(),
                ),
              );
              // if the user has entered a location
              if (data != null) {
                getWeather(byName: true, cityName: data);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: (){
              showAboutDialog(context: context,
                applicationName: 'Weather App',
                applicationVersion: '1.0.0',
                children: <Widget>[
                  Text('This app was created by: '),
                  Text('Asad Majeed',style: TextStyle(fontWeight: FontWeight.bold),),
                  Row(
                    children: <Widget>[
                      Icon(Icons.email),
                      Text('Asad.be18@iba-suk.edu.pk',style: TextStyle(fontWeight: FontWeight.bold),),
              ],
              ),
              ],
              );
            }
          )
        ],
      ),
      body: Center(
        child: (_weatherData != null) ? DisplayWeather(weather: _weatherData,) : CircularProgressIndicator(),
      ),
    );
  }


 getLocation() async{
   LocationWidget locationWidget = LocationWidget();
   LocationData? locationData = await locationWidget.getLocation();
   _locationData['latitude'] = locationData?.latitude;
   _locationData['longitude'] = locationData?.longitude;
   FirebaseAnalytics.instance.logEvent(name: 'location_found', parameters: _locationData);
 }

 getWeather({byName=false,cityName}) async{
    String key = 'b9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9'; // add your api key here
   WeatherFactory weatherFactory = WeatherFactory(key);
   if(byName){
     try{
       var weather = await weatherFactory.currentWeatherByCityName(cityName);
       FirebaseAnalytics.instance.logEvent(name: 'city_found', parameters: {'city': cityName});
       setState(() {
         _weatherData = weather;
       });
     }catch(e){
       // show alert dialog
       showDialog(
         context: context,
         builder: (context) => AlertDialog(
           title: const Text('Error'),
           content: Text('Could not find weather for $cityName'),
           actions: <Widget>[
             ElevatedButton(
               child: const Text('Ok'),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             )
           ],
         ),
       );
     }
   }
   else {
     double latitude = _locationData['latitude']!;
     double longitude = _locationData['longitude']!;
     Future<Weather> weather = weatherFactory.currentWeatherByLocation(
         latitude, longitude);
     weather.then((value) {
       //print all the keys and values of the weather object
       print(value.toJson());
       setState(() {
         _weatherData = value;
       });
     });
   }
 }

 Future<void> fetchLocationAndWeather() async {
   await getLocation();
   await getWeather();
 }
}