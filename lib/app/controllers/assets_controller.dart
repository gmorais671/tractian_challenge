import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:tractian_challenge/app/core/data_sort_helper.dart';
import 'package:tractian_challenge/app/core/repository.dart';

import '../models/assets.dart';
import '../models/companies.dart';
import '../models/locations.dart';

class AssetsController extends ChangeNotifier {
  Repository repo = Repository();
  DataSortHelper helper = DataSortHelper(debug: false);

  List<Companies> companiesList = [];

  List<Locations> locationsList = [];
  List<Assets> assetsList = [];
  List<Locations> showingLocList = [];
  List<Assets> showingAssetList = [];
  List<String> auxHierarchyIds = [];

  List<dynamic> displayList = [];
  List<dynamic> filteredList = [];

  bool energyFilterOn = false;
  bool criticalFilterOn = false;

  Companies? selectedCompany;

  bool selectCompany(Companies value) {
    selectedCompany = value;
    notifyListeners();

    return selectedCompany == value;
  }

  Future<bool> setCompaniesList() async {
    List<Companies> auxList = await repo.getCompanies();
    companiesList = auxList;
    notifyListeners();

    return auxList.isNotEmpty ? true : false;
  }

  clearExibitionList() {
    displayList.clear();
    notifyListeners();
  }

  setDisplayList() async {
    locationsList.clear();
    assetsList.clear();
    filteredList.clear();
    displayList.clear();
    showingAssetList.clear();
    showingLocList.clear();
    if (selectedCompany != null) {
      locationsList = await repo.getLocations(selectedCompany!.id);
      assetsList = await repo.getAssets(selectedCompany!.id);

      showingAssetList = helper.sortAssets(assetsList);

      List locationsWithAssetsChildren =
          helper.assignAssetsAndLocations(showingAssetList, locationsList);

      List<Locations> auxLocList = [];

      showingAssetList.clear();

      for (var item in locationsWithAssetsChildren) {
        if (item is Assets) showingAssetList.add(item);
        if (item is Locations) auxLocList.add(item);
      }

      showingLocList = helper.sortLocations(auxLocList);

      displayList.addAll(showingLocList);
      displayList.addAll(showingAssetList);
    }

    filterDisplayList(null);

    notifyListeners();
  }

  filterDisplayList(String? filterContent) {
    List<String> filteredIds = [];
    filteredList.clear();
    if (filterContent == null || filterContent.isEmpty) {
      filteredList.addAll(displayList);
    } else {
      var aux = locationsList
          .where((element) => element.name.contains(filterContent))
          .toList();

      var aux2 = assetsList
          .where((element) => element.name.contains(filterContent))
          .toList();

      for (var element in aux) {
        filteredIds.add(element.id);
      }

      for (var element in aux2) {
        filteredIds.add(element.id);
      }

      for (var hierarchy in displayList) {
        if (hierarchy is Locations) {
          List<String> auxLoc = getDescendentsList(hierarchy, null);

          for (var id in filteredIds) {
            if (auxLoc.contains(id) && !filteredList.contains(hierarchy)) {
              filteredList.add(hierarchy);
            }
          }
        }
        if (hierarchy is Assets) {
          List<String> auxLoc = getDescendentsList(null, hierarchy);

          for (var id in filteredIds) {
            if (auxLoc.contains(id) && !filteredList.contains(hierarchy)) {
              filteredList.add(hierarchy);
            }
          }
        }
      }
    }
    notifyListeners();
  }

  energySensorFilter() {
    List<String> filteredIds = [];
    filteredList.clear();

    var aux =
        assetsList.where((element) => element.sensorType == "energy").toList();

    for (var element in aux) {
      filteredIds.add(element.id);
    }

    for (var hierarchy in displayList) {
      if (hierarchy is Locations) {
        List<String> auxLoc = getDescendentsList(hierarchy, null);

        for (var id in filteredIds) {
          if (auxLoc.contains(id) && !filteredList.contains(hierarchy)) {
            filteredList.add(hierarchy);
          }
        }
      }
      if (hierarchy is Assets) {
        List<String> auxLoc = getDescendentsList(null, hierarchy);

        for (var id in filteredIds) {
          if (auxLoc.contains(id) && !filteredList.contains(hierarchy)) {
            filteredList.add(hierarchy);
          }
        }
      }
    }

    criticalFilterOn = false;
    energyFilterOn = true;
    log('Dsp ${displayList.toString()}');
    log('Flt ${filteredList.toString()}');
    notifyListeners();
  }

  criticalStatusFilter() {
    List<String> filteredIds = [];
    filteredList.clear();

    var aux = assetsList.where((element) => element.status == "alert").toList();

    for (var element in aux) {
      filteredIds.add(element.id);
    }

    for (var hierarchy in displayList) {
      if (hierarchy is Locations) {
        List<String> auxLoc = getDescendentsList(hierarchy, null);

        for (var id in filteredIds) {
          if (auxLoc.contains(id) && !filteredList.contains(hierarchy)) {
            filteredList.add(hierarchy);
          }
        }
      }
      if (hierarchy is Assets) {
        List<String> auxLoc = getDescendentsList(null, hierarchy);

        for (var id in filteredIds) {
          if (auxLoc.contains(id) && !filteredList.contains(hierarchy)) {
            filteredList.add(hierarchy);
          }
        }
      }
    }

    energyFilterOn = false;
    criticalFilterOn = true;
    log('Dsp ${displayList.toString()}');
    log('Flt ${filteredList.toString()}');
    notifyListeners();
  }

  filterOff() {
    log('Dsp ${displayList.toString()}');
    log('Flt ${filteredList.toString()}');
    energyFilterOn = false;
    criticalFilterOn = false;
    notifyListeners();

    setDisplayList();
  }

  List<String> getDescendentsList(Locations? location, Assets? asset) {
    auxHierarchyIds.clear();

    List<String> getAllDescendentsIds(Locations? location, Assets? asset) {
      if (asset != null) {
        auxHierarchyIds.add(asset.id);

        for (var child in asset.children) {
          getAllDescendentsIds(null, child);
        }
      }
      if (location != null) {
        auxHierarchyIds.add(location.id);
        if (location.locationChild.isNotEmpty) {
          for (var child in location.locationChild) {
            getAllDescendentsIds(child, null);
          }
        }
        if (location.children.isNotEmpty) {
          for (var child in location.children) {
            getAllDescendentsIds(null, child);
          }
        }
      }

      return auxHierarchyIds;
    }

    return getAllDescendentsIds(location, asset);
  }
}
