import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:ico_open/config/config.dart';
import 'package:ico_open/personal_info/api.dart' as api;
import 'package:ico_open/model/model.dart' as model;
import 'package:ico_open/misc/misc.dart' as misc;
import 'package:ico_open/personal_info/page.dart';
import 'package:ico_open/personal_info/registered_address.dart' as registered;
import 'package:ico_open/personal_info/widgets.dart';

enum CurrentAddress { registered, others }

class PersonalInformationCurrentAddress extends StatefulWidget {
  const PersonalInformationCurrentAddress({super.key});

  @override
  State<PersonalInformationCurrentAddress> createState() =>
      _PersonalInformationCurrentAddressState();
}

  CurrentAddress? currentAddress = CurrentAddress.registered;
class _PersonalInformationCurrentAddressState
    extends State<PersonalInformationCurrentAddress> {

  final homeNumberController = TextEditingController();
  final villageNumberController = TextEditingController();
  final villageNameController = TextEditingController();
  final subStreetNameController = TextEditingController();
  final streetNameController = TextEditingController();
  final zipCodeController = TextEditingController();
  final countryController = TextEditingController();
  final officeNameController = TextEditingController();
  final positionNameController = TextEditingController();

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
    // print('amphure items: $amphureItems');
  }

  void getCurrentTambon() async {
    tambonItems = await api.getTambon(thAmphureValue);
    setState(() {
      _loadingTambon = false;
    });
    // print('tambon items: $tambonItems');
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
      // thProvinceValue = provinceItems.first;
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

  @override
  Widget build(BuildContext context) {
    // final current = AddressWidget(typeOfAddress: 'current', condition: false,);
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
        errorTextMessage:
            misc.thErrorTextFieldMessage(model.villageNameSubject),
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

    final otherAddressListTile = ListTile(
      title: const Text(model.otherAddressSubject),
      leading: Radio<CurrentAddress>(
        value: CurrentAddress.others,
        groupValue: currentAddress,
        onChanged: (CurrentAddress? value) {
          setState(() {
            currentAddress = value;
            // currentAddress.typeOfAddress = 'current_address';
            getCurrentProvince();
          });
        },
      ),
    );

    final registeredAddressListTile = ListTile(
      title: const Text(model.registeredAddressSubject),
      leading: Radio<CurrentAddress>(
        value: CurrentAddress.registered,
        groupValue: currentAddress,
        onChanged: (CurrentAddress? value) {
          setState(() {
            currentAddress = value;
            // currentAddress.typeOfAddress = 'registered_address';
          });
        },
      ),
    );

    var current = misc.addressFunction(
        titleWidget: '',
        homeWidget: homeNumberTextField,
        villegeNumberWidget: villageNumberTextField,
        villegeNameWidget: villageNameTextField,
        subStreetNameWidget: subStreetNameTextField,
        streetNameWidget: streetNameTextField,
        subDistrictNameWidget: tambonDropdown,
        districtNameWidget: amphureDropdown,
        provinceNameWidget: provinceDropdown,
        zipCodeWidget: zipcodeTextField,
        countryWidget: countryTextField);

    return Container(
      width: MediaQuery.of(context).size.width * displayWidth,
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(.3),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on),
              misc.subjectRichText(
                  subject: model.currentAddressSubject,
                  fontsize: 25,
                  color: Colors.black),
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(flex: 1, child: registeredAddressListTile),
              Expanded(flex: 1, child: otherAddressListTile),
            ],
          ),
          // (registered.positionNameController.text.isNotEmpty)
          //     ? Row(
          //         children: [Text('ที่อยู่ตามบัตรประชาชน: ${registered.homeNumberController.text} ')],
          //       )
          //     : Row(children: [
          //         misc.subjectText(
          //             subject: 'กรุณากรอกข้อมูล: ที่อยู่ตามบัตรประชาชน',
          //             fontsize: 13,
          //             color: Colors.red)
          //       ]),
          (currentAddress == CurrentAddress.others) ? current : const Column()
        ],
      ),
    );
  }
}
