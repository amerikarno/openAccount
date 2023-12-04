import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:ico_open/config/config.dart';
import 'package:ico_open/model/model.dart';
import 'package:ico_open/model/personal_info.dart';
import 'package:ico_open/personal_info/page.dart';

// dynamic data;

Future<List<String>> getProvince() async {
  List<String> provinces = [];

  final url = Uri(
    scheme: "http",
    host: host,
    port: 1323,
    path: "api/v1/all_provinces",
  );
  log('start api to get provinces data...');
  final response = await http.get(url).timeout(const Duration(seconds: 1));
  final data = jsonDecode(response.body);
  log('status code: ${response.statusCode}');
  log('data: $data');
  if (response.statusCode == 200) {
    for (var i in data) {
      provinces.add(i);
    }
  }

  log('provinces: $provinces');
  log('end get provinces data, total: ${provinces.length} ');

  // return provinces;
  return Future.delayed(
    const Duration(microseconds: 500),
    () => provinces,
  );
}

Future<List<String>> getAmphure(String? province) async {
  List<String> amphures = [];

  final url = Uri(
    scheme: "http",
    host: host,
    port: 1323,
    path: "api/v1/amphures/$province",
  );
  log('start api to get amphures data...');
  final response = await http.get(url).timeout(const Duration(seconds: 1));
  final data = jsonDecode(response.body);
  log('status code: ${response.statusCode}');
  log('data: $data');
  if (response.statusCode == 200) {
    for (var i in data) {
      amphures.add(i);
    }
    log('amphures: $amphures');
    log('end get amphures data, total: ${amphures.length} ');
    return amphures;
  }

  return [];
}

Future<List<String>> getTambon(String? amphure) async {
  List<String> tambons = [];

  final url = Uri(
    scheme: "http",
    host: host,
    port: 1323,
    path: "api/v1/tambons/$amphure",
  );
  log('start api to get tambons data...');
  final response = await http.get(url).timeout(const Duration(seconds: 1));
  final data = jsonDecode(response.body);
  log('status code: ${response.statusCode}');
  log('data: $data');
  if (response.statusCode == 200) {
    for (var i in data) {
      tambons.add(i);
    }
    log('tambons: $tambons');
    log('end get tambons data, total: ${tambons.length} ');
    return tambons;
  }

  return [];
}

Future<String> getZipCode(String? zipname) async {
  String? zipcode;

  final url = Uri(
    scheme: "http",
    host: host,
    port: 1323,
    path: "api/v1/zipcode/$zipname",
  );
  log('start api to get zipcode data...$zipname');
  final response = await http.get(url).timeout(const Duration(seconds: 1));
  final data = jsonDecode(response.body);
  log('status code: ${response.statusCode}');
  log('data: $data');
  if (response.statusCode == 200) {
    zipcode = data.toString();
    log('zipcode: $zipcode');
    return zipcode;
  }

  return '';
}

