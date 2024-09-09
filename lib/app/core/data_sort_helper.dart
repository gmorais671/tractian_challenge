import 'dart:developer';

import 'package:tractian_challenge/app/models/assets.dart';
import 'package:tractian_challenge/app/models/locations.dart';

class DataSortHelper {
  bool debug;

  DataSortHelper({required this.debug});

  List<Assets> sortAssets(List<Assets> assets) {
    List<Assets> sortedList = [];
    List<String> auxAssetsIds = [];
    Map<String, Assets> assetsMap = {for (var asset in assets) asset.id: asset};

    Assets? createHierarchy(String parentId) {
      Assets? parent = assetsMap[parentId];
      if (parent == null) return null;

      //add all children to respective parent.children
      List<Assets> parentChildren =
          assets.where((element) => element.parentId == parentId).toList();
      parent.children = [...parentChildren];

      parent.children.sort((a, b) => a.name.compareTo(b.name));

      for (var child in parent.children) {
        createHierarchy(child.id);
      }

      debug ? log('Created parent: ${parent.toString()}') : null;

      return parent;
    }

    getAllDescendentsId(Assets? asset) {
      if (asset != null) {
        auxAssetsIds.add(asset.id);

        for (var child in asset.children) {
          getAllDescendentsId(child);
        }
      }
    }

    for (var asset in assets) {
      if (asset.parentId == null || asset.parentId!.isEmpty) {
        Assets? hierarchy = createHierarchy(asset.id.toString());

        if (hierarchy != null) {
          getAllDescendentsId(hierarchy);

          assetsMap.removeWhere((key, value) => auxAssetsIds.contains(key));

          sortedList.add(hierarchy);
        }

        auxAssetsIds.clear();
      }
    }

    debug ? log('Rest: ${assetsMap.toString()}') : null;

    return sortedList;
  }

  List<Locations> sortLocations(List<Locations> locations) {
    List<Locations> sortedList = [];
    List<String> auxLocationsIds = [];
    Map<String, Locations> assetsMap = {
      for (var location in locations) location.id: location
    };

    Locations? createHierarchy(String parentId) {
      Locations? parent = assetsMap[parentId];
      if (parent == null) return null;

      //add all children to respective parent.children
      List<Locations> parentChildren =
          locations.where((element) => element.parentId == parentId).toList();
      parent.locationChild = parentChildren;

      parent.children.sort((a, b) => a.name.compareTo(b.name));

      for (var child in parent.children) {
        createHierarchy(child.id);
      }

      debug ? log('Created parent: ${parent.toString()}') : null;

      return parent;
    }

    getAllDescendentsId(Locations? location) {
      if (location != null) {
        auxLocationsIds.add(location.id);

        for (var child in location.locationChild) {
          getAllDescendentsId(child);
        }
      }
    }

    for (var location in locations) {
      if (location.parentId == null || location.parentId!.isEmpty) {
        Locations? hierarchy = createHierarchy(location.id.toString());

        if (hierarchy != null) {
          getAllDescendentsId(hierarchy);

          assetsMap.removeWhere((key, value) => auxLocationsIds.contains(key));

          sortedList.add(hierarchy);
        }

        auxLocationsIds.clear();
      }
    }

    debug ? log('Rest: ${assetsMap.toString()}') : null;

    return sortedList;
  }

  List<dynamic> assignAssetsAndLocations(
      List<Assets> assets, List<Locations> locations) {
    List<dynamic> sortedObjects = [];

    Map<String, Locations> locationsMap = {
      for (var location in locations) location.id: location
    };

    Locations? assignAssetsToLocation(String parentId) {
      Locations? parent = locationsMap[parentId];
      if (parent == null) return null;

      //add all children to respective parent.children
      List<Assets> parentChildren =
          assets.where((element) => element.locationId == parentId).toList();
      parent.children = parentChildren;

      parent.children.sort((a, b) => a.name.compareTo(b.name));

      for (var child in parent.children) {
        assets.removeWhere((element) => element.id == child.id);
      }

      debug ? log('Asset -> Location: ${parent.toString()}') : null;

      return parent;
    }

    locationsMap.forEach((key, value) {
      var aux = assignAssetsToLocation(value.id);
      if (aux != null) value = aux;
    });

    sortedObjects.addAll(assets);
    locationsMap.forEach((key, value) {
      sortedObjects.add(value);
    });

    debug ? log('Assets assign: ${sortedObjects.toString()}') : null;

    return sortedObjects;
  }
}
