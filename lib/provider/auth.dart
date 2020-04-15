import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'urls.dart';

class Auth with ChangeNotifier {
  String _token;
  bool _isLoggedin;

  bool _isFirstLogin=false;
  bool _isFirstLogout=false;

  bool get isLoggedin => _isLoggedin;

  bool get isFirstLogout => _isFirstLogout;

  set isFirstLogout(bool value) {
    _isFirstLogout = value;
  }

  set isLoggedin(bool value) {
    _isLoggedin = value;
  }

  bool get isAuth {
    getToken();
    return _token != null && _token != '';
  }

  String get token => _token;
  Map<String, String> headers = {};

  Future<bool> _authenticate(String urlSegment) async {
    print('_authenticate');

    final url = Urls.rootUrl + Urls.loginEndPoint + urlSegment;
    print(url);

    try {
      final response = await http.post(url, headers: headers);
      updateCookie(response);

      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData != 'false') {
        try {
          _token = responseData['token'];
          _isFirstLogin=true;

          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              'token': _token,
            },
          );
          prefs.setString('userData', userData);
          prefs.setString('token', _token);
          print(_token);
          prefs.setString('isLogin', 'true');
          _isLoggedin = true;
        } catch (error) {
          _isLoggedin = false;

          _token = '';
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        _isLoggedin = false;

        _token = '';
        prefs.setString('token', _token);
        print(_token);
        print('noooo token');
        prefs.setString('isLogin', 'true');
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return _isLoggedin;
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  Future<void> login(String phoneNumber) async {
    return _authenticate('?mobile=$phoneNumber');
  }

  Future<bool> getVerCode(String verificationCode, String phoneNumber) async {
    return _authenticate(
        '/token?mobile=$phoneNumber&sms_code=$verificationCode');
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    notifyListeners();
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _token = '';
    print('toookeeen');
    print(prefs.getString('token'));
    notifyListeners();
  }

  bool get isFirstLogin => _isFirstLogin;

  set isFirstLogin(bool value) {
    _isFirstLogin = value;
  }

//  Future<bool> tryAutoLogin() async {
//    final prefs = await SharedPreferences.getInstance();
//    if (!prefs.containsKey('userData')) {
//      return false;
//    }
//    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
//    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
//
//    if (expiryDate.isBefore(DateTime.now())) {
//      return false;
//    }
//    _token = extractedUserData['token'];
//    _userId = extractedUserData['userId'];
//    _expiryDate = expiryDate;
//    notifyListeners();
//    _autoLogout();
//    return true;
//  }
//
//  Future<void> logout() async {
//    _token = null;
//    _userId = null;
//    _expiryDate = null;
//    if (_authTimer != null) {
//      _authTimer.cancel();
//      _authTimer = null;
//    }
//    notifyListeners();
//    final prefs = await SharedPreferences.getInstance();
//    // prefs.remove('userData');
//    prefs.clear();
//  }
//
//  void _autoLogout() {
//    if (_authTimer != null) {
//      _authTimer.cancel();
//    }
//    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
//    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
//  }
}