Future<String> postPersonalInfo(PersonalInformationModel personalInfo) async {
  // List<AddressModel>? addresses;
  // addresses!.add(personalInfo.registeredAddress);
  // addresses.add(personalInfo.currentAddress!);
  // addresses.add(personalInfo.officeAddress!);
  // List<BankAccountModel>? bankAccounts;
  // bankAccounts!.add(personalInfo.firstBankAccount);
  // bankAccounts.add(personalInfo.secondBankAccount!);

  final url = Uri(
    scheme: "http",
    host: host,
    port: 1323,
    path: "api/v1/personalInformation",
  );
  final String secondBankAccount;
  if (personalInfo.secondBankAccount?.bankName == null) {

  }
   log('start post data...');
  log('data: ${personalInfo.registeredAddress}\n${personalInfo.currentAddress}\n${personalInfo.officeAddress}\n${personalInfo.firstBankAccount}\n');
final _body = jsonEncode(
      <String, dynamic>{
        // 'thTitle': personalInfo.thtitle,
        'cid': personalInfo.customerID,
        'registeredAddress': {
          'homeNumber': personalInfo.registeredAddress.controller.homenumber.text,
          'villageNumber': personalInfo.registeredAddress.controller.villageNumber.text,
          'villageName': personalInfo.registeredAddress.controller.villageName.text,
          'subStreetName': personalInfo.registeredAddress.controller.subStreetName.text,
          'streetName': personalInfo.registeredAddress.controller.streetName.text,
          'subDistrictName': personalInfo.registeredAddress.subDistrictName,
          'districtName': personalInfo.registeredAddress.districtName,
          'provinceName': personalInfo.registeredAddress.provinceName,
          'zipCode': personalInfo.registeredAddress.controller.zipcode.text,
          'countryName': personalInfo.registeredAddress.controller.country.text,
          // 'typeOfAddress': personalInfo.registeredAddress.typeOfAddress,
        },
        'currentAddress': {
          'homeNumber': personalInfo.currentAddress.controller.homenumber.text,
          'villageNumber': personalInfo.currentAddress.controller.villageNumber.text,
          'villageName': personalInfo.currentAddress.controller.villageName.text,
          'subStreetName': personalInfo.currentAddress.controller.subStreetName.text,
          'streetName': personalInfo.currentAddress.controller.streetName.text,
          'subDistrictName': personalInfo.currentAddress.subDistrictName,
          'districtName': personalInfo.currentAddress.districtName,
          'provinceName': personalInfo.currentAddress.provinceName,
          'zipCode': personalInfo.currentAddress.controller.zipcode.text,
          'countryName': personalInfo.currentAddress.controller.country.text,
          'typeOfAddress': personalInfo.currentAddress.typeOfAddress,
        },
        'officeAddress': {
          'homeNumber': personalInfo.officeAddress.controller.homenumber.text,
          'villageNumber': personalInfo.officeAddress.controller.villageNumber.text,
          'villageName': personalInfo.officeAddress.controller.villageName.text,
          'subStreetName': personalInfo.officeAddress.controller.subStreetName.text,
          'streetName': personalInfo.officeAddress.controller.streetName.text,
          'subDistrictName': personalInfo.officeAddress.subDistrictName,
          'districtName': personalInfo.officeAddress.districtName,
          'provinceName': personalInfo.officeAddress.provinceName,
          'zipCode': personalInfo.officeAddress.controller.zipcode.text,
          'countryName': personalInfo.officeAddress.controller.country.text,
          'typeOfAddress': personalInfo.officeAddress.typeOfAddress,
        },
        'occupation': {
          'sourceOfIncome': personalInfo.occupation.sourceOfIncome,
          'currentOccupation': personalInfo.occupation.currentOccupation,
          'officeName': personalInfo.occupation.officeName,
          'typeOfBusiness': personalInfo.occupation.typeOfBusiness,
          'positionName': personalInfo.occupation.positionName,
          'salaryRange': personalInfo.occupation.salaryRange,
        },
        'firstBankAccount': {
          'bankName': personalInfo.firstBankAccount.bankName,
          'bankBranchName': personalInfo.firstBankAccount.bankBranchName,
          'bankAccountNumber': personalInfo.firstBankAccount.bankAccountID,
          'accountType': personalInfo.firstBankAccount.serviceType,
        },
        'secondBankAccount': {
          'bankName': (personalInfo.secondBankAccount?.bankName != null) ? personalInfo.secondBankAccount!.bankName : '',
          'bankBranchName': (personalInfo.secondBankAccount?.bankBranchName != null) ? personalInfo.secondBankAccount!.bankBranchName : '',
          'bankAccountNumber': (personalInfo.secondBankAccount?.bankAccountID != null) ? personalInfo.secondBankAccount!.bankAccountID : '',
          'accountType': (personalInfo.secondBankAccount?.serviceType != null) ? personalInfo.secondBankAccount!.serviceType : '',
        }
      },
    );
    try {
   final response = await http.post(
    url,
    headers: <String, String>{
      "Content-Type": "application/json",
    },
    body: _body
  ).timeout(const Duration(microseconds: 500));
  log(_body);
  // .timeout(const Duration(microseconds: 500));
  log('end of post data processing');
  if (response.statusCode == 200) {
    log('id card: ${response.body}');
    return response.body;
  }
    } catch (e) {
      print(e);
    }

  return '';
}
