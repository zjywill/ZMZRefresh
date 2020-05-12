import 'dart:developer';

import 'package:fish_redux/fish_redux.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zmzrefresh/home/series/state.dart';

import 'action.dart';
import 'state.dart';

Effect<HomeScreenState> buildEffect() {
  return combineEffects(<Object, Effect<HomeScreenState>>{
    Lifecycle.initState: _init,
    HomeScreenAction.saveBaseUrl: _onSaveBaseUrl,
    HomeScreenAction.addSeries: _onAddSeries,
    HomeScreenAction.removeSeries: _onRemoveSeries,
    HomeScreenAction.onRefresh: _onRefresh,
  });
}

void _init(Action action, Context<HomeScreenState> ctx) async {
  log("_init");
  final prefs = await SharedPreferences.getInstance();
  String baseUrl = prefs.getString("baseUrl");
  ctx.state.baseUrl = baseUrl;
  List<String> seriesList = prefs.getStringList("seriesList");
  if (seriesList != null) {
    List<SeriesState> list = List();
    for (String item in seriesList) {
      SeriesState seriesState = SeriesState();
      seriesState.id = item;
      seriesState.baseUrl = baseUrl;
      list.add(seriesState);
    }
    ctx.state.list = list;
  }
  ctx.dispatch(HomeScreenActionCreator.onPopulated(ctx.state));
}

void _onSaveBaseUrl(Action action, Context<HomeScreenState> ctx) async {
  final String baseUrl = action.payload ?? "";
  log("_onSaveBaseUrl: " + baseUrl);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("baseUrl", baseUrl);
}

void _onAddSeries(Action action, Context<HomeScreenState> ctx) async {
  final String id = action.payload ?? "";
  log("__onAddSeries: " + id);
  if (id.length == 0) {
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  String baseUrl = prefs.getString("baseUrl");
  List<String> seriesList = prefs.getStringList("seriesList");
  if (seriesList == null) {
    seriesList = List();
  }
  seriesList.add(id);
  prefs.setStringList("seriesList", seriesList);
  if (seriesList != null) {
    List<SeriesState> list = List();
    for (String item in seriesList) {
      SeriesState seriesState = SeriesState();
      seriesState.id = item;
      seriesState.baseUrl = baseUrl;
      list.add(seriesState);
    }
    ctx.state.list = list;
  }
  ctx.dispatch(HomeScreenActionCreator.onPopulated(ctx.state));
}

void _onRemoveSeries(Action action, Context<HomeScreenState> ctx) async {
  final String id = action.payload ?? "";
  log("__onRemoveSeries: " + id);
  if (id.length == 0) {
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  String baseUrl = prefs.getString("baseUrl");
  List<String> seriesList = prefs.getStringList("seriesList");
  if (seriesList == null) {
    seriesList = List();
  }
  seriesList.remove(id);
  prefs.setStringList("seriesList", seriesList);
  if (seriesList != null) {
    List<SeriesState> list = List();
    for (String item in seriesList) {
      SeriesState seriesState = SeriesState();
      seriesState.id = item;
      seriesState.baseUrl = baseUrl;
      list.add(seriesState);
    }
    ctx.state.list = list;
  }
  ctx.dispatch(HomeScreenActionCreator.onPopulated(ctx.state));
}

void _onRefresh(Action action, Context<HomeScreenState> ctx) async {
  log("_onRefresh baseUrl: " + ctx.state.baseUrl);
  log("_onRefresh ids size: " + ctx.state.list.length.toString());
  for (SeriesState seriesState in ctx.state.list) {
    String url = ctx.state.baseUrl + seriesState.id;
    String content = await fetchData(url);
    log('fetchData: $content');
  }
  ctx.dispatch(HomeScreenActionCreator.onPopulated(ctx.state));
}

Future<String> fetchData(String url) async {
  log('fetchData: $url');
  String contents = "";
  final response = await http.get(url);
  log('fetchData response $response');
  if (response.statusCode == 200) {
    log('fetchData response 200');
    return response.body;
  } else {
    log('fetchFish Failed');
    throw Exception('Failed to fetch Fish');
  }
}
