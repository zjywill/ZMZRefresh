import 'package:fish_redux/fish_redux.dart';

class SeriesState implements Cloneable<SeriesState> {
  String id;
  String baseUrl;
  String state;

  SeriesState(this.id, this.baseUrl, this.state);

  @override
  SeriesState clone() {
    return SeriesState(id, baseUrl, state)
      ..id = id
      ..baseUrl = baseUrl;
  }

  Map toJson() => {
        'id': id,
        'baseUrl': baseUrl,
        'state': state,
      };

  factory SeriesState.fromJson(dynamic json) {
    return SeriesState(json['id'] as String, json['baseUrl'] as String,
        json['state'] as String);
  }
}

SeriesState initState(Map<String, dynamic> args) {
  return SeriesState("", "", "");
}
