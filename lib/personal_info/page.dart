import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:ico_open/config/config.dart';
import 'package:ico_open/customer_evaluate/page.dart';
import 'package:ico_open/idcard/page.dart';
import 'package:ico_open/model/personal_info.dart' as modelPI;
import 'package:ico_open/model/model.dart' as model;
import 'package:ico_open/misc/misc.dart' as misc;
import 'package:ico_open/personal_info/bank_account.dart';
import 'package:ico_open/personal_info/api.dart' as api;
import 'package:ico_open/personal_info/occupation.dart';
import 'package:ico_open/personal_info/registered_address.dart';
import 'package:ico_open/personal_info/current_address.dart' as ca;
import 'package:ico_open/personal_info/registered_address_widget.dart';
import 'package:ico_open/personal_info/widgets.dart';
import 'package:logger/logger.dart';

// enum CurrentAddress { registered, others }

// const double displayWidth = 0.6;

class PersonalInformation extends StatefulWidget {
  final String id;
  const PersonalInformation({super.key, required this.id});
  // final model.Preinfo preinfo;

  @override
  State<StatefulWidget> createState() => _PersonalInformationState();
}

List<String> provinces = [];
List<String> cProvinces = [];
List<String> oProvinces = [];
// variables for personal addresses information.
// model.AddressModel? registeredAddress;
var registeredAddress = modelPI.AddressModel(
  controller: modelPI.Controller(
      homenumber: TextEditingController(),
      villageNumber: TextEditingController(),
      villageName: TextEditingController(),
      subStreetName: TextEditingController(),
      streetName: TextEditingController(),
      // subdistrict: TextEditingController(),
      // district: TextEditingController(),
      // province: TextEditingController(),
      zipcode: TextEditingController(),
      country: TextEditingController()),
  condition: modelPI.Condition(
    homenumber: false,
    subdistrict: false,
    district: false,
    province: false,
    zipcode: false,
    country: false,
  ),
);
var currentAddress = modelPI.AddressModel(
  controller: modelPI.Controller(
      homenumber: TextEditingController(),
      villageNumber: TextEditingController(),
      villageName: TextEditingController(),
      subStreetName: TextEditingController(),
      streetName: TextEditingController(),
      // subdistrict: TextEditingController(),
      // district: TextEditingController(),
      // province: TextEditingController(),
      zipcode: TextEditingController(),
      country: TextEditingController()),
  condition: modelPI.Condition(
    homenumber: false,
    subdistrict: false,
    district: false,
    province: false,
    zipcode: false,
    country: false,
  ),
);
var officeAddress = modelPI.AddressModel(
  controller: modelPI.Controller(
      homenumber: TextEditingController(),
      villageNumber: TextEditingController(),
      villageName: TextEditingController(),
      subStreetName: TextEditingController(),
      streetName: TextEditingController(),
      // subdistrict: TextEditingController(),
      // district: TextEditingController(),
      // province: TextEditingController(),
      zipcode: TextEditingController(),
      country: TextEditingController()),
  condition: modelPI.Condition(
    homenumber: false,
    subdistrict: false,
    district: false,
    province: false,
    zipcode: false,
    country: false,
  ),
);
var occupation = modelPI.OccupationModel(
  sourceOfIncome: '',
  currentOccupation: '',
  officeName: '',
  positionName: '',
  typeOfBusiness: '',
  salaryRange: '',
);
var firstBank = modelPI.BankAccountModel(
  bankName: '',
  bankAccountID: '',
  serviceType: 'dw',
);
var secondBank = modelPI.BankAccountModel(
  bankName: '',
  bankAccountID: '',
  serviceType: 'd',
);

enum SelectedCurrentAddressEnum { registered, current }

enum SelectedOfficeAddressEnum { registered, current, office }

enum IsAddedBankAccountsEnum { yes, no }

class _PersonalInformationState extends State<PersonalInformation> {
  @override
  void initState() {
    super.initState();
    getCurrentProvince();
  }

  double height = 10;
  // modelPI.AddressModel? registeredAddress;

  String? thProvinceValue;
  String? thAmphureValue;
  String? thTambonValue;
  String? zipcode;

  List<String> provinceItems = provinces;
  List<String> cProvinceItems = cProvinces;
  List<String> oProvinceItems = oProvinces;

  final thProvinceLable = 'จังหวัด';
  final thAmphureLable = 'เขตอำเภอ';
  List<String> amphureItems = [];
  List<String> cAmphureItems = [];
  List<String> oAmphureItems = [];
  final thTambonLable = 'แขวงตำบล';
  List<String> tambonItems = [];
  List<String> cTambonItems = [];
  List<String> oTambonItems = [];
  // controller variables
  final rHomeNumberController = TextEditingController();
  final rVillageNumberController = TextEditingController();
  final rVillageNameController = TextEditingController();
  final rSubStreetNameController = TextEditingController();
  final rStreetNameController = TextEditingController();
  final rZipCodeController = TextEditingController();
  final rCountryController = TextEditingController();
  final rOfficeNameController = TextEditingController();
  final rPositionNameController = TextEditingController();

// error condition
  final bool _villageNumberErrorCondition = false;
  final bool _villageNameErrorCondition = false;
  final bool _subStreetNameErrorCondition = false;
  final bool _streetNameErrorCondition = false;

  bool _loadingAmphure = true;
  bool _loadingTambon = true;
  bool _loadingZipcode = true;

  Function(String? value) tambonChangedFunction() {
    return (value) {
      if (value == null) {
        setState(() {
          registeredAddress.condition.subdistrict = true;
        });
      } else {
        setState(() {
          registeredAddress.subDistrictName = value;
          thTambonValue = value;
          registeredAddress.condition.subdistrict = false;
          getCurrentZipcode();
        });
      }
      if (_loadingZipcode) {
        return const CircularProgressIndicator();
      }
    };
  }

  Function(String? value) amphureChangedFunction() {
    return (value) {
      if (value == null) {
        registeredAddress.condition.district = true;
      } else {
        registeredAddress.condition.district = false;
        setState(() {
          registeredAddress.districtName = value;
          thAmphureValue = value;
          thTambonValue = null;
          getCurrentTambon();
        });
      }
      if (_loadingTambon) {
        return const CircularProgressIndicator();
      }
    };
  }

  Function(String? value) provinceChangedFunction() {
    return (value) {
      if (value == null) {
        setState(() {
          registeredAddress.condition.province = true;
        });
      } else {
        setState(
          () {
            registeredAddress.condition.province = false;
            registeredAddress.provinceName = value;
            registeredAddress.controller.country.text = 'ไทย';
            thProvinceValue = value;
            thAmphureValue = null;
            thTambonValue = null;
            getCurrentAmphure();
          },
        );
      }
      if (_loadingAmphure) {
        return const CircularProgressIndicator();
      }
    };
  }

  void getCurrentAmphure() async {
    amphureItems = await api.getAmphure(thProvinceValue);
    setState(() {
      _loadingAmphure = false;
    });
  }

  void getCurrentTambon() async {
    tambonItems = await api.getTambon(thAmphureValue);
    setState(() {
      _loadingTambon = false;
    });
  }

  void getCurrentProvince() async {
    provinces = await api.getProvince();
    setState(() {
      provinceItems = provinces;
    });
  }

  void getCurrentZipcode() async {
    final zipname = thProvinceValue! + thAmphureValue! + thTambonValue!;
    zipcode = await api.getZipCode(zipname);
    registeredAddress.controller.zipcode.text = zipcode!;
    setState(() {
      _loadingZipcode = false;
    });
  }

  // current address configuration
  SelectedCurrentAddressEnum? currentAddressEnum =
      SelectedCurrentAddressEnum.registered;
  String? cThProvinceValue;
  String? cThAmphureValue;
  String? cThTambonValue;
  String? cZipcode;
  Function(String? value) cTambonChangedFunction() {
    return (value) {
      if (value == null) {
        setState(() {
          currentAddress.condition.subdistrict = true;
        });
      } else {
        setState(() {
          currentAddress.subDistrictName = value;
          cThTambonValue = value;
          currentAddress.condition.subdistrict = false;
          cGetCurrentZipcode();
        });
      }
      if (_loadingZipcode) {
        return const CircularProgressIndicator();
      }
    };
  }

