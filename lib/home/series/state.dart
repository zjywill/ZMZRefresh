import 'package:fish_redux/fish_redux.dart';

class SeriesState implements Cloneable<SeriesState> {
  String id;
  String baseUrl;
  String state;

  @override
  SeriesState clone() {
    return SeriesState()
      ..id = id
      ..baseUrl = baseUrl;
  }
}

SeriesState initState(Map<String, dynamic> args) {
  return SeriesState();
}
