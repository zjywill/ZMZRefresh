import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SeriesComponent extends Component<SeriesState> {
  SeriesComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SeriesState>(
                adapter: null,
                slots: <String, Dependent<SeriesState>>{
                }),);

}
