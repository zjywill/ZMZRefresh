import 'package:fish_redux/fish_redux.dart';
import 'package:zmzrefresh/home/series/state.dart';

class HomeScreenState extends MutableSource
    implements Cloneable<HomeScreenState> {
  bool isLoading = false;
  String baseUrl;
  List<SeriesState> list;

  void setBaseUrl(String baseUrl){
    this.baseUrl = baseUrl;
  }

  @override
  HomeScreenState clone() {
    return HomeScreenState()
      ..list = list
      ..baseUrl = baseUrl
      ..isLoading = isLoading;
  }

  @override
  Object getItemData(int index) {
    return list[index];
  }

  @override
  String getItemType(int index) {
    return "series";
  }

  @override
  int get itemCount => list?.length ?? 0;

  @override
  void setItemData(int index, Object data) {
    list[index] = data;
  }
}

HomeScreenState initState(Map<String, dynamic> args) {
  HomeScreenState homeScreenState = HomeScreenState();
  homeScreenState.isLoading = true;
  homeScreenState.baseUrl = "";
  return homeScreenState;
}
