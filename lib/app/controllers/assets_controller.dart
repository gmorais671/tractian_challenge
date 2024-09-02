import 'package:flutter/cupertino.dart';
import 'package:tractian_challenge/app/core/data_sort_helper.dart';
import 'package:tractian_challenge/app/core/repository.dart';

import '../models/assets.dart';
import '../models/companies.dart';
import '../models/locations.dart';

class AssetsController extends ChangeNotifier {
  Repository repo = Repository();
  DataSortHelper helper = DataSortHelper(debug: true);

  List<Companies> companiesList = [];

  List<Locations> locationsList = [];

  List<Locations> showingList = [];

  List<Assets> assetsList = [];

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

  Future<bool> setLocationsList() async {
    if (selectedCompany != null) {
      List<Locations> auxList = await repo.getLocations(selectedCompany!.id);

      locationsList = auxList;

      organizeLocations();
      notifyListeners();

      return auxList.isNotEmpty ? true : false;
    }
    return false;
  }

  Future<bool> setAssetsList() async {
    if (selectedCompany != null && selectedCompany?.id != null) {
      List<Assets> auxList = await repo.getAssets(selectedCompany!.id);

      assetsList = auxList;
      notifyListeners();

      return auxList.isNotEmpty ? true : false;
    }
    return false;
  }

  Future<void> organizeLocations() async {
    showingList = await helper.sortLocations(locationsList);

    notifyListeners();
  }
}
