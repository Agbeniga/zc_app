import 'package:flutter/material.dart';
import 'package:hng/app/app.locator.dart';
import 'package:hng/package/base/server-request/api/http_api.dart';

import 'package:hng/services/local_storage_services.dart';
import 'package:hng/ui/view/start_dm/start_dm_models.dart';
import 'package:hng/utilities/storage_keys.dart';
import 'package:stacked/stacked.dart';


class StartDmViewModel extends BaseViewModel {
  final _apiService = locator<HttpApiService>();
  final storageService = locator<SharedPreferenceLocalStorage>();

  bool _hasClickedMessageField = false;
  bool get hasClickedMessageField => _hasClickedMessageField;

  TextEditingController messageController = TextEditingController();

  Future<List<UserModel>> allUsers() async {
    String _currentOrgId = storageService.getString(StorageKeys.currentOrgId) ??
        '61459d8e62688da5302acdb1';
    String token = storageService.getString(StorageKeys.currentSessionToken) ??
        '';
    String endpoint = '/organizations/$_currentOrgId/members/';
    final response = await _apiService.get(
      endpoint,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response?.statusCode == 200) {
      print(response?.data?['data'].length);
      return (response?.data?['data'] as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<UserModel>> get userResults async {
    List<UserModel> _userResults = await allUsers();
    return [..._userResults];
  }

  onTapMessageField() {
    _hasClickedMessageField = true;
    notifyListeners();
  }

  onUnfocusMessageField() {
    _hasClickedMessageField = false;
    notifyListeners();
  }
}
