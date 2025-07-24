// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:get/get.dart' as gets;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_screen.dart';

import 'auth_apis.dart';
import '../configs.dart';
import '../main.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';

Map<String, String> buildHeaderTokens({
  Map? extraKeys,
  String? endPoint,
}) {
  /// Initialize & Handle if key is not present
  if (extraKeys == null) {
    extraKeys = {};
    extraKeys.putIfAbsent('isFlutterWave', () => false);
    extraKeys.putIfAbsent('isAirtelMoney', () => false);
  }

  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
    'Accept': "application/json",
    'global-localization': selectedLanguageCode.value,
    'User-Agent': getUserAgent(),
  };

  if (endPoint == APIEndPoints.register) {
    header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json');
  }
  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');

  if (isLoggedIn.value && extraKeys.containsKey('isFlutterWave') && extraKeys['isFlutterWave']) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer ${extraKeys!['flutterWaveSecretKey']}");
  } else if (isLoggedIn.value && extraKeys.containsKey('isAirtelMoney') && extraKeys['isAirtelMoney']) {
    header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${extraKeys!['access_token']}');
    header.putIfAbsent('X-Country', () => '${extraKeys!['X-Country']}');
    header.putIfAbsent('X-Currency', () => '${extraKeys!['X-Currency']}');
  } else if ((getBoolAsync(SharedPreferenceConst.IS_LOGGED_IN) || isLoggedIn.value) && loginUserData.value.apiToken.isNotEmpty) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${loginUserData.value.apiToken}');
  }

  return header;
}

Uri buildBaseUrl(String endPoint, {bool manageApiVersion = false}) {
  final String newEndPoint = manageApiVersion ? 'v$API_VERSION/$endPoint' : endPoint;
  if (!newEndPoint.startsWith('http')) {
    return Uri.parse('$BASE_URL$newEndPoint');
  } else {
    return Uri.parse(newEndPoint);
  }
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  Map? extraKeys,
  Map<String, String>? header,
  bool manageApiVersion = false,
}) async {
  var headers = header ?? buildHeaderTokens(extraKeys: extraKeys, endPoint: endPoint);
  Uri url = buildBaseUrl(endPoint, manageApiVersion: manageApiVersion);

  Response response;

  try {
    if (method == HttpMethodType.POST) {
      response = await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }
    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body.trim(),
      methodType: method.name,
    );

    //Todo manage deleted account case
    // gets.Get.offAll(() => SignInScreen(showBackButton: false), arguments: true);

    if (isLoggedIn.value && response.statusCode == 401 && !endPoint.startsWith('http')) {
      return await reGenerateToken().then((value) async {
        return await buildHttpResponse(
          endPoint,
          method: method,
          request: request,
          extraKeys: extraKeys,
          manageApiVersion: manageApiVersion,
        );
      }).catchError((e) {
        throw errorSomethingWentWrong;
      });
    } else {
      return response;
    }
  } on Exception catch (e) {
    if (e is SocketException) {
      log('SocketException: ${e.toString()}');
      throw errorInternetNotAvailable;
    } else if (e is TimeoutException) {
      log('TimeoutException: ${e.toString()}');
      throw locale.value.gatewayTimeout;
    } else {
      log('Unknown Exception: ${e.toString()}');
      throw errorSomethingWentWrong;
    }
  }
}

Future<void> reGenerateToken() async {
  AuthServiceApis.clearData();
  gets.Get.offAll(() => DashboardScreen(dashboardController: getDashboardController()));
}

Future handleResponse(
  Response response, {
  HttpResponseType httpResponseType = HttpResponseType.JSON,
  bool? avoidTokenError,
  bool? isFlutterWave,
}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode.isSuccessful()) {
    if (response.body.trim().isJson()) {
      Map body = jsonDecode(response.body.trim());

      if (body.containsKey('status')) {
        if (isFlutterWave.validate()) {
          if (body['status'] == 'success') {
            return body;
          } else {
            throw body['message'] ?? errorSomethingWentWrong;
          }
        } else {
          if (body['status']) {
            return body;
          } else {
            throw body['message'] ?? errorSomethingWentWrong;
          }
        }
      } else {
        return body;
      }
    } else {
      throw errorSomethingWentWrong;
    }
  } else if (response.statusCode == 400) {
    BaseResponseModel baseResponseModel = BaseResponseModel.fromJson(jsonDecode(response.body.trim()));
    if (baseResponseModel.message.isNotEmpty) {
      throw baseResponseModel.message;
    } else {
      throw locale.value.badRequest;
    }
  } else if (response.statusCode == 403) {
    throw locale.value.forbidden;
  } else if (response.statusCode == 429) {
    throw locale.value.tooManyRequests;
  } else if (response.statusCode == 500) {
    throw locale.value.internalServerError;
  } else if (response.statusCode == 502) {
    throw locale.value.badGateway;
  } else if (response.statusCode == 503) {
    throw locale.value.serviceUnavailable;
  } else if (response.statusCode == 504) {
    throw locale.value.gatewayTimeout;
  } else {
    Map body = jsonDecode(response.body.trim());
    if (body.containsKey('status') && body['status']) {
      return body;
    } else {
      Map<String, dynamic> errorData = {
        'status_code': response.statusCode,
        "response": body,
        "message": body['message'] ?? body['error'] ?? errorSomethingWentWrong,
      };
      throw errorData;
    }
  }
}

