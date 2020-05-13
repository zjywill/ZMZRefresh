import 'dart:convert';
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
  String seriesList = prefs.getString("seriesJson");
  List<SeriesState> list = jsonStringToList(seriesList);
  ctx.state.list = list;
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
  String seriesList = prefs.getString("seriesJson");
  List<SeriesState> list = jsonStringToList(seriesList);
  SeriesState state = SeriesState(id, baseUrl, "new");
  list.add(state);
  ctx.state.baseUrl = baseUrl;
  ctx.state.list = list;
  log("__onAddSeries list: " + list.toString());
  prefs.setString("seriesJson", listToJsonString(list));
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
  String seriesList = prefs.getString("seriesJson");
  List<SeriesState> list = jsonStringToList(seriesList);
  log("_onRemoveSeries list: " + list.length.toString());
  for (SeriesState item in list) {
    if (item.id == id) {
      log("_onRemoveSeries id: " + id);
      list.remove(item);
      break;
    }
  }
  log("_onRemoveSeries list: " + list.length.toString());
  ctx.state.baseUrl = baseUrl;
  ctx.state.list = list;
  prefs.setString("seriesJson", listToJsonString(list));
  ctx.dispatch(HomeScreenActionCreator.onPopulated(ctx.state));
}

void _onRefresh(Action action, Context<HomeScreenState> ctx) async {
  try {
    log("_onRefresh baseUrl: " + ctx.state.baseUrl);
    log("_onRefresh ids size: " + ctx.state.list.length.toString());
    final prefs = await SharedPreferences.getInstance();
    String baseUrl = prefs.getString("baseUrl");
    String seriesList = prefs.getString("seriesJson");
    List<SeriesState> list = jsonStringToList(seriesList);
    for (SeriesState seriesState in list) {
      String url = ctx.state.baseUrl + seriesState.id;
      String content = await fetchData(url);
      log('fetchData: $content');
      if (content.length > 0) {
        var dateTime = new DateTime.now();
        seriesState.state = dateTime.toString();
      }
    }
    prefs.setString("seriesJson", listToJsonString(list));
    ctx.state.baseUrl = baseUrl;
    ctx.state.list = list;
  } catch (e) {
    log("_onRefresh e: " + e.toString());
  }
  ctx.dispatch(HomeScreenActionCreator.onPopulated(ctx.state));
}

String listToJsonString(List<SeriesState> data) {
  String ret = jsonEncode(data);
  log("listToJsonString ret: " + ret);
  return ret;
}

List<SeriesState> jsonStringToList(String store) {
  if (store == null || store.length == 0) {
    store = "{}";
  }
  log("jsonStringToList store: " + store);
  var targetJson = jsonDecode(store) as List;
  List<SeriesState> ret = List();
  try {
    ret = targetJson.map((tagJson) => SeriesState.fromJson(tagJson)).toList();
  } catch (e) {
    log("jsonStringToList e: " + e.toString());
  }
  return ret;
}

Future<String> fetchData(String url) async {
  log('fetchData: $url');
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