  Function(String? value) cAmphureChangedFunction() {
    return (value) {
      if (value == null) {
        currentAddress.condition.district = true;
      } else {
        currentAddress.condition.district = false;
        setState(() {
          currentAddress.districtName = value;
          cThAmphureValue = value;
          cThTambonValue = null;
          cGetCurrentTambon();
        });
      }
      if (_loadingTambon) {
        return const CircularProgressIndicator();
      }
    };
  }

  Function(String? value) cProvinceChangedFunction() {
    return (value) {
      if (value == null) {
        setState(() {
          currentAddress.condition.province = true;
        });
      } else {
        setState(
          () {
            currentAddress.condition.province = false;
            currentAddress.provinceName = value;
            currentAddress.controller.country.text = 'ไทย';
            cThProvinceValue = value;
            cThAmphureValue = null;
            cThTambonValue = null;
            cGetCurrentAmphure();
          },
        );
      }
      if (_loadingAmphure) {
        return const CircularProgressIndicator();
      }
    };
  }

  void cGetCurrentAmphure() async {
    cAmphureItems = await api.getAmphure(cThProvinceValue);
    setState(() {
      _loadingAmphure = false;
    });
  }

  void cGetCurrentTambon() async {
    cTambonItems = await api.getTambon(cThAmphureValue);
    setState(() {
      _loadingTambon = false;
    });
  }

  void cGetCurrentProvince() async {
    cProvinces = await api.getProvince();
    setState(() {
      cProvinceItems = cProvinces;
    });
  }

  void cGetCurrentZipcode() async {
    final czipname = cThProvinceValue! + cThAmphureValue! + cThTambonValue!;
    cZipcode = await api.getZipCode(czipname);
    currentAddress.controller.zipcode.text = cZipcode!;
    setState(() {
      _loadingZipcode = false;
    });
  }

  // office address configuration
  final officeNameController = TextEditingController();
  final positionNameController = TextEditingController();
  bool sourceOfIncomeCondition = false;
  bool officeNameCondition = false;
  bool positionNameCondition = false;
  bool currentOccupationCondition = false;
  bool typeOfBusinessCondition = false;
  bool salaryRangeCondition = false;
  SelectedOfficeAddressEnum? officeAddressEnum =
      SelectedOfficeAddressEnum.registered;
  String? oThProvinceValue;
  String? oThAmphureValue;
  String? oThTambonValue;
  String? oZipcode;
  Function(String? value) oTambonChangedFunction() {
    return (value) {
      if (value == null) {
        setState(() {
          officeAddress.condition.subdistrict = true;
        });
      } else {
        setState(() {
          officeAddress.subDistrictName = value;
          oThTambonValue = value;
          officeAddress.condition.subdistrict = false;
          oGetCurrentZipcode();
        });
      }
      if (_loadingZipcode) {
        return const CircularProgressIndicator();
      }
    };
  }

  Function(String? value) oAmphureChangedFunction() {
    return (value) {
      if (value == null) {
        officeAddress.condition.district = true;
      } else {
        officeAddress.condition.district = false;
        setState(() {
          officeAddress.districtName = value;
          oThAmphureValue = value;
          oThTambonValue = null;
          oGetCurrentTambon();
        });
      }
      if (_loadingTambon) {
        return const CircularProgressIndicator();
      }
    };
  }

  Function(String? value) oProvinceChangedFunction() {
    return (value) {
      if (value == null) {
        setState(() {
          officeAddress.condition.province = true;
        });
      } else {
        setState(
          () {
            officeAddress.condition.province = false;
            officeAddress.provinceName = value;
            officeAddress.controller.country.text = 'ไทย';
            oThProvinceValue = value;
            oThAmphureValue = null;
            oThTambonValue = null;
            oGetCurrentAmphure();
          },
        );
      }
      if (_loadingAmphure) {
        return const CircularProgressIndicator();
      }
    };
  }

  void oGetCurrentAmphure() async {
    oAmphureItems = await api.getAmphure(oThProvinceValue);
    setState(() {
      _loadingAmphure = false;
    });
  }

  void oGetCurrentTambon() async {
    oTambonItems = await api.getTambon(oThAmphureValue);
    setState(() {
      _loadingTambon = false;
    });
  }

  void oGetCurrentProvince() async {
    oProvinces = await api.getProvince();
    setState(() {
      oProvinceItems = oProvinces;
    });
  }

  void oGetCurrentZipcode() async {
    final ozipname = oThProvinceValue! + oThAmphureValue! + oThTambonValue!;
    oZipcode = await api.getZipCode(ozipname);
    officeAddress.controller.zipcode.text = oZipcode!;
    setState(() {
      _loadingZipcode = false;
    });
  }

  final List<String> _sourceOfIncomeItems = [
    'ลูกจ้าง/พนักงานเอกชน',
    'ข้าราชการ/พนักงานรัฐวิสาหกิจ',
    'เจ้าของกิจการ/ค้าขาย',
    'แม่บ้าน / พ่อบ้าน',
    'เกษียน',
    'นักลงทุน',
    'นักศึกษา',
    'อาชีพอิสระ',
    'ค้าอัญมณี',
    'ค้าของเก่า',
    'แลกเปลี่ยนเงินตรา',
    'บริการโอนเงิน',
    'คาสิโน/บ่อน',
    'ธุรกิจสถานบริการ',
    'ค้าอาวุธ',
    'นายหน้าจัดหางาน',
    'ธุรกิจนำเที่ยว',
  ];
  final List<String> _typeOfBusinessItems = [
    'ลูกจ้าง/พนักงานเอกชน',
    'ข้าราชการ/พนักงานรัฐวิสาหกิจ',
    'เจ้าของกิจการ/ค้าขาย',
    'แม่บ้าน / พ่อบ้าน',
    'เกษียน',
    'นักลงทุน',
    'นักศึกษา',
    'อาชีพอิสระ',
    'ค้าอัญมณี',
    'ค้าของเก่า',
    'แลกเปลี่ยนเงินตรา',
    'บริการโอนเงิน',
    'คาสิโน/บ่อน',
    'ธุรกิจสถานบริการ',
    'ค้าอาวุธ',
    'นายหน้าจัดหางาน',
    'ธุรกิจนำเที่ยว',
  ];
  final List<String> _salaryItems = [
    '< 15,000',
    '15,001 - 50,000',
    '50,001 - 100,000',
    '100,001 - 500,000',
    '500,001 - 1,000,000',
    '1,000,001 - 5,000,000',
    '> 5,000,000',
  ];

  //bank accounts configure
  IsAddedBankAccountsEnum? isAddedBankAccount = IsAddedBankAccountsEnum.no;
  String? firstBankNameValue;
  String? firstBankBranchNameValue;
  String? secondBankNameValue;
  String? secondBankBranchNameValue;

  List<String> bankNameItems = <String>[
    'กรุงเทพ',
    'กรุงไทย',
    'กรุงศรีอยุธยา',
    'กสิกรไทย',
    'ซีไอเอ็มบีไทย',
    'ทหารไทยธนชาต',
    'ไทยพาณิชย์',
    'ยูโอบี',
    'แลนด์ แอนด์ เฮาส์',
  ];

  List<String> bankBranchNameItems = <String>[
    'รายรับประจำ',
    'รายรับพิเศษ',
    'ค่าเช่า / ขายของ',
    'เงินโบนัส / เงินรางวัล',
    'กำไรจากการลงทุน',
    'เงินออม',
  ];

  final _firstbankAccountNumberController = TextEditingController();
  final _secondbankAccountNumberController = TextEditingController();

  bool firstBankNameCondition = false;
  bool secondBankNameCondition = false;
  bool firstBankBranchNameCondition = false;
  bool secondBankBranchNameCondition = false;
  bool firstBankAccountNumberCondition = false;
  bool secondBankAccountNumberCondition = false;


