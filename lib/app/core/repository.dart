import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:tractian_challenge/app/models/assets.dart';
import 'package:tractian_challenge/app/models/companies.dart';
import 'package:tractian_challenge/app/models/locations.dart';

const String _baseUrl = 'https://fake-api.tractian.com/companies';

class Repository {
  Future<List<Companies>> getCompanies() async {
    List<Companies> companiesList = [];

    Uri uri = Uri.parse(_baseUrl);

    try {
      var request = await get(uri);

      log(request.body);

      for (var item in json.decode(request.body)) {
        var aux = Companies.fromJson(item);
        companiesList.add(aux);
      }

      log('COMPANIES LIST: $companiesList');

      return companiesList;
    } catch (e) {
      log('Comps list error: ${e.toString()}');
      throw Exception(e);
    } finally {
      return companiesList;
    }
  }

  Future<List<Locations>> getLocations(String companyId) async {
    List<Locations> locationsList = [];

    Uri uri = Uri.parse('$_baseUrl/$companyId/locations');

    try {
      var request = await get(uri);

      log(request.body);

      for (var item in json.decode(request.body)) {
        var aux = Locations.fromJson(item);
        locationsList.add(aux);
      }

      log('LOCATIONS LIST LENGTH: ${locationsList.length}');

      return locationsList;
    } catch (e) {
      log('Locs list error: ${e.toString()}');
      throw Exception(e);
    }
  }

  Future<List<Assets>> getAssets(String companyId) async {
    List<Assets> assetsList = [];

    Uri uri = Uri.parse('$_baseUrl/$companyId/assets');

    try {
      var request = await get(uri);

      log(request.body);

      for (var item in json.decode(request.body)) {
        var aux = Assets.fromJson(item);
        assetsList.add(aux);
      }

      log('ASSETS LIST LENGTH: ${assetsList.length}');

      return assetsList;
    } catch (e) {
      log('Assets list error: ${e.toString()}');
      throw Exception(e);
    }
  }
}
