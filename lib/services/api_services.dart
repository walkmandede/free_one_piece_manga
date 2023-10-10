import 'dart:convert';
import 'dart:io';
// import 'package:dio/dio.dart' as dio;
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../modules/common/c_data_controller.dart';
import '../utils/custom_dialog.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class ApiServices {
  static const String baseUrl = 'https://api.farytaxi.com/api/';
  DataController dataController = Get.find();

  void validateResponse(
      {required Response? response,
      required Function(Map<String, dynamic>) onSuccess,
      required Function(Map<String, dynamic>) onFailure,
      bool xShowDialog = true}) {
    if (xShowDialog) {
      try {} catch (e) {
        null;
      }
    }

    if (response != null) {
      Map<String, dynamic> responseBody = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody['meta']['success']) {
          onSuccess(responseBody);
        } else {
          onFailure(responseBody);
        }
      } else {
        if (xShowDialog) {
          MyDialog().showAlertDialog(
              message: responseBody['meta']['messageMm']);
        }
        onFailure(responseBody);
      }
    } else {
      if (xShowDialog) {
        // MyDialog().showServerErrorDialog();
      }
      onFailure({});
    }
  }

  Future<bool> xHasInternet() async {
    bool xHasInternet = false;
    try {
      final result = await InternetAddress.lookup('farytaxi.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        xHasInternet = true;
      }
    } on SocketException catch (_) {
      xHasInternet = false;
    }
    return xHasInternet;
  }

  Response? responseConverter({required http.Response? response}) {
    if (response != null) {
      // superPrint(Response(
      //   bodyString: response.body.toString(),
      //   body: jsonDecode(response.body),
      //   statusCode: response.statusCode,
      // ));

      return Response(
        bodyString: response.body.toString(),
        body: jsonDecode(response.body),
        statusCode: response.statusCode,
      );
    } else {
      return null;
    }
  }

  Future<Response?> getEndPoints() async {
    http.Response? response;
    try {
      response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/walkmandede/xsphere_end_points/main/end_points.json'));
    } catch (e) {
      null;
    }
    return responseConverter(response: response);
  }

  Future<Response?> apiGetCall(
      {required String endPoint, bool xNeedToken = false}) async {
    http.Response? response;
    try {
      response = await http.get(Uri.parse('$baseUrl$endPoint'), headers: {
        'Access-Control-Allow-Origin': '*',
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
        if (xNeedToken) 'Authorization': 'Bearer ${dataController.apiToken}',
      });
    } catch (e) {
      superPrint(e);
    }
    return responseConverter(response: response);
  }

  Future<Response?> apiPostCall(
      {required String endPoint,
      bool xNeedToken = false,
      required var data}) async {
    http.Response? response;

    try {
      response =
          await http.post(Uri.parse('$baseUrl$endPoint'), body: data, headers: {
        'Access-Control-Allow-Origin': '*',
        'Accept': '*/*',
        // 'Content-Type': 'application/json; charset=UTF-8',
        if (xNeedToken) 'Authorization': 'Bearer ${dataController.apiToken}',
      });
    } catch (e) {
      superPrint(e);
    }
    // return response;
    return responseConverter(response: response);
  }

  Future<Response?> apiPutCall(
      {required String endPoint,
      bool xNeedToken = false,
      required var data}) async {
    http.Response? response;

    try {
      response =
          await http.put(Uri.parse('$baseUrl$endPoint'), body: data, headers: {
        'Access-Control-Allow-Origin': '*',
        'Accept': '*/*',
        // 'Content-Type': 'application/json; charset=UTF-8',
        if (xNeedToken) 'Authorization': 'Bearer ${dataController.apiToken}',
      });
    } catch (e) {
      superPrint(e);
    }
    // return response;
    return responseConverter(response: response);
  }

  var client = GetConnect(timeout: const Duration(seconds: 2000));
  Future<Response?> apiPostCallGet(
      {required String endPoint,
      bool xNeedToken = false,
      required var data}) async {
    // http.Response? response;
    print(data);
    Response? response;
    try {
      response = await client.post('$baseUrl$endPoint', data, headers: {
        'Access-Control-Allow-Origin': '*',
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
        if (xNeedToken) 'Authorization': 'Bearer ${dataController.apiToken}',
      });
      print(response);
      // response =
      //     await http.post(Uri.parse('$baseUrl$endPoint'), body: data, headers: {
      //   'Access-Control-Allow-Origin': '*',
      //   'Accept': '*/*',
      //   'Content-Type': 'application/json; charset=UTF-8',
      //   if (xNeedToken) 'Authorization': 'Bearer ${dataController.apiToken}',
      // });
    } catch (e) {
      superPrint(e);
    }
    return response;
    // return responseConverter(response: response);
  }

  Future<Response?> apiDeleteCall({
    required String endPoint,
    bool xNeedToken = false,
  }) async {
    http.Response? response;

    try {
      response = await http.delete(Uri.parse('$baseUrl$endPoint'), headers: {
        'Access-Control-Allow-Origin': '*',
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
        if (xNeedToken) 'Authorization': 'Bearer ${dataController.apiToken}',
      });
    } catch (e) {
      superPrint(e);
    }

    return responseConverter(response: response);
  }

  // Future<Response?> apiFormDataCall(
  //     {required String endPoint,
  //     bool xNeedToken = false,
  //     required Map<String, dynamic> data}) async {
  //   Response? response;
  //   try {
  //     dio.FormData formData = dio.FormData.fromMap(data);
  //     var dioClient = dio.Dio();
  //     print('form data');
  //
  //     var dioResponse = await dioClient.post('$baseUrl$endPoint',
  //         options:
  //             dio.Options(contentType: 'text/html; charset=utf-8', headers: {
  //           'Access-Control-Allow-Origin': '*',
  //           'Accept': '*/*',
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           if (xNeedToken)
  //             'Authorization': 'Bearer ${dataController.apiToken}',
  //         }),
  //         data: formData);
  //     superPrint(dioResponse, title: 'res');
  //     response = Response(
  //       statusCode: dioResponse.statusCode,
  //       headers: {},
  //       body: dioResponse.data,
  //     );
  //   } catch (e) {
  //     superPrint(e);
  //   }
  //   return response;
  // }
}

class ApiEndPoints {
  static const String registerRequestOtp = 'auth/user/register-request-otp';
}
