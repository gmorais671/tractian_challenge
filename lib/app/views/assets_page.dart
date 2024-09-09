import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controllers/assets_controller.dart';
import '../models/assets.dart';
import '../models/locations.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({Key? key}) : super(key: key);

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  final assetsController = GetIt.I.get<AssetsController>();
  List<Locations> get showingLocList => assetsController.showingLocList;
  List<Assets> get showingAssetList => assetsController.showingAssetList;
  List<dynamic> get filteredList => assetsController.filteredList;
  bool get energyFilterOn => assetsController.energyFilterOn;
  bool get criticalFilterOn => assetsController.criticalFilterOn;
  String filterContent = '';

  _AssetsPageState() {
    assetsController.addListener(() async {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            initialValue: filterContent,
                            onChanged: (value) {
                              setState(() {
                                filterContent = value;
                              });
                              assetsController.filterDisplayList(filterContent);
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.05),
                              label: Row(
                                children: const [
                                  Icon(
                                    Icons.search_rounded,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Buscar Ativo ou Local')
                                ],
                              ),
                              labelStyle: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                              errorStyle: const TextStyle(fontSize: 11),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                  backgroundColor: energyFilterOn
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  side: BorderSide(
                                      color: energyFilterOn
                                          ? Colors.transparent
                                          : const Color(0xFF77818C)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                              onPressed: energyFilterOn
                                  ? () {
                                      assetsController.filterOff();
                                    }
                                  : () {
                                      assetsController.energySensorFilter();
                                    },
                              icon: Icon(
                                Icons.bolt_rounded,
                                color: energyFilterOn
                                    ? Colors.white
                                    : const Color(0xFF77818C),
                              ),
                              label: Text(
                                'Sensor de energia',
                                style: energyFilterOn
                                    ? const TextStyle(color: Colors.white)
                                    : const TextStyle(color: Color(0xFF77818C)),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: criticalFilterOn
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                side: BorderSide(
                                    color: criticalFilterOn
                                        ? Colors.transparent
                                        : const Color(0xFF77818C)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: criticalFilterOn
                                  ? () {
                                      assetsController.filterOff();
                                    }
                                  : () {
                                      assetsController.criticalStatusFilter();
                                    },
                              icon: Icon(
                                Icons.error_outline,
                                color: criticalFilterOn
                                    ? Colors.white
                                    : const Color(0xFF77818C),
                              ),
                              label: Text(
                                'Crítico',
                                style: criticalFilterOn
                                    ? const TextStyle(color: Colors.white)
                                    : const TextStyle(color: Color(0xFF77818C)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: createHierarchyList(filteredList),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView createHierarchyList(List<dynamic> displayList) {
    return ListView.builder(
      itemCount: displayList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return (displayList[index] is Locations)
            ? ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                tilePadding: const EdgeInsets.symmetric(horizontal: 5),
                controlAffinity: ListTileControlAffinity.leading,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      displayList[index].iconPath,
                      height: 25,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      displayList[index].name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                children: [
                  displayList[index].locationChild.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: createHierarchyList(
                              displayList[index].locationChild))
                      : Container(),
                  displayList[index].children.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child:
                              createHierarchyList(displayList[index].children))
                      : Container(),
                ],
              )
            : (displayList[index] is Assets)
                ? ExpansionTile(
                    childrenPadding: EdgeInsets.zero,
                    shape: const Border(),
                    collapsedShape: const Border(),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 5),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          displayList[index].iconPath,
                          height: 25,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          displayList[index].name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        (displayList[index].status == 'alert')
                            ? const Icon(
                                Icons.error,
                                color: Color(0xFFED3833),
                                size: 10,
                              )
                            : (displayList[index].sensorType == 'energy')
                                ? const Icon(
                                    Icons.bolt_rounded,
                                    color: Color(0xFF52C41A),
                                    size: 16,
                                  )
                                : Container(),
                      ],
                    ),
                    children: [
                      displayList[index].children.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: createHierarchyList(
                                  displayList[index].children))
                          : Container(),
                    ],
                  )
                : Container();
      },
    );
  }
}