  @override
  Widget build(BuildContext context) {

    final rHomeNumberTextField = misc.importantTextField(
        textController: registeredAddress.controller.homenumber,
        errorTextCondition: registeredAddress.condition.homenumber,
        errorTextMessage: misc.thErrorTextFieldMessage(model.homeNumberSubject),
        subject: model.homeNumberSubject,
        filterPattern: RegExp(r'[0-9/-]'),
        onsubmittedFunction: (value) {
          registeredAddress.controller.homenumber.text = value;
        },
        onchangedFunction: (value) {
          if (value.isNotEmpty) {
            setState(() {
              registeredAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              registeredAddress.condition.homenumber = true;
            });
          }
        });

    final rVillageNumberTextField = misc.importantTextField(
        textController: registeredAddress.controller.villageNumber,
        errorTextCondition: _villageNumberErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.villageNoSubject),
        subject: model.villageNoSubject,
        filterPattern: model.numberfilter,
        onsubmittedFunction: (value) {
          setState(() {
            registeredAddress.controller.villageNumber.text = value;
          });
        },
        onTabFunction: () {
          if (registeredAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              registeredAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              registeredAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final rVillageNameTextField = misc.importantTextField(
        textController: registeredAddress.controller.villageName,
        errorTextCondition: _villageNameErrorCondition,
        errorTextMessage:
            misc.thErrorTextFieldMessage(model.villageNameSubject),
        subject: model.villageNameSubject,
        filterPattern: model.allfilter,
        onsubmittedFunction: (value) {
          setState(() {
            registeredAddress.controller.villageName.text = value;
          });
        },
        onTabFunction: () {
          if (registeredAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              registeredAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              registeredAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final rSubStreetNameTextField = misc.importantTextField(
        textController: registeredAddress.controller.subStreetName,
        errorTextCondition: _subStreetNameErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.subStreetSubject),
        subject: model.subStreetSubject,
        filterPattern: model.allfilter,
        onsubmittedFunction: (value) {
          setState(() {
            registeredAddress.controller.subStreetName.text = value;
          });
        },
        onTabFunction: () {
          if (registeredAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              registeredAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              registeredAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final rStreetNameTextField = misc.importantTextField(
        textController: registeredAddress.controller.streetName,
        errorTextCondition: _streetNameErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.streetSubject),
        subject: model.streetSubject,
        filterPattern: model.allfilter,
        onsubmittedFunction: (value) {
          setState(() {
            registeredAddress.controller.streetName.text = value;
          });
        },
        onTabFunction: () {
          if (registeredAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              registeredAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              registeredAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final rTambonDropdown = misc.dropdownButtonBuilderFunction(
      value: thTambonValue,
      label1: thTambonLable,
      label2: model.markImportant,
      items: tambonItems,
      condition: registeredAddress.condition.subdistrict,
      errorText: misc.thErrorTextFieldMessage(thTambonLable),
      onChanged: tambonChangedFunction(),
    );

    final rAmphureDropdown = misc.dropdownButtonBuilderFunction(
        value: thAmphureValue,
        label1: thAmphureLable,
        label2: model.markImportant,
        items: amphureItems,
        condition: registeredAddress.condition.district,
        errorText: misc.thErrorTextFieldMessage(thAmphureLable),
        onChanged: amphureChangedFunction());

    final rProvinceDropdown = misc.dropdownButtonBuilderFunction(
        value: thProvinceValue,
        label1: thProvinceLable,
        label2: model.markImportant,
        items: provinceItems,
        condition: registeredAddress.condition.province,
        errorText: misc.thErrorTextFieldMessage(thProvinceLable),
        onChanged: provinceChangedFunction());

    final rZipcodeTextField = misc.importantTextField(
        textController: registeredAddress.controller.zipcode,
        errorTextCondition: registeredAddress.condition.zipcode,
        errorTextMessage: misc.thErrorTextFieldMessage(model.zipcodeSubject),
        subject: model.zipcodeSubject,
        onsubmittedFunction: (value) {
          registeredAddress.controller.zipcode.text = value;
        },
        onchangedFunction: (value) {
          if (value.isNotEmpty) {
            setState(() {
              registeredAddress.condition.zipcode = false;
            });
          } else {
            setState(() {
              registeredAddress.condition.zipcode = true;
            });
          }
        },
        filterPattern: model.numberfilter);

    final rCountryTextField = misc.importantTextField(
        textController: registeredAddress.controller.country,
        errorTextCondition: registeredAddress.condition.country,
        errorTextMessage: misc.thErrorTextFieldMessage(model.countrySubject),
        subject: model.countrySubject,
        onsubmittedFunction: (value) {
          registeredAddress.controller.country.text = value;
        },
        onchangedFunction: (value) {
          if (value.isNotEmpty) {
            setState(() {
              registeredAddress.condition.country = false;
            });
          } else {
            setState(() {
              registeredAddress.condition.country = true;
            });
          }
        },
        filterPattern: model.allfilter);

    // current address variables

    final cHomeNumberTextField = misc.importantTextField(
        textController: currentAddress.controller.homenumber,
        errorTextCondition: currentAddress.condition.homenumber,
        errorTextMessage: misc.thErrorTextFieldMessage(model.homeNumberSubject),
        subject: model.homeNumberSubject,
        filterPattern: RegExp(r'[0-9/-]'),
        onsubmittedFunction: (value) {
          currentAddress.controller.homenumber.text = value;
        },
        onchangedFunction: (value) {
          if (value.isNotEmpty) {
            setState(() {
              currentAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              currentAddress.condition.homenumber = true;
            });
          }
        });

    final cVillageNumberTextField = misc.importantTextField(
        textController: currentAddress.controller.villageNumber,
        errorTextCondition: _villageNumberErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.villageNoSubject),
        subject: model.villageNoSubject,
        filterPattern: model.numberfilter,
        onsubmittedFunction: (value) {
          setState(() {
            currentAddress.controller.villageNumber.text = value;
          });
        },
        onTabFunction: () {
          if (currentAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              currentAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              currentAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final cVillageNameTextField = misc.importantTextField(
        textController: currentAddress.controller.villageName,
        errorTextCondition: _villageNameErrorCondition,
        errorTextMessage:
            misc.thErrorTextFieldMessage(model.villageNameSubject),
        subject: model.villageNameSubject,
        filterPattern: model.allfilter,
        onsubmittedFunction: (value) {
          setState(() {
            currentAddress.controller.villageName.text = value;
          });
        },
        onTabFunction: () {
          if (currentAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              currentAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              currentAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final cSubStreetNameTextField = misc.importantTextField(
        textController: currentAddress.controller.subStreetName,
        errorTextCondition: _subStreetNameErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.subStreetSubject),
        subject: model.subStreetSubject,
        filterPattern: model.allfilter,
        onsubmittedFunction: (value) {
          setState(() {
            currentAddress.controller.subStreetName.text = value;
          });
        },
        onTabFunction: () {
          if (currentAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              currentAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              currentAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final cStreetNameTextField = misc.importantTextField(
        textController: currentAddress.controller.streetName,
        errorTextCondition: _streetNameErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.streetSubject),
        subject: model.streetSubject,
        filterPattern: model.allfilter,
        onsubmittedFunction: (value) {
          setState(() {
            currentAddress.controller.streetName.text = value;
          });
        },
        onTabFunction: () {
          if (currentAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              currentAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              currentAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final cTambonDropdown = misc.dropdownButtonBuilderFunction(
      value: cThTambonValue,
      label1: thTambonLable,
      label2: model.markImportant,
      items: cTambonItems,
      condition: currentAddress.condition.subdistrict,
      errorText: misc.thErrorTextFieldMessage(thTambonLable),
      onChanged: cTambonChangedFunction(),
    );

    final cAmphureDropdown = misc.dropdownButtonBuilderFunction(
        value: cThAmphureValue,
        label1: thAmphureLable,
        label2: model.markImportant,
        items: cAmphureItems,
        condition: currentAddress.condition.district,
        errorText: misc.thErrorTextFieldMessage(thAmphureLable),
        onChanged: cAmphureChangedFunction());

    final cProvinceDropdown = misc.dropdownButtonBuilderFunction(
        value: cThProvinceValue,
        label1: thProvinceLable,
        label2: model.markImportant,
        items: cProvinceItems,
        condition: currentAddress.condition.province,
        errorText: misc.thErrorTextFieldMessage(thProvinceLable),
        onChanged: cProvinceChangedFunction());

    final cZipcodeTextField = misc.importantTextField(
        textController: currentAddress.controller.zipcode,
        errorTextCondition: currentAddress.condition.zipcode,
        errorTextMessage: misc.thErrorTextFieldMessage(model.zipcodeSubject),
        subject: model.zipcodeSubject,
        onsubmittedFunction: (value) {
          currentAddress.controller.zipcode.text = value;
        },
        onchangedFunction: (value) {
          if (value.isNotEmpty) {
            setState(() {
              currentAddress.condition.zipcode = false;
            });
          } else {
            setState(() {
              currentAddress.condition.zipcode = true;
            });
          }
        },
        filterPattern: model.numberfilter);

    final cCountryTextField = misc.importantTextField(
        textController: currentAddress.controller.country,
        errorTextCondition: currentAddress.condition.country,
        errorTextMessage: misc.thErrorTextFieldMessage(model.countrySubject),
        subject: model.countrySubject,
        onsubmittedFunction: (value) {
          currentAddress.controller.country.text = value;
        },
        onchangedFunction: (value) {
          if (value.isNotEmpty) {
            setState(() {
              currentAddress.condition.country = false;
            });
          } else {
            setState(() {
              currentAddress.condition.country = true;
            });
          }
        },
        filterPattern: model.allfilter);

    var current = misc.addressFunction(
        titleWidget: '',
        homeWidget: cHomeNumberTextField,
        villegeNumberWidget: cVillageNumberTextField,
        villegeNameWidget: cVillageNameTextField,
        subStreetNameWidget: cSubStreetNameTextField,
        streetNameWidget: cStreetNameTextField,
        subDistrictNameWidget: cTambonDropdown,
        districtNameWidget: cAmphureDropdown,
        provinceNameWidget: cProvinceDropdown,
        zipCodeWidget: cZipcodeTextField,
        countryWidget: cCountryTextField);

    // Widget regist() {
    //   if (registeredAddress.controller.zipcode.text.isNotEmpty) {
    //   currentAddress = registeredAddress;
    //   }
    //   return const Column();
    // }

    final registeredAddressListTile = ListTile(
      title: const Text(model.registeredAddressSubject, style: TextStyle(fontSize: 11),),
      leading: Radio<SelectedCurrentAddressEnum>(
        value: SelectedCurrentAddressEnum.registered,
        groupValue: currentAddressEnum,
        onChanged: (value) {
          setState(() {
            currentAddressEnum = value;
            currentAddress.typeOfAddress = value.toString();
            // currentAddress.typeOfAddress = 'registered_address';
          });
        },
      ),
    );

    final otherAddressListTile = ListTile(
      title: const Text(model.otherAddressSubject, style: TextStyle(fontSize: 11),),
      leading: Radio<SelectedCurrentAddressEnum>(
        value: SelectedCurrentAddressEnum.current,
        groupValue: currentAddressEnum,
        onChanged: (value) {
          setState(() {
            currentAddressEnum = value;
            currentAddress.typeOfAddress = value.toString();
            // currentAddress = currentAddress;
            // currentAddress.typeOfAddress = 'current_address';
            cGetCurrentProvince();
          });
        },
      ),
    );

    // office address variables

    final oHomeNumberTextField = misc.importantTextField(
        textController: officeAddress.controller.homenumber,
        errorTextCondition: officeAddress.condition.homenumber,
        errorTextMessage: misc.thErrorTextFieldMessage(model.homeNumberSubject),
        subject: model.homeNumberSubject,
        filterPattern: RegExp(r'[0-9/-]'),
        onsubmittedFunction: (value) {
          officeAddress.controller.homenumber.text = value;
        },
        onchangedFunction: (value) {
          if (value.isNotEmpty) {
            setState(() {
              officeAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              officeAddress.condition.homenumber = true;
            });
          }
        });

    final oVillageNumberTextField = misc.importantTextField(
        textController: officeAddress.controller.villageNumber,
        errorTextCondition: _villageNumberErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.villageNoSubject),
        subject: model.villageNoSubject,
        filterPattern: model.numberfilter,
        onsubmittedFunction: (value) {
          setState(() {
            officeAddress.controller.villageNumber.text = value;
          });
        },
        onTabFunction: () {
          if (officeAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              officeAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              officeAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final oVillageNameTextField = misc.importantTextField(
        textController: officeAddress.controller.villageName,
        errorTextCondition: _villageNameErrorCondition,
        errorTextMessage:
            misc.thErrorTextFieldMessage(model.villageNameSubject),
        subject: model.villageNameSubject,
        filterPattern: model.allfilter,
        onsubmittedFunction: (value) {
          setState(() {
            officeAddress.controller.villageName.text = value;
          });
        },
        onTabFunction: () {
          if (officeAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              officeAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              officeAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final oSubStreetNameTextField = misc.importantTextField(
        textController: officeAddress.controller.subStreetName,
        errorTextCondition: _subStreetNameErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.subStreetSubject),
        subject: model.subStreetSubject,
        filterPattern: model.allfilter,
        onsubmittedFunction: (value) {
          setState(() {
            officeAddress.controller.subStreetName.text = value;
          });
        },
        onTabFunction: () {
          if (officeAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              officeAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              officeAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final oStreetNameTextField = misc.importantTextField(
        textController: officeAddress.controller.streetName,
        errorTextCondition: _streetNameErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.streetSubject),
        subject: model.streetSubject,
        filterPattern: model.allfilter,
        onsubmittedFunction: (value) {
          setState(() {
            officeAddress.controller.streetName.text = value;
          });
        },
        onTabFunction: () {
          if (officeAddress.controller.homenumber.text.isNotEmpty) {
            setState(() {
              officeAddress.condition.homenumber = false;
            });
          } else {
            setState(() {
              officeAddress.condition.homenumber = true;
            });
          }
        },
        isimportant: false);
    final oTambonDropdown = misc.dropdownButtonBuilderFunction(
      value: oThTambonValue,
      label1: thTambonLable,
      label2: model.markImportant,
      items: oTambonItems,
      condition: officeAddress.condition.subdistrict,
      errorText: misc.thErrorTextFieldMessage(thTambonLable),
      onChanged: oTambonChangedFunction(),
    );

    final oAmphureDropdown = misc.dropdownButtonBuilderFunction(
        value: oThAmphureValue,
        label1: thAmphureLable,
        label2: model.markImportant,
        items: oAmphureItems,
        condition: officeAddress.condition.district,
        errorText: misc.thErrorTextFieldMessage(thAmphureLable),
        onChanged: oAmphureChangedFunction());

    final oProvinceDropdown = misc.dropdownButtonBuilderFunction(
        value: oThProvinceValue,
        label1: thProvinceLable,
        label2: model.markImportant,
        items: oProvinceItems,
        condition: officeAddress.condition.province,
        errorText: misc.thErrorTextFieldMessage(thProvinceLable),
        onChanged: oProvinceChangedFunction());

    final oZipcodeTextField = misc.importantTextField(
        textController: officeAddress.controller.zipcode,
        errorTextCondition: officeAddress.condition.zipcode,
        errorTextMessage: misc.thErrorTextFieldMessage(model.zipcodeSubject),
        subject: model.zipcodeSubject,
        onsubmittedFunction: (value) {
          officeAddress.controller.zipcode.text = value;
        },
        onchangedFunction: (value) {
          if (value.isNotEmpty) {
            setState(() {
              officeAddress.condition.zipcode = false;
            });
          } else {
            setState(() {
              officeAddress.condition.zipcode = true;
            });
          }
        },
        filterPattern: model.numberfilter);

    final oCountryTextField = misc.importantTextField(
        textController: officeAddress.controller.country,
        errorTextCondition: officeAddress.condition.country,
        errorTextMessage: misc.thErrorTextFieldMessage(model.countrySubject),
        subject: model.countrySubject,
        onsubmittedFunction: (value) {
          officeAddress.controller.country.text = value;
        },
        onchangedFunction: (value) {
          if (value.isNotEmpty) {
            setState(() {
              officeAddress.condition.country = false;
            });
          } else {
            setState(() {
              officeAddress.condition.country = true;
            });
          }
        },
        filterPattern: model.allfilter);

    var office = misc.addressFunction(
        titleWidget: '',
        homeWidget: oHomeNumberTextField,
        villegeNumberWidget: oVillageNumberTextField,
        villegeNameWidget: oVillageNameTextField,
        subStreetNameWidget: oSubStreetNameTextField,
        streetNameWidget: oStreetNameTextField,
        subDistrictNameWidget: oTambonDropdown,
        districtNameWidget: oAmphureDropdown,
        provinceNameWidget: oProvinceDropdown,
        zipCodeWidget: oZipcodeTextField,
        countryWidget: oCountryTextField);

    // Widget regist() {
    //   if (registeredAddress.controller.zipcode.text.isNotEmpty) {
    //   officeAddress = registeredAddress;
    //   }
    //   return const Column();
    // }

    final registeredOfficeAddressListTile = ListTile(
      title: const Text(model.registeredAddressSubject, style: TextStyle(fontSize: 11),),
      leading: Radio<SelectedOfficeAddressEnum>(
        value: SelectedOfficeAddressEnum.registered,
        groupValue: officeAddressEnum,
        onChanged: (value) {
          setState(() {
            officeAddressEnum = value;
            officeAddress.typeOfAddress = value.toString();
            // officeAddress.typeOfAddress = 'registered_address';
          });
        },
      ),
    );

    final currentOfficeAddressListTile = ListTile(
      title: const Text(model.currentAddressSubject, style: TextStyle(fontSize: 11)),
      leading: Radio<SelectedOfficeAddressEnum>(
        value: SelectedOfficeAddressEnum.current,
        groupValue: officeAddressEnum,
        onChanged: (value) {
          setState(() {
            officeAddressEnum = value;
            officeAddress.typeOfAddress = value.toString();
            // officeAddress.typeOfAddress = 'registered_address';
          });
        },
      ),
    );

    final otherOfficeAddressListTile = ListTile(
      title: const Text(model.otherAddressSubject, style: TextStyle(fontSize: 11)),
      leading: Radio<SelectedOfficeAddressEnum>(
        value: SelectedOfficeAddressEnum.office,
        groupValue: officeAddressEnum,
        onChanged: (value) {
          setState(() {
            officeAddressEnum = value;
            officeAddress.typeOfAddress = value.toString();
            // officeAddress = officeAddress;
            // officeAddress.typeOfAddress = 'current_address';
            oGetCurrentProvince();
          });
        },
      ),
    );

    String? sourceOfIncomeValue;
    String? currentOccupationValue;
    Widget? officeNameValue;
    String? typeOfBusinessValue;
    Widget? positionValue;
    String? salaryRangeValue;
    const space = SizedBox(width: 10);
    final sourceOfIncome = misc.dropdownButtonBuilderFunction(
        value: sourceOfIncomeValue,
        label1: model.sourceOfIncomeSubject,
        label2: model.markImportant,
        items: _sourceOfIncomeItems,
        condition: sourceOfIncomeCondition,
        errorText: misc.thErrorDropdownMessage(model.sourceOfIncomeSubject),
        onChanged: (value) {
          if (value == null) {
            setState(() {
              sourceOfIncomeCondition = true;
            });
          } else {
            setState(() {
              sourceOfIncomeCondition = false;
              occupation.sourceOfIncome = value;
              sourceOfIncomeValue = value;
            });
          }
        });

    final currentOccupation = misc.dropdownButtonBuilderFunction(
        value: currentOccupationValue,
        label1: model.currentOccupationSubject,
        label2: model.markImportant,
        items: _sourceOfIncomeItems,
        condition: currentOccupationCondition,
        errorText: misc.thErrorDropdownMessage(model.currentOccupationSubject),
        onChanged: (value) {
          if (value == null) {
            setState(() {
              currentOccupationCondition = true;
            });
          } else {
            setState(() {
              currentOccupationCondition = false;
              occupation.currentOccupation = value;
              currentOccupationValue = value;
            });
          }
        });

    officeNameValue = misc.importantTextField(
        textController: officeNameController,
        errorTextCondition: officeNameCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.officeNameSubject),
        subject: model.officeNameSubject,
        onsubmittedFunction: (value) {
          occupation.officeName = value;
          officeNameController.text = value;
        },
        onchangedFunction: (value) {
          if (value.isEmpty) {
            setState(() {
              officeNameCondition = true;
            });
          } else {
            setState(() {
              officeNameCondition = false;
            });
          }
        },
        filterPattern: model.allfilter);

    final typeOfBusiness = misc.dropdownButtonBuilderFunction(
        value: typeOfBusinessValue,
        label1: model.typeOfBusinessSubject,
        label2: model.markImportant,
        items: _typeOfBusinessItems,
        condition: typeOfBusinessCondition,
        errorText: misc.thErrorDropdownMessage(model.typeOfBusinessSubject),
        onChanged: (value) {
          if (value == null) {
            setState(() {
              typeOfBusinessCondition = true;
            });
          } else {
            setState(() {
              typeOfBusinessCondition = false;
              occupation.typeOfBusiness = value;
              typeOfBusinessValue = value;
            });
          }
        });

    positionValue = misc.importantTextField(
        textController: positionNameController,
        errorTextCondition: positionNameCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.positionSubject),
        subject: model.positionSubject,
        onsubmittedFunction: (value) {
          setState(() {
            occupation.positionName = value;
            positionNameController.text = value;
          });
        },
        onchangedFunction: (value) {
          if (value.isEmpty) {
            setState(() {
              positionNameCondition = true;
            });
          } else {
            setState(() {
              positionNameCondition = false;
            });
          }
        },
        filterPattern: model.allfilter);

    final salary = misc.dropdownButtonBuilderFunction(
        value: salaryRangeValue,
        label1: model.salarySubject,
        label2: model.markImportant,
        items: _salaryItems,
        condition: salaryRangeCondition,
        errorText: misc.thErrorDropdownMessage(model.salarySubject),
        onChanged: (value) {
          if (value == null) {
            setState(() {
              salaryRangeCondition = true;
            });
          } else {
            setState(() {
              salaryRangeCondition = false;
              occupation.salaryRange = value;
              salaryRangeValue = value;
            });
          }
        });

// bank accounts
    final firstBankNameDropdown = misc.dropdownButtonBuilderFunction(
      value: firstBankNameValue,
      label1: model.bankNameSubject,
      label2: model.markImportant,
      items: bankNameItems,
      condition: firstBankNameCondition,
      errorText: misc.thErrorTextFieldMessage(model.bankNameSubject),
      onChanged: (value) {
        if (value == null) {
          setState(() {
            firstBankNameCondition = true;
          });
        } else {
          setState(() {
            firstBankNameCondition = false;
            firstBankNameValue = value;
          });
        }
      },
    );

    final firstBankBranchNameDropDown = misc.dropdownButtonBuilderFunction(
      value: firstBankBranchNameValue,
      label1: model.bankBranchNameSubject,
      label2: model.markImportant,
      items: bankBranchNameItems,
      condition: firstBankBranchNameCondition,
      errorText: misc.thErrorTextFieldMessage(model.bankBranchNameSubject),
      onChanged: (value) {
        if (value == null) {
          setState(() {
            firstBankBranchNameCondition = true;
          });
        } else {
          setState(() {
            firstBankBranchNameCondition = false;
            firstBankBranchNameValue = value;
          });
        }
      },
    );

    final firstBankBranchNumberTextField = misc.importantTextField(
        textController: _firstbankAccountNumberController,
        errorTextCondition: firstBankAccountNumberCondition,
        errorTextMessage:
            misc.thErrorTextFieldMessage(model.bankAccountNumberSubject),
        subject: model.bankAccountNumberSubject,
        filterPattern: model.numberfilter,
        onsubmittedFunction: (value) {
          _firstbankAccountNumberController.text = value;
        },
        onchangedFunction: (value) {
          if (value.isEmpty) {
            setState(() {
              firstBankAccountNumberCondition = true;
            });
          } else {
            setState(() {
              firstBankAccountNumberCondition = false;
            });
          }
        });

    final secondBankNameDropdown = misc.dropdownButtonBuilderFunction(
      value: secondBankNameValue,
      label1: model.bankNameSubject,
      label2: model.markImportant,
      items: bankNameItems,
      condition: secondBankNameCondition,
      errorText: misc.thErrorTextFieldMessage(model.bankNameSubject),
      onChanged: (value) {
        if (value == null) {
          setState(() {
            secondBankNameCondition = true;
          });
        } else {
          setState(() {
            secondBankNameCondition = false;
            secondBankNameValue = value;
          });
        }
      },
    );

    final secondBankBranchNameDropDown = misc.dropdownButtonBuilderFunction(
      value: secondBankBranchNameValue,
      label1: model.bankBranchNameSubject,
      label2: model.markImportant,
      items: bankBranchNameItems,
      condition: secondBankBranchNameCondition,
      errorText: misc.thErrorTextFieldMessage(model.bankBranchNameSubject),
      onChanged: (value) {
        if (value == null) {
          setState(() {
            secondBankBranchNameCondition = true;
          });
        } else {
          setState(() {
            secondBankBranchNameCondition = false;
            secondBankBranchNameValue = value;
          });
        }
      },
    );

    final secondBankBranchNumberTextField = misc.importantTextField(
        textController: _secondbankAccountNumberController,
        errorTextCondition: secondBankAccountNumberCondition,
        errorTextMessage:
            misc.thErrorTextFieldMessage(model.bankAccountNumberSubject),
        subject: model.bankAccountNumberSubject,
        filterPattern: model.numberfilter,
        onsubmittedFunction: (value) {
          _secondbankAccountNumberController.text = value;
        },
        onchangedFunction: (value) {
          if (value.isEmpty) {
            setState(() {
              secondBankAccountNumberCondition = true;
            });
          } else {
            setState(() {
              secondBankAccountNumberCondition = false;
            });
          }
        });

    var firstBank = Row(
      children: [
        Expanded(flex: 1, child: firstBankNameDropdown),
        const SizedBox(width: 10),
        Expanded(flex: 1, child: firstBankBranchNameDropDown),
        const SizedBox(width: 10),
        Expanded(child: firstBankBranchNumberTextField),
      ],
    );
    var secondBank = Row(
      children: [
        Expanded(flex: 1, child: secondBankNameDropdown),
        const SizedBox(width: 10),
        Expanded(flex: 1, child: secondBankBranchNameDropDown),
        const SizedBox(width: 10),
        Expanded(child: secondBankBranchNumberTextField),
      ],
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HighSpace(height: height),
                const PersonalInformationHeader(),
                HighSpace(height: height),
                const SizedBox(height: 20),
                // registered address path
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue.withOpacity(.3),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Column(children: [
                    misc.addressFunction(
                        titleWidget: model.registeredAddressSubject,
                        homeWidget: rHomeNumberTextField,
                        villegeNumberWidget: rVillageNumberTextField,
                        villegeNameWidget: rVillageNameTextField,
                        subStreetNameWidget: rSubStreetNameTextField,
                        streetNameWidget: rStreetNameTextField,
                        subDistrictNameWidget: rTambonDropdown,
                        districtNameWidget: rAmphureDropdown,
                        provinceNameWidget: rProvinceDropdown,
                        zipCodeWidget: rZipcodeTextField,
                        countryWidget: rCountryTextField)
                  ]),
                ),
                HighSpace(height: height),
                Container(
                  width: 500,
                  // width: MediaQuery.of(context).size.width * displayWidth,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue.withOpacity(.3),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          misc.subjectRichText(
                              subject: model.currentAddressSubject,
                              fontsize: 15,
                              color: Colors.black),
                          // const Expanded(flex: 1, child: SizedBox()),
                          const SizedBox(width: 20,),
                          Expanded(flex: 5, child: registeredAddressListTile),
                          Expanded(flex: 5, child: otherAddressListTile),
                        ],
                      ),
                      (currentAddressEnum == SelectedCurrentAddressEnum.current)
                          ? current
                          : const Column()
                    ],
                  ),
                ),
                HighSpace(height: height),
                // const PersonalInformationOccupation(),
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue.withOpacity(
                        .3,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: 'อาชีพปัจจุบันแลหะแหล่งที่มาของเงินลงทุน',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const HighSpace(height: 10),
                      Row(
                        children: [
                          Expanded(flex: 1, child: sourceOfIncome),
                          space,
                          Expanded(flex: 1, child: currentOccupation)
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: officeNameValue),
                          const SizedBox(width: 10),
                          Expanded(flex: 1, child: typeOfBusiness),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: positionValue),
                          const SizedBox(width: 10),
                          Expanded(flex: 1, child: salary),
                        ],
                      ),
                      const HighSpace(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          misc.subjectRichText(
                              subject: model.officeLocation, fontsize: 15),
                          // const Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                              flex: 2, child: registeredOfficeAddressListTile),
                          Expanded(
                              flex: 2, child: currentOfficeAddressListTile),
                          Expanded(flex: 2, child: otherOfficeAddressListTile),
                        ],
                      ),
                      (officeAddressEnum == SelectedOfficeAddressEnum.office)
                          ? office
                          : const Column()
                    ],
                  ),
                ),
                HighSpace(height: height),
                // bankAccount
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue.withOpacity(.3),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      )),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on),
                          Text(model.bankHeaderSubject,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Row(children: [Text(model.firstBankSubject)]),
                      firstBank,
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const Text(model.secondBankSubject,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          // const Expanded(flex: 2, child: SizedBox()),
                          Expanded(
                            flex: 1,
                            child: ListTile(
                              title: const Text('ใช้', style: TextStyle(fontSize: 11)),
                              leading: Radio<IsAddedBankAccountsEnum>(
                                value: IsAddedBankAccountsEnum.yes,
                                groupValue: isAddedBankAccount,
                                onChanged: (IsAddedBankAccountsEnum? value) {
                                  setState(() {
                                    isAddedBankAccount = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTile(
                              title: const Text('ไม่ใช้', style: TextStyle(fontSize: 11)),
                              leading: Radio<IsAddedBankAccountsEnum>(
                                value: IsAddedBankAccountsEnum.no,
                                groupValue: isAddedBankAccount,
                                onChanged: (IsAddedBankAccountsEnum? value) {
                                  setState(() {
                                    isAddedBankAccount = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      (isAddedBankAccount == IsAddedBankAccountsEnum.yes)
                          ? Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('กรุณาระบุชื่อธนาคารก่อนกรอกชื่อสาขา', style: TextStyle(fontSize: 8)),
                                  ],
                                ),
                                secondBank
                              ],
                            )
                          : const Column(),
                    ],
                  ),
                ),
                HighSpace(height: height),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const IDCardPage();
                              },
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.arrow_circle_left,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'ย้อนกลับ',
                      style: TextStyle(fontSize: 15),
                    ),
                    const Expanded(
                      flex: 30,
                      child: SizedBox(),
                    ),
                    const Text(
                      'ถัดไป',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.orange,
                          onPressed: () {
                            // print('registered home number: ${registeredAddress.homenumber} ${page.registeredAddress.villageName} ${page.registeredAddress.subStreetName} ${page.registeredAddress.streetName}, ${page.registeredAddress.typeOfAddress}');
                            // print('current home number: ${page.currentAddress.homenumber}, ${page.currentAddress.typeOfAddress}');
                            // print('others home number: ${page.othersAddress.homenumber}, ${page.othersAddress.typeOfAddress}');
                            // print('occupation: ${page.occupation.sourceOfIncome}, ${page.occupation.currentOccupation}, ${page.occupation.officeName}, ${page.occupation.typeOfBusiness}, ${page.occupation.positionName}, ${page.occupation.salaryRange}');
                            // print('1st bank account: ${page.firstBank.bankAccountID}, ${page.firstBank.bankName}, ${page.firstBank.bankBranchName}, ${page.firstBank.serviceType}');
                            // print('2st bank account: ${page.secondBank.bankAccountID}, ${page.secondBank.bankName}, ${page.secondBank.bankBranchName}, ${page.secondBank.serviceType}');

                            if (registeredAddress
                                .controller.homenumber.text.isEmpty) {
                              setState(() {
                                registeredAddress.condition.homenumber = true;
                              });
                            } else if (registeredAddress.provinceName == null) {
                              setState(() {
                                registeredAddress.condition.province = true;
                              });
                            } else if (registeredAddress.districtName == null) {
                              setState(() {
                                registeredAddress.condition.district = true;
                              });
                            } else if (registeredAddress.subDistrictName ==
                                null) {
                              setState(() {
                                registeredAddress.condition.subdistrict = true;
                              });
                            } else if (currentAddressEnum ==
                                SelectedCurrentAddressEnum.current) {
                              if (currentAddress
                                  .controller.homenumber.text.isEmpty) {
                                setState(() {
                                  currentAddress.condition.homenumber = true;
                                });
                              } else if (currentAddress.provinceName == null) {
                                setState(() {
                                  currentAddress.condition.province = true;
                                });
                              } else if (currentAddress.districtName == null) {
                                setState(() {
                                  currentAddress.condition.district = true;
                                });
                              } else if (currentAddress.subDistrictName ==
                                  null) {
                                setState(() {
                                  currentAddress.condition.subdistrict = true;
                                });
                              }
                            } else if (occupation.sourceOfIncome.isEmpty) {
                              setState(() {
                                sourceOfIncomeCondition = true;
                              });
                            } else if (occupation.currentOccupation.isEmpty) {
                              setState(() {
                                currentOccupationCondition = true;
                              });
                            } else if (officeNameController.text.isEmpty) {
                              setState(() {
                                officeNameCondition = true;
                              });
                            } else if (occupation.typeOfBusiness.isEmpty) {
                              setState(() {
                                typeOfBusinessCondition = true;
                              });
                            } else if (positionNameController.text.isEmpty) {
                              setState(() {
                                positionNameCondition = true;
                              });
                            } else if (occupation.salaryRange.isEmpty) {
                              setState(() {
                                salaryRangeCondition = true;
                              });
                            } else if (officeAddressEnum ==
                                SelectedOfficeAddressEnum.office) {
                              if (officeAddress
                                  .controller.homenumber.text.isEmpty) {
                                setState(() {
                                  officeAddress.condition.homenumber = true;
                                });
                              } else if (officeAddress.provinceName == null) {
                                setState(() {
                                  officeAddress.condition.province = true;
                                });
                              } else if (officeAddress.districtName == null) {
                                setState(() {
                                  officeAddress.condition.district = true;
                                });
                              } else if (officeAddress.subDistrictName ==
                                  null) {
                                setState(() {
                                  officeAddress.condition.subdistrict = true;
                                });
                              }
                            } else if (firstBankNameValue == null) {
                              setState(() {
                                firstBankNameCondition = true;
                              });
                            } else if (firstBankBranchNameValue == null) {
                              setState(() {
                                firstBankBranchNameCondition = true;
                              });
                            } else if (_firstbankAccountNumberController
                                .text.isEmpty) {
                              setState(() {
                                firstBankAccountNumberCondition = true;
                              });
                            } else if (isAddedBankAccount ==
                                IsAddedBankAccountsEnum.yes) {
                              if (secondBankNameValue == null) {
                                setState(() {
                                  secondBankNameCondition = true;
                                });
                              } else if (secondBankBranchNameValue == null) {
                                setState(() {
                                  secondBankNameCondition = true;
                                });
                              } else if (_secondbankAccountNumberController
                                  .text.isEmpty) {
                                setState(() {
                                  secondBankNameCondition = true;
                                });
                              }
                            }

                            print(
                                'registered address: ${registeredAddress.controller.homenumber.text} ${registeredAddress.controller.villageNumber.text} ${registeredAddress.controller.villageName.text} ${registeredAddress.controller.subStreetName.text} ${registeredAddress.controller.streetName.text} ${registeredAddress.subDistrictName} ${registeredAddress.districtName} ${registeredAddress.provinceName} ${registeredAddress.controller.zipcode.text} ${registeredAddress.controller.country.text} ${registeredAddress.typeOfAddress}}');
                            print(
                                'current address: ${currentAddress.controller.homenumber.text} ${currentAddress.controller.villageNumber.text} ${currentAddress.controller.villageName.text} ${currentAddress.controller.subStreetName.text} ${currentAddress.controller.streetName.text} ${currentAddress.subDistrictName} ${currentAddress.districtName} ${currentAddress.provinceName} ${currentAddress.controller.zipcode.text} ${currentAddress.controller.country.text}}');
                            print(
                                'office address: ${officeAddress.controller.homenumber.text} ${officeAddress.controller.villageNumber.text} ${officeAddress.controller.villageName.text} ${officeAddress.controller.subStreetName.text} ${officeAddress.controller.streetName.text} ${officeAddress.subDistrictName} ${officeAddress.districtName} ${officeAddress.provinceName} ${officeAddress.controller.zipcode.text} ${officeAddress.controller.country.text}}');
                            final personalInformation =
                                modelPI.PersonalInformationModel(
                                    customerID: widget.id,
                                    registeredAddress: registeredAddress,
                                    currentAddress: currentAddress,
  officeAddress: officeAddress,
                                    occupation: occupation,
                                    firstBankAccount: modelPI.BankAccountModel(
                                        bankName: firstBankNameValue!,
                                        bankAccountID:
                                            _firstbankAccountNumberController
                                                .text,
                                        serviceType: 'dw'));
                            personalInformation.firstBankAccount
                                .bankBranchName = firstBankBranchNameValue;
                            personalInformation.occupation.officeName =
                                officeNameController.text;
                            personalInformation.occupation.positionName =
                                positionNameController.text;
                            if (currentAddressEnum ==
                                SelectedCurrentAddressEnum.current) {
                              // personalInformation.currentAddress =
                              //     currentAddress;
                              setState(() {
                              personalInformation.currentAddress.controller.homenumber.text = currentAddress.controller.homenumber.text;
                              personalInformation.currentAddress.controller.villageNumber.text = currentAddress.controller.villageNumber.text;
                              personalInformation.currentAddress.controller.villageName.text = currentAddress.controller.villageName.text;
                              personalInformation.currentAddress.controller.subStreetName.text = currentAddress.controller.subStreetName.text;
                              personalInformation.currentAddress.controller.streetName.text = currentAddress.controller.streetName.text;
                              personalInformation.currentAddress.subDistrictName = currentAddress.subDistrictName;
                              personalInformation.currentAddress.districtName = currentAddress.districtName;
                              personalInformation.currentAddress.provinceName = currentAddress.provinceName;
                              personalInformation.currentAddress.controller.zipcode.text = currentAddress.controller.zipcode.text;
                              personalInformation.currentAddress.controller.country.text = currentAddress.controller.country.text;
                                
                              personalInformation.currentAddress.typeOfAddress = currentAddressEnum.toString();
                              });
                            } else if (currentAddressEnum ==
                                SelectedCurrentAddressEnum.registered) {
                                  // personalInformation.currentAddress = registeredAddress;
                              setState(() {
                              personalInformation.currentAddress.controller.homenumber.text = registeredAddress.controller.homenumber.text;
                              personalInformation.currentAddress.controller.villageNumber.text = registeredAddress.controller.villageNumber.text;
                              personalInformation.currentAddress.controller.villageName.text = registeredAddress.controller.villageName.text;
                              personalInformation.currentAddress.controller.subStreetName.text = registeredAddress.controller.subStreetName.text;
                              personalInformation.currentAddress.controller.streetName.text = registeredAddress.controller.streetName.text;
                              personalInformation.currentAddress.subDistrictName = registeredAddress.subDistrictName;
                              personalInformation.currentAddress.districtName = registeredAddress.districtName;
                              personalInformation.currentAddress.provinceName = registeredAddress.provinceName;
                              personalInformation.currentAddress.controller.zipcode.text = registeredAddress.controller.zipcode.text;
                              personalInformation.currentAddress.controller.country.text = registeredAddress.controller.country.text;
                                
                              personalInformation.currentAddress.typeOfAddress = currentAddressEnum.toString();
                              });
                              // personalInformation.currentAddress!.typeOfAddress = currentAddressEnum.toString();
                            }

                            if (officeAddressEnum ==
                                SelectedOfficeAddressEnum.registered) {
                                   setState(() {
                              personalInformation.officeAddress.controller.homenumber.text = registeredAddress.controller.homenumber.text;
                              personalInformation.officeAddress.controller.villageNumber.text = registeredAddress.controller.villageNumber.text;
                              personalInformation.officeAddress.controller.villageName.text = registeredAddress.controller.villageName.text;
                              personalInformation.officeAddress.controller.subStreetName.text = registeredAddress.controller.subStreetName.text;
                              personalInformation.officeAddress.controller.streetName.text = registeredAddress.controller.streetName.text;
                              personalInformation.officeAddress.subDistrictName = registeredAddress.subDistrictName;
                              personalInformation.officeAddress.districtName = registeredAddress.districtName;
                              personalInformation.officeAddress.provinceName = registeredAddress.provinceName;
                              personalInformation.officeAddress.controller.zipcode.text = registeredAddress.controller.zipcode.text;
                              personalInformation.officeAddress.controller.country.text = registeredAddress.controller.country.text;
                                
                              personalInformation.officeAddress.typeOfAddress = officeAddressEnum.toString();
                              });
                              // personalInformation.officeAddress =
                              //     registeredAddress;
                              print(
                                  'registeredAddress: ${registeredAddress.provinceName}, ${personalInformation.officeAddress!.provinceName}');
                            } else if (officeAddressEnum ==
                                    SelectedOfficeAddressEnum.current &&
                                currentAddressEnum ==
                                    SelectedCurrentAddressEnum.registered) {
                              setState(() {
                              personalInformation.officeAddress.controller.homenumber.text = registeredAddress.controller.homenumber.text;
                              personalInformation.officeAddress.controller.villageNumber.text = registeredAddress.controller.villageNumber.text;
                              personalInformation.officeAddress.controller.villageName.text = registeredAddress.controller.villageName.text;
                              personalInformation.officeAddress.controller.subStreetName.text = registeredAddress.controller.subStreetName.text;
                              personalInformation.officeAddress.controller.streetName.text = registeredAddress.controller.streetName.text;
                              personalInformation.officeAddress.subDistrictName = registeredAddress.subDistrictName;
                              personalInformation.officeAddress.districtName = registeredAddress.districtName;
                              personalInformation.officeAddress.provinceName = registeredAddress.provinceName;
                              personalInformation.officeAddress.controller.zipcode.text = registeredAddress.controller.zipcode.text;
                              personalInformation.officeAddress.controller.country.text = registeredAddress.controller.country.text;
                                
                              personalInformation.officeAddress.typeOfAddress = officeAddressEnum.toString();
                              });
                            } else if (officeAddressEnum ==
                                SelectedOfficeAddressEnum.current) {
                              setState(() {
                              personalInformation.officeAddress.controller.homenumber.text = currentAddress.controller.homenumber.text;
                              personalInformation.officeAddress.controller.villageNumber.text = currentAddress.controller.villageNumber.text;
                              personalInformation.officeAddress.controller.villageName.text = currentAddress.controller.villageName.text;
                              personalInformation.officeAddress.controller.subStreetName.text = currentAddress.controller.subStreetName.text;
                              personalInformation.officeAddress.controller.streetName.text = currentAddress.controller.streetName.text;
                              personalInformation.officeAddress.subDistrictName = currentAddress.subDistrictName;
                              personalInformation.officeAddress.districtName = currentAddress.districtName;
                              personalInformation.officeAddress.provinceName = currentAddress.provinceName;
                              personalInformation.officeAddress.controller.zipcode.text = currentAddress.controller.zipcode.text;
                              personalInformation.officeAddress.controller.country.text = currentAddress.controller.country.text;
                                
                              personalInformation.officeAddress.typeOfAddress = officeAddressEnum.toString();
                              });
                            } else if (officeAddressEnum ==
                                SelectedOfficeAddressEnum.office) {
                              setState(() {
                              personalInformation.officeAddress.controller.homenumber.text = officeAddress.controller.homenumber.text;
                              personalInformation.officeAddress.controller.villageNumber.text = officeAddress.controller.villageNumber.text;
                              personalInformation.officeAddress.controller.villageName.text = officeAddress.controller.villageName.text;
                              personalInformation.officeAddress.controller.subStreetName.text = officeAddress.controller.subStreetName.text;
                              personalInformation.officeAddress.controller.streetName.text = officeAddress.controller.streetName.text;
                              personalInformation.officeAddress.subDistrictName = officeAddress.subDistrictName;
                              personalInformation.officeAddress.districtName = officeAddress.districtName;
                              personalInformation.officeAddress.provinceName = officeAddress.provinceName;
                              personalInformation.officeAddress.controller.zipcode.text = officeAddress.controller.zipcode.text;
                              personalInformation.officeAddress.controller.country.text = officeAddress.controller.country.text;
                                
                              personalInformation.officeAddress.typeOfAddress = officeAddressEnum.toString();
                              });
                            }

                            //  personalInformation.registeredAddress.typeOfAddress = SelectedAddressEnum.registered.toString();
                            print(
                                "1 ${personalInformation.currentAddress.typeOfAddress}");
                            print(
                                "3 ${personalInformation.officeAddress.typeOfAddress}");
                            setState(() {
                              personalInformation
                                      .currentAddress.typeOfAddress =
                                  currentAddressEnum.toString();
                              personalInformation.officeAddress.typeOfAddress =
                                  officeAddressEnum.toString();
                            });
                            print(
                                "4 ${personalInformation.officeAddress.typeOfAddress}");
                            print(
                                "2 ${personalInformation.currentAddress.typeOfAddress}");
                            print(
                                '''personal: ${personalInformation.registeredAddress.typeOfAddress}
current: ${personalInformation.currentAddress.typeOfAddress}
office: ${personalInformation.officeAddress.typeOfAddress}''');
                            // personalInformation.officeAddress = officeAddress;
                            if (secondBankNameValue != null &&
                                secondBankBranchNameValue != null &&
                                _secondbankAccountNumberController
                                    .text.isNotEmpty) {
                              personalInformation.secondBankAccount =
                                  modelPI.BankAccountModel(
                                      bankName: secondBankNameValue!,
                                      bankAccountID:
                                          _secondbankAccountNumberController
                                              .text,
                                      serviceType: 'd');
                              personalInformation.secondBankAccount!
                                  .bankBranchName = secondBankBranchNameValue;
                              // } else {
                              //   personalInformation.secondBankAccount!.bankName = '';
                              //   personalInformation.secondBankAccount!.bankBranchName = '';
                              //   personalInformation.secondBankAccount!.bankAccountID = '';
                              //   personalInformation.secondBankAccount!.serviceType = 'd';
                            }

                            var logger = Logger();
                            logger.d(
                                'current: $currentAddressEnum, office: $officeAddressEnum');
                            inspect(personalInformation);
                            bool isNextPage = false;
                            try {
                            api.postPersonalInfo(personalInformation);
                            isNextPage = true;
                            } catch (e) {
                              isNextPage = false;
                            }
                            // if (ca.currentAddress == ca.CurrentAddress.others) {
                            //   if (ca.PersonalInformationCurrentAddress]) {}
                            // }

                            // print(_lasercodestr);
                            // if (registered.homeNumberController.text.isNotEmpty) {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) {
                            //         return CustomerEvaluate(id: id);
                            //       },
                            //     ),
                            //   );
                            // }
                            if (isNextPage) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CustomerEvaluate(id: widget.id);
                                  },
                                ),
                              );
                            }
                          },
                          child: const Icon(
                            Icons.arrow_circle_right,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                HighSpace(height: height),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HighSpace extends StatelessWidget {
  const HighSpace({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class PersonalInformationHeader extends StatelessWidget {
  const PersonalInformationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    return Container(
      width: 500,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.lightGreen.withOpacity(
            .3,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: const Text(
        'กรอกข้อมูลส่วนตัว',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// class PersonalInformationCurrentAddress extends StatefulWidget {
//   const PersonalInformationCurrentAddress({super.key});

//   @override
//   State<PersonalInformationCurrentAddress> createState() =>
//       _PersonalInformationCurrentAddressState();
// }

// class _PersonalInformationCurrentAddressState
//     extends State<PersonalInformationCurrentAddress> {
//   CurrentAddress? _currentAddress = CurrentAddress.registered;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * displayWidth,
//       padding: const EdgeInsets.all(50),
//       decoration: BoxDecoration(
//           color: Colors.lightBlue.withOpacity(
//             .3,
//           ),
//           borderRadius: const BorderRadius.all(Radius.circular(10))),
//       child: Row(
//         children: [
//           const Icon(Icons.location_on),
//           const Text(
//             'ที่อยู่ปัจจุบัน',
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const Expanded(
//             flex: 1,
//             child: SizedBox(),
//           ),
//           Expanded(
//             flex: 1,
//             child: ListTile(
//               title: const Text('ที่อยู่ตามบัตรประชาชน'),
//               leading: Radio<CurrentAddress>(
//                 value: CurrentAddress.registered,
//                 groupValue: _currentAddress,
//                 onChanged: (CurrentAddress? value) {
//                   setState(() {
//                     _currentAddress = value;
//                   });
//                 },
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: ListTile(
//               title: const Text('ที่อยู่อื่น (โปรดระบุ)'),
//               leading: Radio<CurrentAddress>(
//                 value: CurrentAddress.others,
//                 groupValue: _currentAddress,
//                 onChanged: (CurrentAddress? value) {
//                   setState(() {
//                     _currentAddress = value;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
