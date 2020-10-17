import 'package:flutter/cupertino.dart';

class UserInfo with ChangeNotifier {
  String accessToken;
  int expiresIn;
  String refreshToken;
  String accountUsername;
  int accountID;

  String _parseURLKey(String url, String key) {
    int startIndex = url.indexOf(key);
    int endIndex = startIndex;

    if (startIndex == -1) return "";
    while (endIndex < url.length) {
      if (url[endIndex] == '=') {
        startIndex = endIndex + 1;
      } else if (url[endIndex] == '&') {
        return (url.substring(startIndex, endIndex));
      }
      endIndex++;
    }
    return (url.substring(startIndex, endIndex));
  }

  Object getInfos() {
    return {
      accessToken: accessToken,
      expiresIn: expiresIn,
      refreshToken: refreshToken,
      accountUsername: accountUsername,
      accountID: accountID
    };
  }

  void logUser(String url) {
    accessToken = _parseURLKey(url, "access_token");
    expiresIn = int.tryParse(_parseURLKey(url, "expires_in"));
    refreshToken = _parseURLKey(url, "refresh_token");
    accountUsername = _parseURLKey(url, "account_username");
    accountID = int.tryParse(_parseURLKey(url, "account_id"));
    notifyListeners();
  }

  void logoutUser() {
    accessToken = null;
    expiresIn = null;
    refreshToken = null;
    accountUsername = null;
    accountID = null;
    notifyListeners();
  }
}
