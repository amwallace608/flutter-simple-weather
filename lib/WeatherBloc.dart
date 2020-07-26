import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_weather/WeatherModel.dart';
import 'package:simple_weather/WeatherRepo.dart';

//Weather Event equatable base class for all weather events
class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//Event to fetch weather data from API/WeatherRepo
class FetchWeather extends WeatherEvent {
  final city;
  FetchWeather(this.city);

  @override
  List<Object> get props => [city];
}

//Event to reset/change weather data to another city
class ResetWeather extends WeatherEvent {}

//Weather State equatable base class for state data
class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}

//State for no search performed
class WeatherNotSearched extends WeatherState {}

//State for when weather data is loading
class WeatherIsLoading extends WeatherState {}

//State for when weather is loaded successfully
class WeatherIsLoaded extends WeatherState {
  final weather;

  WeatherIsLoaded(this.weather);

  WeatherModel get getWeather => weather;

  @override
  List<Object> get props => [weather];
}

//State for when an error is encountered while loading weather data
class WeatherLoadingError extends WeatherState {}

//Weather bloc class
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepo weatherRepo;
  WeatherBloc(this.weatherRepo) : super(null);

  @override
  WeatherState get initalState => WeatherNotSearched();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    //check event value
    if (event is FetchWeather) {
      //set WeatherIsLoading state
      yield WeatherIsLoading();

      //try/catch block to get weather data for city of fetch event
      try {
        WeatherModel weather = await weatherRepo.getWeather(event.city);
        //set WeatherIsLoaded state, and pass weather data
        yield WeatherIsLoaded(weather);
      } catch (_) {
        print(_);
        //on error, set WeatherLoadingError state
        yield WeatherLoadingError();
      }
    } else if (event is ResetWeather) {
      //set WeatherNotSearched state
      yield WeatherNotSearched();
    }
  }
}
