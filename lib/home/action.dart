import 'package:fish_redux/fish_redux.dart';
import 'package:zmzrefresh/home/state.dart';

enum HomeScreenAction {
  saveBaseUrl,
  addSeries,
  removeSeries,
  onRefresh,
  refreshing,
  onPopulated
}

class HomeScreenActionCreator {
  static Action onSaveBaseUrl(String baseUrl) {
    return Action(HomeScreenAction.saveBaseUrl, payload: baseUrl);
  }

  static Action onAddSeries(String seriesId) {
    return Action(HomeScreenAction.addSeries, payload: seriesId);
  }

  static Action onRemoveSeries(String seriesId) {
    return Action(HomeScreenAction.removeSeries, payload: seriesId);
  }

  static Action onRefresh() {
    return const Action(HomeScreenAction.onRefresh);
  }

  static Action refreshing() {
    return const Action(HomeScreenAction.refreshing);
  }

  static Action onPopulated(HomeScreenState state) {
    return Action(HomeScreenAction.onPopulated, payload: state);
  }
}
