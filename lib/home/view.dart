import 'dart:developer';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zmzrefresh/home/action.dart';

import 'state.dart';

class HomeView {
  RefreshController _refreshController;

  HomeView() {
    _refreshController = RefreshController();
  }

  Widget buildView(HomeScreenState state, Dispatch dispatch,
      ViewService viewService) {
    final ListAdapter adapter = viewService.buildAdapter();
    log("adapter: " + adapter.itemCount.toString());
    final TextEditingController baseUrlController = TextEditingController();
    final TextEditingController idController = TextEditingController();
    baseUrlController.text = state.baseUrl;
    if (!state.isLoading) {
      _refreshController.refreshCompleted();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('ZMZRefresh'),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SizedBox(
                    height: 56,
                    child: TextFormField(
                      maxLines: 1,
                      controller: baseUrlController,
                      decoration:
                      InputDecoration(labelText: 'Enter Your Base Url'),
                    )),
              ),
              Container(
                height: 56,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
                child: ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.blue.shade300, // inkwell color
                      child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          )),
                      onTap: () {
                        dispatch(HomeScreenActionCreator.onSaveBaseUrl(
                            baseUrlController.text));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SizedBox(
                    height: 56,
                    child: TextFormField(
                      controller: idController,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      decoration: InputDecoration(labelText: 'Add Series ID'),
                    )),
              ),
              Container(
                height: 56,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
                child: ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.blue.shade300, // inkwell color
                      child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                      onTap: () {
                        dispatch(HomeScreenActionCreator.onAddSeries(
                            idController.text));
                        idController.text = '';
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: () => dispatch(HomeScreenActionCreator.onRefresh()),
                child: ListView.builder(
                  itemCount: adapter.itemCount,
                  itemBuilder: adapter.itemBuilder,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
