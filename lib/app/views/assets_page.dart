import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controllers/assets_controller.dart';
import '../models/locations.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({Key? key}) : super(key: key);

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  final assetsController = GetIt.I.get<AssetsController>();
  List<Locations> get showingList => assetsController.showingList;

  _AssetsPageState() {
    assetsController.addListener(() async {
      if (mounted) {
        setState(() {});
      }
    });
    assetsController.setLocationsList();
    assetsController.setAssetsList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Assets',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Flexible(child: TextFormField()),
                      Flexible(
                        child: Row(
                          children: [
                            FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.bolt),
                              label: const Text('Sensor de energia'),
                            ),
                            FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.error_outline),
                              label: const Text('Crítico'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: showingList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      leading: Image.asset(
                        showingList[index].iconPath,
                        height: 25,
                      ),
                      title: Text(showingList[index].name),
                      children: [
                        showingList[index].locationChild != null
                            ? ListTile(
                                leading: Image.asset(
                                  showingList[index].locationChild!.iconPath,
                                  height: 25,
                                ),
                                title: Text(
                                    showingList[index].locationChild!.name),
                              )
                            : Container(),
                      ],
                    );
                  },
                ),
              ),
              FilledButton(
                onPressed: assetsController.organizeLocations,
                child: const Text('Organize locations'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