//region CommonFunctions
Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
  Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(String, Response)? onError}) async {
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  apiPrint(
    url: multiPartRequest.url.toString(),
    headers: jsonEncode(multiPartRequest.headers),
    multipartRequest: {
      "MultiPart Request fields": multiPartRequest.fields,
      "MultiPart files": multiPartRequest.files
          .map(
            (e) => {
              e.field: "${e.filename}",
            },
          )
          .toList(),
    },
    statusCode: response.statusCode,
    responseBody: response.body.trim(),
    methodType: "MultiPart",
  );

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body.trim());
  } else if (isLoggedIn.value && response.statusCode == 401) {
    await reGenerateToken().then((value) async {
      await sendMultiPartRequest(multiPartRequest);
    }).catchError((e) {
      throw errorSomethingWentWrong;
    });
  } else {
    String error = '';
    if (jsonDecode(response.body) is Map<String, dynamic>) {
      Map<String, dynamic> errorData = jsonDecode(response.body);
      if (errorData.containsKey('message')) {
        error = errorData['message'];
      } else if (errorData.containsKey('error')) {
        error = errorData['error'];
      } else if (errorData.containsKey('data') && errorData['data'] is Map<String, dynamic>) {
        errorData = errorData['data'];
        if (errorData.containsKey('message')) {
          error = errorData['message'];
        }
      } else {
        error = errorSomethingWentWrong;
      }
      onError?.call(error, response);
    } else {
      onError?.call(errorSomethingWentWrong, response);
    }
  }
}

Future<List<MultipartFile>> getMultipartImages2({required List<XFile> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<XFile>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('$name[${i.toString()}]', element.path.validate()));
    log('MultipartFile: $name[${i.toString()}]');
  });

  return multiPartRequest;
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodType = "",
  bool fullLog = false,
  Map? multipartRequest,
}) {
  if (fullLog) {
    dev.log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    dev.log("\u001b[93m Url: \u001B[39m $url");
    dev.log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    dev.log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (request.isNotEmpty) {
      dev.log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    if (multipartRequest != null) {
      dev.log("\u001b[95m Multipart Request: \u001B[39m");
      multipartRequest.forEach((key, value) {
        dev.log("\u001b[96m$key:\u001B[39m $value\n");
      });
    }
    dev.log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    dev.log('Response ($methodType) $statusCode: $responseBody');
    dev.log("\u001B[0m");
    dev.log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  } else {
    log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    log("\u001b[93m Url: \u001B[39m $url");
    log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (request.isNotEmpty) {
      log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    if (multipartRequest != null) {
      log("\u001b[95m Multipart Request: \u001B[39m");
      multipartRequest.forEach((key, value) {
        log("\u001b[96m$key:\u001B[39m $value\n");
      });
    }
    log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    log('Response ($methodType) $statusCode: ${formatJson(responseBody)}');
    log("\u001B[0m");
    log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  }
}

String formatJson(String jsonStr) {
  try {
    final dynamic parsedJson = jsonDecode(jsonStr);
    const formatter = JsonEncoder.withIndent('  ');
    return formatter.convert(parsedJson);
  } on Exception catch (e) {
    dev.log("\x1b[31m formatJson error ::-> ${e.toString()} \x1b[0m");
    return jsonStr;
  }
}

Map<String, String> defaultHeaders() {
  Map<String, String> header = {};

  header.putIfAbsent(HttpHeaders.cacheControlHeader, () => 'no-cache');
  header.putIfAbsent('Access-Control-Allow-Headers', () => '*');
  header.putIfAbsent('Access-Control-Allow-Origin', () => '*');

  return header;
}

Map<String, String> buildHeaderForFlutterWave(String flutterWaveSecretKey) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");

  return header;
}

String getUserAgent() {
  String userAgent;

  switch (Platform.operatingSystem) {
    case 'android':
      userAgent = 'FlutterAndroidApp/1.0 (Android)';
      break;
    case 'ios':
      userAgent = 'FlutteriOSApp/1.0 (iOS)';
      break;
    default:
      userAgent = 'FlutterApp/1.0 (Unknown)';
      break;
  }

  return userAgent;
}