import 'dart:developer';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:zmzrefresh/home/action.dart';

import 'state.dart';

Widget buildView(
    SeriesState state, Dispatch dispatch, ViewService viewService) {
  log("state: " + state.state.toString());
  return Dismissible(
    key: Key(state.id),
    background: Container(color: Colors.red),
    child: Column(
      children: <Widget>[
        SizedBox(
          height: 56,
          child: ListTile(
            title: Text(state.id),
            subtitle: Text(state.state.toString()),
          ),
        ),
      ],
    ),
    onDismissed: (direction) {
      dispatch(HomeScreenActionCreator.onRemoveSeries(state.id));
    },
  );
}
