import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/models/user_events/user_events.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_exception.dart';

class ApiProvider {
  ApiProvider._privateConstructor();

  static final ApiProvider instance = ApiProvider._privateConstructor();

  final Dio _dio = getDio();

  static Dio getDio() {
    Dio _dio = Dio();
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
    return _dio;
  }

  final String _baseUrl = Constants.BASE_URL+'api/';

  Future<LoginResponse?> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(Constants.PARAM_USER_DETAILS) == null) {
      return null;
    } else {
      return LoginResponse.fromJson(
          json.decode(prefs.getString(Constants.PARAM_USER_DETAILS) ?? ""));
    }
  }

  Future<bool> setUserDetails(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_USER_DETAILS, response ?? "");
  }

  Future<UserEvents?> getEventDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(Constants.PARAM_EVENT_DETAILS) == null) {
      return null;
    } else {
      return UserEvents.fromJson(
          json.decode(prefs.getString(Constants.PARAM_EVENT_DETAILS) ?? ""));
    }
  }

  Future<bool> setEventDetails(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_EVENT_DETAILS, response ?? "");
  }
  Future<bool> setUserEventId(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_EVENT_ID, response ?? "");
  }

  Future<String?> getUserEventId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(Constants.PARAM_EVENT_ID);
  }
  Future<bool> setFcmToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_FCM_TOKEN, token ?? "");
  }

  Future<String?> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_FCM_TOKEN);
  }
  Future<bool> setUserEventName(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_EVENT_NAME, response ?? "");
  }

  Future<String?> getUserEventName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_EVENT_NAME);
  }
  Future<bool> setShowBadge(bool? flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(Constants.PARAM_SHOW_BADGE, flag ?? false);
  }

  Future<bool?> getShowBadge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.PARAM_SHOW_BADGE);
  }

  Future<bool> setUserId(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_USER_ID, response ?? "");
  }


  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_USER_ID);
  }

  Future<bool> setVenueLink(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_VENUE, response ?? "");
  }


  Future<String?> getVenueLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_VENUE);
  }

  Future<bool> setAwardLink(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_AWARDS, response ?? "https://www.projectcontrolexpo.com/usa/awards-mobile-app");
  }


  Future<String?> getAwardLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_AWARDS);
  }

  Future<bool> setContactLink(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_CONTACT, response ?? "https://www.projectcontrolexpo.com/usa/contact-us-mobile-app");
  }


  Future<String?> getContactLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_CONTACT);
  }

  Future<bool> setMapLink(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_MAP, response ?? "https://www.google.com/maps?ll=38.87301,-77.007433&z=16&t=m&hl=en&gl=IN&mapclient=embed&cid=6988172398827564427");
  }


  Future<String?> getMapLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_MAP);
  }
  Future<bool> setDirectionLink(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_DIRECTION, response ?? "http://maps.google.com/maps?q=loc:38.8731770566754,-77.00742227123324");
  }
  Future<String?> getDirectionLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_DIRECTION);
  }
  Future<bool> setFaqLink(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_FAQ, response ?? "https://www.projectcontrolexpo.com/usa/awards-mobile-app");
  }
  Future<String?> getFaqLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_FAQ);
  }
  Future<bool> setSponserLink(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_APP_SPONSOR, response ?? "");
  }
  Future<String?> getSponserLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_APP_SPONSOR);
  }

  Future<bool> setProfileUrl(String? response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(Constants.PARAM_MY_PROFILE_URL, response ?? "");
  }
  Future<String?> getProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.PARAM_MY_PROFILE_URL);
  }

  Future<dynamic> get(String url) async {
    var responseJson;
    var isConnected;
    try {
      isConnected = await isInternet();
      if (isConnected) {
        //setAuthToken();

        LoginResponse? loginResponse = await getUserDetails();
        _dio.options.headers["Authorization"] =
            "Bearer ${loginResponse?.data?.userId}";

        final response = await _dio.get(_baseUrl + url);
        if (response.statusCode == 200) {
          responseJson = response.data;
        } else {
          responseJson = _response(response);
        }
      } else {
        throw FetchDataException('No Internet connection');
      }
    } catch (error) {
      if (!isConnected) {
        throw FetchDataException('No Internet connection');
      } else {
        throw FetchDataException('$error');
      }
    }
    return responseJson;
  }

  void setAuthToken() async {
    LoginResponse? response = await getUserDetails();
    _dio.options.headers["Authorization"] = response?.data?.userId ?? "";
  }

  Future<dynamic> getQueryParam(String url, String queryParam) async {
    var responseJson;
    var isConnected;
    try {
      isConnected = await isInternet();
      if (isConnected) {
        setAuthToken();
        final response = await _dio.get(_baseUrl + url + "/" + queryParam);
        if (response.statusCode == 200) {
          responseJson = response.data;
        } else {
          responseJson = _response(response);
        }
      } else {
        throw FetchDataException('No Internet connection');
      }
    } on DioError catch (error) {
      if (!isConnected) {
        throw FetchDataException('No Internet connection');
      } else {
        throw FetchDataException(
            error.response?.data["message"] ?? 'Network error!');
      }
    }
    return responseJson;
  }

  Future<dynamic> getQueryParamKeyValue(
      String url, String key, String value) async {
    var responseJson;
    var isConnected;
    try {
      isConnected = await isInternet();
      if (isConnected) {
        setAuthToken();
        final response =
            await _dio.get(_baseUrl + url + "?" + key + "=" + value);
        if (response.statusCode == 200) {
          responseJson = response.data;
        } else {
          responseJson = _response(response);
        }
      } else {
        throw FetchDataException('No Internet connection');
      }
    } on DioError catch (error) {
      if (!isConnected) {
        throw FetchDataException('No Internet connection');
      } else {
        throw FetchDataException(
            error.response?.data["message"] ?? 'Network error!');
      }
    }
    return responseJson;
  }

  Future<dynamic> put(String url, Map<String, dynamic>? body) async {
    var responseJson;
    var isConnected;
    try {
      isConnected = await isInternet();
      if (isConnected) {
        //setAuthToken();
        LoginResponse? loginResponse = await getUserDetails();
        _dio.options.headers["Authorization"] =
            "Bearer ${loginResponse?.data?.userId}";

        final response = await _dio.put(_baseUrl + url, data: body);
        if (response.statusCode == 200) {
          responseJson = response.data;
        } else {
          responseJson = _response(response);
        }
      } else {
        throw FetchDataException('No Internet connection');
      }
    } on DioError catch (error) {
      if (!isConnected) {
        throw FetchDataException('No Internet connection');
      } else {
        throw FetchDataException(
            error.response?.data["message"] ?? 'Network error!');
      }
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic>? body) async {
    var responseJson;
    var isConnected;
    try {
      isConnected = await isInternet();
      if (isConnected) {
        //setAuthToken();
        LoginResponse? loginResponse = await getUserDetails();
        _dio.options.headers["Authorization"] =
            "Bearer ${loginResponse?.data?.userId}";

        final response = await _dio.post(_baseUrl + url,
            options: Options(
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
                headers: {'Authorization': 'Bearer ${loginResponse?.data?.userId}'}
            ),
            data: body);
        if (response.statusCode == 200) {
          responseJson = response.data;
        } else {
          responseJson = _response(response);
        }
      } else {
        throw FetchDataException('No Internet connection');
      }
    } on DioError catch (error) {
      if (!isConnected) {
        throw FetchDataException('No Internet connection');
      } else {
        throw FetchDataException(
            error.response?.data["message"] ?? 'Network error!');
      }
    }
    return responseJson;
  }

  Future<dynamic> uploadImage(String url, File? body,String userId,{Map<String,File>? jsonBody}) async {
    var responseJson;
    var isConnected;
    try {
      isConnected = await isInternet();
      if (isConnected) {
        //setAuthToken();
        LoginResponse? loginResponse = await getUserDetails();
        _dio.options.headers["Authorization"] = "Bearer ${loginResponse?.data?.userId}";
          _dio.options.headers["Content-Type"] = "multipart/form-data";
        String fileName = body!.path.split('/').last;
        FormData formData = FormData.fromMap({
          "user_id": userId,
          "attachment":
          await MultipartFile.fromFile(body.path, filename:fileName //important
          ),
        });
          final response = await _dio.post(_baseUrl + url, data: formData);
        if (response.statusCode == 200) {
          responseJson = response.data;
        } else {
          responseJson = _response(response);
        }
      } else {
        throw FetchDataException('No Internet connection');
      }
    } on DioError catch (error) {
      if (!isConnected) {
        throw FetchDataException('No Internet connection');
      } else {
        throw FetchDataException(
            error.response?.data["message"] ?? 'Network error!');
      }
    }
    return responseJson;
  }

  Future<dynamic> postFormData(String url, FormData body) async {
    var responseJson;
    var isConnected;
    try {
      isConnected = await isInternet();
      if (isConnected) {
        setAuthToken();
        final response = await _dio.post(_baseUrl + url, data: body);
        if (response.statusCode == 200) {
          responseJson = response.data;
        } else {
          responseJson = _response(response);
        }
      } else {
        throw FetchDataException('No Internet connection');
      }
    } on DioError catch (error) {
      if (!isConnected) {
        throw FetchDataException('No Internet connection');
      } else {
        throw FetchDataException(
            error.response?.data["message"] ?? 'Network error!');
      }
    }
    return responseJson;
  }

  dynamic _response(Response response) {
    switch (response.statusCode) {
      case 400:
        throw BadRequestException('Bad request');
      case 401:
      case 403:
        throw UnauthorisedException('Unauthorized');
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<bool> isInternet() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        final result = await DataConnectionChecker().hasConnection;
        return result;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
