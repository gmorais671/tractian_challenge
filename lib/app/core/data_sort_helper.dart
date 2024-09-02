import 'dart:developer';

import 'package:tractian_challenge/app/models/assets.dart';
import 'package:tractian_challenge/app/models/locations.dart';

class DataSortHelper {
  bool debug;

  DataSortHelper({required this.debug});

  Future<List<Locations>> sortLocations(List<Locations> locationsList) async {
    List<Locations> sortedLocations = [];

    List<Locations> hasNoChildren = [];
    List<Locations> itsParent = [];
    List<Locations> auxList = [];

    debug ? log('aux list length: ${auxList.length.toString()}') : null;
    debug ? log('Add locations with parents to another list') : null;

    for (Locations location in locationsList) {
      int parentIndex =
          locationsList.indexWhere((item) => item.id == location.parentId);

      if (parentIndex > -1) itsParent.add(locationsList[parentIndex]);
    }

    hasNoChildren = locationsListDifference(locationsList, itsParent);

    debug
        ? log('has no children list length: ${auxList.length.toString()}')
        : null;
    debug
        ? log('its parent list length: ${itsParent.length.toString()}')
        : null;

    debug ? log('Associate locations with their parents') : null;
    for (Locations location in hasNoChildren) {
      int parentIndex =
          itsParent.indexWhere((item) => item.id == location.parentId);

      if (parentIndex > -1) {
        itsParent[parentIndex].locationChild = location;
        auxList.add(location);
      }
    }

    hasNoChildren = locationsListDifference(hasNoChildren, auxList);

    debug ? log('has no children list length: ${auxList.toString()}') : null;
    debug ? log('its parent list length: ${itsParent.toString()}') : null;

    sortedLocations = [...itsParent, ...hasNoChildren];

    debug ? log('Sorted locations: ${sortedLocations.toString()}') : null;

    return sortedLocations;
  }

  Future<List<Assets>> sortAssets(List<Assets> assetsList) async {
    List<Assets> sortedAssets = [];

    return sortedAssets;
  }

  List<Locations> locationsListDifference(
    List<Locations> list1,
    List<Locations> list2,
  ) {
    List<Locations> difference = [];

    Set<Locations> set1 = list1.toSet();
    Set<Locations> set2 = list2.toSet();

    Set<Locations> result = set1.difference(set2);

    difference = result.toList();

    return difference;
  }
}
