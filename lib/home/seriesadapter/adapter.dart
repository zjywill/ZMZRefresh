import 'package:fish_redux/fish_redux.dart';
import 'package:zmzrefresh/home/series/component.dart';

import '../state.dart';

class SeriesAdapter extends SourceFlowAdapter<HomeScreenState> {
  SeriesAdapter()
      : super(
          pool: <String, Component<Object>>{"series": SeriesComponent()},
        );
}
