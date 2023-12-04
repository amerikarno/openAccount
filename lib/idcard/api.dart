import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:ico_open/config/config.dart';
import 'package:ico_open/model/idcard.dart';

// dynamic data;

Future<bool> getVerifiedIDCard(String idcard) async {
  bool isIDcardCorrect = false;

  final url = Uri(
    scheme: "http",
    host: host,
    port: 1323,
    path: "api/v1/idcard/$idcard",
  );
  log('start api to get verify idcard...');
  final response = await http.get(url).timeout(const Duration(seconds: 1));
  final data = jsonDecode(response.body);
  log('status code: ${response.statusCode}');
  log('data: $data');
  if (response.statusCode == 200) {
    isIDcardCorrect = data;
  }

  log('provinces: $isIDcardCorrect');
  // log('end get provinces data, total: ${provinces.length} ');

  // return provinces;
  return Future.delayed(
    const Duration(microseconds: 500),
    () => isIDcardCorrect,
  );
}

Future<String> postIDCard(IDcardModel idCard) async {
  final url = Uri(
    scheme: "http",
    host: host,
    port: 1323,
    path: "api/v1/idcard",
  );
  log('start post data...');
  log('data: ${idCard.birthdate}\n${idCard.status}\n${idCard.idcard}\n${idCard.laserCode}\n');

  final response = await http
      .post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          <String, dynamic>{
            'thTitle': idCard.thtitle,
            'thName': idCard.thname,
            'thSurname': idCard.thsurname,
            'engTitle': idCard.engtitle,
            'engName': idCard.engname,
            'engSurname': idCard.engsurname,
            'email': idCard.email,
            'mobile': idCard.mobile,
            'agreement': idCard.agreement,
            'birthDate': idCard.birthdate,
            'marriageStatus': idCard.status,
            'idCard': idCard.idcard,
            'laserCode': idCard.laserCode,
          },
        ),
      );
      // .timeout(const Duration(microseconds: 500));
  log('end of post data processing');
  if (response.statusCode == 200) {
    log('id card: ${response.body}');
    return response.body;
  }

  return '';
}

// Future<List<String>> getTambon(String? amphure) async {
// List<String> tambons = [];

//   final url = Uri(
//     scheme: "http",
//     host: host,
//     port: 1323,
//     path: "api/v1/tambons/$amphure",
//   );
//   log('start api to get tambons data...');
//   final response = await http.get(url).timeout(const Duration(seconds: 1));
//   final data = jsonDecode(response.body);
//   log('status code: ${response.statusCode}');
//   log('data: $data');
//   if (response.statusCode == 200) {
//     for (var i in data) {
//       tambons.add(i);
//     }
//     log('tambons: $tambons');
//     log('end get tambons data, total: ${tambons.length} ');
//     return tambons;
//   }

//   return [];
// }

// Future<String> getZipCode(String? zipname) async {
// String? zipcode;

//   final url = Uri(
//     scheme: "http",
//     host: host,
//     port: 1323,
//     path: "api/v1/zipcode/$zipname",
//   );
//   log('start api to get zipcode data...$zipname');
//   final response = await http.get(url).timeout(const Duration(seconds: 1));
//   final data = jsonDecode(response.body);
//   log('status code: ${response.statusCode}');
//   log('data: $data');
//   if (response.statusCode == 200) {
//     zipcode = data.toString();
//     log('zipcode: $zipcode');
//     return zipcode;
//   }

//   return '';
// }
