import 'package:flutter/material.dart';

class PersonalInformationModel {
  PersonalInformationModel({
    required this.customerID,
    required this.registeredAddress,
    required this.currentAddress,
    required this.officeAddress,
    required this.occupation,
    required this.firstBankAccount,
    // required this.currentType,
    // required this.officeType,
  });
  final String customerID;
  final AddressModel registeredAddress;
  final OccupationModel occupation;
  final BankAccountModel firstBankAccount;
  // final String currentType;
  // final String officeType;
  AddressModel currentAddress;
  AddressModel officeAddress;
  BankAccountModel? secondBankAccount;
}

class AddressModel {
  AddressModel({
    // required this.homenumber,
    // // required this.subDistrictName,
    // required this.zipcode,
    // required this.countryName,
    // required this.typeOfAddress,
    required this.controller,
    required this.condition,
  });

  // String homenumber;
  // String? villageNumber;
  // String? villageName;
  // String? subStreetName;
  // String? streetName;
  String? subDistrictName;
  String? districtName;
  String? provinceName;
  String? typeOfAddress;
  // int zipcode;
  // String countryName;
  // String typeOfAddress;
  Controller controller;
  Condition condition;
}

class BankAccountModel {
  BankAccountModel({
    required this.bankName,
    required this.bankAccountID,
    required this.serviceType,
  });
  String bankName;
  String? bankBranchName;
  String bankAccountID;
  String serviceType;
}

class OccupationModel {
  OccupationModel({
    required this.sourceOfIncome,
    required this.currentOccupation,
    required this.officeName,
    required this.positionName,
    required this.typeOfBusiness,
    required this.salaryRange,
  });

  String sourceOfIncome;
  String currentOccupation;
  String officeName;
  String typeOfBusiness;
  String positionName;
  String salaryRange;
}

class Condition {
  Condition({
    required this.homenumber,
    required this.subdistrict,
    required this.district,
    required this.province,
    required this.zipcode,
    required this.country,
  });
  bool homenumber;
  bool subdistrict;
  bool district;
  bool province;
  bool zipcode;
  bool country;
}
class Controller {
  Controller({
    required this.homenumber,
    required this.villageNumber,
    required this.villageName,
    required this.subStreetName,
    required this.streetName,
    // required this.subdistrict,
    // required this.district,
    // required this.province,
    required this.zipcode,
    required this.country,
  });
  TextEditingController homenumber;
  TextEditingController villageNumber;
  TextEditingController villageName;
  TextEditingController subStreetName;
  TextEditingController streetName;
  // TextEditingController subdistrict;
  // TextEditingController district;
  // TextEditingController province;
  TextEditingController zipcode;
  TextEditingController country;
}
