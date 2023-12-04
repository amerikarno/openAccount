import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';

import 'package:ico_open/config/config.dart';
import 'package:ico_open/personal_info/page.dart';
import 'package:ico_open/personal_info/api.dart' as api;
import 'package:ico_open/model/model.dart' as model;
import 'package:ico_open/misc/misc.dart' as misc;

enum OfficeAddress { registered, currentAddress, others }

class PersonalInformationOccupation extends StatefulWidget {
  const PersonalInformationOccupation({super.key});

  @override
  State<PersonalInformationOccupation> createState() =>
      _PersonalInformationOccupationState();
}

class _PersonalInformationOccupationState
    extends State<PersonalInformationOccupation> {
  OfficeAddress? _currentAddress = OfficeAddress.registered;
  final homeNumberController = TextEditingController();
  final villageNumberController = TextEditingController();
  final villageNameController = TextEditingController();
  final subStreetNameController = TextEditingController();
  final streetNameController = TextEditingController();
  final zipCodeController = TextEditingController();
  final countryController = TextEditingController();
  final officeNameController = TextEditingController();
  final positionNameController = TextEditingController();
  // final _companyName = TextEditingController();

  List<String> provinceItems = provinces;
  final thProvinceLable = 'จังหวัด';
  final thAmphureLable = 'เขตอำเภอ';
  List<String> amphureItems = [];
  final thTambonLable = 'แขวงตำบล';
  List<String> tambonItems = [];

  bool _loadingAmphure = true;
  bool _loadingTambon = true;
  bool _loadingZipcode = true;

  final bool _officeNameCondition = false;
  final bool _positionNameCondition = false;
  final bool _zipcodeErrorCondition = false;
  final bool _countryErrorCondition = false;
  final bool _homeNumberErrorCondition = false;
  final bool _villageNumberErrorCondition = false;
  final bool _villageNameErrorCondition = false;
  final bool _subStreetNameErrorCondition = false;
  final bool _streetNameErrorCondition = false;

  String? thProvinceValue;
  String? thAmphureValue;
  String? thTambonValue;
  String? zipcode;

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

  void getCurrentZipcode() async {
    final zipname = thProvinceValue! + thAmphureValue! + thTambonValue!;
    zipcode = await api.getZipCode(zipname);
    zipCodeController.text = zipcode!;
    setState(() {
      _loadingZipcode = false;
    });
  }

  // bool _loadingProvince = true;
  void getCurrentProvince() async {
    provinces = await api.getProvince();
    countryController.text = 'ไทย';
    log('current provinces: $provinces');
    setState(() {
      provinceItems = provinces;
    });
  }

  Widget dropdownTHProvinceButtonBuilder(
      {required String? value,
      required String label,
      required List<String> items,
      required Function(String?) onChanged}) {
    return DropdownButtonFormField(
      value: value,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(text: label, children: const [
            TextSpan(
              text: '*',
              style: TextStyle(
                color: Colors.red,
              ),
            )
          ]),
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          onChanged(value);
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
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

  @override
  Widget build(BuildContext context) {
    String? sourceOfIncomeValue;
    String? currentOccupationValue;
    Widget? officeNameValue;
    String? typeOfBusinessValue;
    Widget? positionValue;
    String? salaryValue;
    const space = SizedBox(width: 10);
    final sourceOfIncome = dropdownTHProvinceButtonBuilder(
        value: sourceOfIncomeValue,
        label: model.sourceOfIncomeSubject,
        items: _sourceOfIncomeItems,
        onChanged: (value) {
          setState(() {
            occupation.sourceOfIncome =value!;
          });
        });

    final currentOccupation = dropdownTHProvinceButtonBuilder(
        value: currentOccupationValue,
        label: model.currentOccupationSubject,
        items: _sourceOfIncomeItems,
        onChanged: (value) {
          setState(() {
            occupation.currentOccupation =value!;
          });
        });

    officeNameValue = misc.importantTextField(
        textController: officeNameController,
        errorTextCondition: _officeNameCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.officeNameSubject),
        subject: model.officeNameSubject,
        onchangedFunction: (value) {
          setState(() {
            occupation.officeName =value;
          });
        },
        filterPattern: model.allfilter);

    final typeOfBusiness = dropdownTHProvinceButtonBuilder(
        value: typeOfBusinessValue,
        label: model.typeOfBusinessSubject,
        items: _typeOfBusinessItems,
        onChanged: (value) {
          setState(() {
            occupation.typeOfBusiness =value!;
          });
        });

    positionValue = misc.importantTextField(
        textController: positionNameController,
        errorTextCondition: _positionNameCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.positionSubject),
        subject: model.positionSubject,
        onchangedFunction: (value) {
          setState(() {
            occupation.positionName = value;
          });
        },
        filterPattern: model.allfilter);

    final salary = dropdownTHProvinceButtonBuilder(
        value: salaryValue,
        label: model.salarySubject,
        items: _salaryItems,
        onChanged: (value) {
          setState(() {
            occupation.salaryRange = value!;
          });
        });

    final tambonDropdown = dropdownTHProvinceButtonBuilder(
      value: thTambonValue,
      label: thTambonLable,
      items: tambonItems,
      onChanged: (String? value) {
        setState(() {
          thTambonValue = value;
          getCurrentZipcode();
        });
        if (_loadingZipcode) {
          return const CircularProgressIndicator();
        }
      },
    );

    final amphureDropdown = dropdownTHProvinceButtonBuilder(
      value: thAmphureValue,
      label: thAmphureLable,
      items: amphureItems,
      onChanged: (String? value) {
        setState(() {
          thAmphureValue = value;
          getCurrentTambon();
        });
        if (_loadingTambon) {
          return const CircularProgressIndicator();
        }
      },
    );

    final provinceDropdown = dropdownTHProvinceButtonBuilder(
      value: thProvinceValue,
      label: thProvinceLable,
      items: provinceItems,
      onChanged: (String? value) {
        setState(
          () {
            thProvinceValue = value;
            getCurrentAmphure();
            // thAmphureValue = amphureItems.first;
          },
        );
        if (_loadingAmphure) {
          return const CircularProgressIndicator();
        }
      },
    );

    final zipcodeTextField = misc.importantTextField(
        textController: zipCodeController,
        errorTextCondition: _zipcodeErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.zipcodeSubject),
        subject: model.zipcodeSubject,
        filterPattern: model.numberfilter);

    final countryTextField = misc.importantTextField(
        textController: countryController,
        errorTextCondition: _countryErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.countrySubject),
        subject: model.countrySubject,
        filterPattern: model.allfilter);

    final homeNumberTextField = misc.importantTextField(
        textController: homeNumberController,
        errorTextCondition: _homeNumberErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.homeNumberSubject),
        subject: model.homeNumberSubject,
        filterPattern: RegExp(r'[0-9/-]'));
    final villageNumberTextField = misc.importantTextField(
        textController: villageNumberController,
        errorTextCondition: _villageNumberErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.villageNoSubject),
        subject: model.villageNoSubject,
        filterPattern: model.numberfilter,
        isimportant: false);
    final villageNameTextField = misc.importantTextField(
        textController: villageNameController,
        errorTextCondition: _villageNameErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.villageNameSubject),
        subject: model.villageNameSubject,
        filterPattern: model.allfilter,
        isimportant: false);
    final subStreetNameTextField = misc.importantTextField(
        textController: subStreetNameController,
        errorTextCondition: _subStreetNameErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.subStreetSubject),
        subject: model.subStreetSubject,
        filterPattern: model.allfilter,
        isimportant: false);
    final streetNameTextField = misc.importantTextField(
        textController: streetNameController,
        errorTextCondition: _streetNameErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.streetSubject),
        subject: model.streetSubject,
        filterPattern: model.allfilter,
        isimportant: false);

    return Container(
      width: MediaQuery.of(context).size.width * displayWidth,
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(
            .3,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              RichText(
                text: const TextSpan(
                  text: 'อาชีพปัจจุบันแลหะแหล่งที่มาของเงินลงทุน',
                  style: TextStyle(
                      fontSize: 25,
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
          const HighSpace(height: 20),
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
          const HighSpace(height: 20),
          Row(
            children: [
              const Icon(Icons.location_on),
              misc.subjectRichText(subject: 'ที่ตั้งที่ทำงาน', fontsize: 25),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 2,
                child: ListTile(
                  title: const Text('ที่อยู่ตามบัตรประชาชน'),
                  leading: Radio<OfficeAddress>(
                    value: OfficeAddress.registered,
                    groupValue: _currentAddress,
                    onChanged: (OfficeAddress? value) {
                      setState(() {
                        _currentAddress = value;
                        // othersAddress.typeOfAddress = 'r';
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ListTile(
                  title: const Text('ที่อยู่ปัจจุบัน'),
                  leading: Radio<OfficeAddress>(
                    value: OfficeAddress.currentAddress,
                    groupValue: _currentAddress,
                    onChanged: (OfficeAddress? value) {
                      setState(() {
                        _currentAddress = value;
                        // othersAddress.typeOfAddress = 'c';
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ListTile(
                  title: const Text('ที่อยู่อื่น (โปรดระบุ)'),
                  leading: Radio<OfficeAddress>(
                    value: OfficeAddress.others,
                    groupValue: _currentAddress,
                    onChanged: (OfficeAddress? value) {
                      setState(() {
                        _currentAddress = value;
                        // othersAddress.typeOfAddress = 'o';
                        getCurrentProvince();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          (_currentAddress == OfficeAddress.others)
              ? Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(flex: 3, child: homeNumberTextField),
                        const SizedBox(width: 10),
                        Expanded(flex: 1, child: villageNumberTextField),
                        const SizedBox(width: 10),
                        Expanded(flex: 3, child: villageNameTextField),
                        const SizedBox(width: 10),
                        Expanded(flex: 3, child: subStreetNameTextField),
                        const SizedBox(width: 10),
                        Expanded(flex: 3, child: streetNameTextField),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(flex: 3, child: tambonDropdown),
                        const SizedBox(width: 10),
                        Expanded(flex: 3, child: amphureDropdown),
                        const SizedBox(width: 10),
                        Expanded(flex: 3, child: provinceDropdown),
                        const SizedBox(width: 10),
                        Expanded(flex: 3, child: zipcodeTextField),
                        const SizedBox(width: 10),
                        Expanded(flex: 3, child: countryTextField),
                      ],
                    ),
                  ],
                )
              : const Column()
        ],
      ),
    );
  }
}

class IncomeDropdownButton extends StatefulWidget {
  const IncomeDropdownButton({super.key});

  @override
  State<IncomeDropdownButton> createState() => _IncomeDropdownButtonState();
}

const List<String> incomeLists = <String>[
  'รายรับประจำ',
  'รายรับพิเศษ',
  'ค่าเช่า / ขายของ',
  'เงินโบนัส / เงินรางวัล',
  'กำไรจากการลงทุน',
  'เงินออม',
];

class _IncomeDropdownButtonState extends State<IncomeDropdownButton> {
  String incomeDropdownValue = incomeLists.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        label: RichText(
          text: const TextSpan(
            text: 'แหล่งที่มาของรายได้',
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
      ),
      // iconSize: 0,
      alignment: Alignment.centerLeft,
      // elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        setState(() {
          incomeDropdownValue = value!;
        });
      },
      items: incomeLists.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class OccupationDropdownButton extends StatefulWidget {
  const OccupationDropdownButton({super.key});

  @override
  State<OccupationDropdownButton> createState() =>
      _OccupationDropdownButtonState();
}

const List<String> occupationLists = <String>[
  'ลูกจ้าง/พนักงานเอกชน',
  'ข้าราชการ/พนักงานรัฐวิสาหกิจ',
  'เจ้าของกิจการ/ค้าขาย',
  'พ่อบ้าน/แม่บ้าน',
  'เกษียณ',
  'นักลงทุน',
  'นักศึกษา',
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

class _OccupationDropdownButtonState extends State<OccupationDropdownButton> {
  String occupationDropdownValue = occupationLists.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        label: RichText(
          text: const TextSpan(
            text: 'อาชีพปัจจุบัน',
            children: [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          occupationDropdownValue = value!;
        });
      },
      items: occupationLists.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
