import 'package:flutter/material.dart';
import 'package:simple_weather/WeatherBloc.dart';
import 'package:simple_weather/WeatherModel.dart';
import 'package:simple_weather/WeatherRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flare_flutter/flare_actor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //set title
      title: 'Simple Weather',
      //set theme/colors
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      //home page scaffold
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: BlocProvider(
          create: (BuildContext context) => WeatherBloc(WeatherRepo()),
          child: SearchPage(),
        ),
      ),
    );
  }
}

//Search page widget for home screen
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    //define city search text editing controller
    var cityController = TextEditingController();

    //return Column layout
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        print(state);
        if (state is WeatherNotSearched || state == null) {
          return Column(
            //center items on main axis
            mainAxisAlignment: MainAxisAlignment.start,
            //align items to start on cross axis
            crossAxisAlignment: CrossAxisAlignment.start,
            //define child widgets
            children: <Widget>[
              //Center container for globe icon
              Center(
                child: Container(
                  child: FlareActor(
                    "assets/world.flr",
                    fit: BoxFit.contain,
                    animation: "Preview2",
                  ),
                  height: 240,
                  width: 240,
                  padding: EdgeInsets.only(top: 10),
                ),
              ),

              //Container for Search Bar, Button, Weather Data
              Container(
                //pad container on left and right edges
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Column(
                  children: <Widget>[
                    //search heading text
                    Text(
                      "Search Weather",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70),
                    ),
                    //search subheading text
                    Text(
                      "Instantly",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w200,
                          color: Colors.white70),
                    ),

                    SizedBox(
                      height: 24,
                    ),
                    //Search text field
                    TextFormField(
                      //set controller
                      controller: cityController,
                      //set decoration for icon, border, hint, and input text
                      decoration: InputDecoration(
                        //search icon
                        prefixIcon: Icon(Icons.search, color: Colors.white70),
                        //enabled border
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.white70,
                                style: BorderStyle.solid)),

                        //focused border
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.blue, style: BorderStyle.solid)),

                        //hint text
                        hintText: "City Name",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white70),
                    ),

                    //search button
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      //rounded rectangle button to search by city
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          weatherBloc.add(FetchWeather(cityController.text));
                        },
                        color: Colors.lightBlue,
                        child: Text(
                          "Search",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        } else if (state is WeatherIsLoading) {
          //return loading indicator if weather is loading
          return Column(
              //center items on main axis
              mainAxisAlignment: MainAxisAlignment.center,
              //align items to start on cross axis
              crossAxisAlignment: CrossAxisAlignment.start,
              //define child widget for progress indicator
              children: <Widget>[Center(child: CircularProgressIndicator())]);
        } else if (state is WeatherIsLoaded) {
          //return WeatherData from ShowWeather if weather loaded
          return ShowWeather(state.getWeather, cityController.text);
        } else {
          //otherwise indicate error
          return Text("Error Loading Weather",
              style: TextStyle(color: Colors.white70));
        }
      },
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  final city;

  var iconAnim;
  //constructor
  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    //determine which icon/animation to use
    switch (weather.description) {
      case "Clouds":
        {
          iconAnim = "03d";
        }
        break;

      case "Clear":
        {
          iconAnim = "01d";
        }
        break;

      case "Snow":
        {
          iconAnim = "13d";
        }
        break;

      case "Rain":
        {
          iconAnim = "09d";
        }
        break;

      case "Drizzle":
        {
          iconAnim = "10d";
        }
        break;

      case "Thunderstorm":
        {
          iconAnim = "11d";
        }
        break;
      default:
        {
          iconAnim = "wind";
        }
        break;
    }

    return Column(
        //center items on main axis
        mainAxisAlignment: MainAxisAlignment.center,
        //align items to start on cross axis
        crossAxisAlignment: CrossAxisAlignment.start,
        //define child widgets
        children: <Widget>[
          //Center container for weather
          Center(
            child: Container(
              child: FlareActor(
                "assets/weather_icons.flr",
                fit: BoxFit.contain,
                animation: iconAnim,
              ),
              height: 300,
              width: 300,
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 32, left: 32, top: 10),
            child: Column(
              children: <Widget>[
                //city name text
                Text(city,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),

                //Temperature text
                Text(weather.getTemp.round().toString() + "°f",
                    style: TextStyle(color: Colors.white70, fontSize: 45)),
                //Weather description text
                Text(
                  weather.description,
                  style: TextStyle(color: Colors.white60, fontSize: 20),
                ),

                //Row for Min/Max temps
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //Column for Min/Low temp
                    Column(
                      children: <Widget>[
                        Text(
                          weather.getMinTemp.round().toString() + "°f",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        Text(
                          "Low",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ],
                    ),
                    //Column for Max/High temp
                    Column(
                      children: <Widget>[
                        Text(
                          weather.getMaxTemp.round().toString() + "°f",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        Text(
                          "High",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                //new/reset search button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onPressed: () {
                      BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                    },
                    color: Colors.lightBlue,
                    child: Text("New Search",
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ),
                )
              ],
            ),
          )
        ]);
  }
}
