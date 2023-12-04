// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';

// import 'package:ico_open/misc/misc.dart' as misc;
// import 'package:ico_open/model/model.dart' as model;
// import 'package:ico_open/model/personal_info.dart';
// import 'package:ico_open/personal_info/page.dart';
// import 'package:ico_open/personal_info/api.dart' as api;
// import 'package:ico_open/config/config.dart';

// class RegisteredAddressWidget extends StatefulWidget {
//  const RegisteredAddressWidget({super.key});

//   @override
//   State<RegisteredAddressWidget> createState() => _RegisteredAddressWidgetState();
// }

// bool tambonErrorCondition = false;
//   bool amphureErrorCondition = false;
//   bool provinceErrorCondition = false;
//   bool zipcodeErrorCondition = false;
//   bool countryErrorCondition = false;
//   bool homeNumberErrorCondition = false;
// class _RegisteredAddressWidgetState extends State<RegisteredAddressWidget> {
//   @override
//   void initState() {
//     super.initState();
//     getCurrentProvince();
//     // _loadAddress();
//   }

// // controller variables
//   final homeNumberController = TextEditingController();
//   final villageNumberController = TextEditingController();
//   final villageNameController = TextEditingController();
//   final subStreetNameController = TextEditingController();
//   final streetNameController = TextEditingController();
//   final zipCodeController = TextEditingController();
//   final countryController = TextEditingController();
//   final officeNameController = TextEditingController();
//   final positionNameController = TextEditingController();
// // condition variables
//   // bool tambonErrorCondition = false;
//   // bool amphureErrorCondition = false;
//   // bool provinceErrorCondition = false;
//   // bool zipcodeErrorCondition = false;
//   // bool countryErrorCondition = false;
//   // bool homeNumberErrorCondition = false;
//   final bool _villageNumberErrorCondition = false;
//   final bool _villageNameErrorCondition = false;
//   final bool _subStreetNameErrorCondition = false;
//   final bool _streetNameErrorCondition = false;

//   bool _loadingAmphure = true;
//   bool _loadingTambon = true;
//   bool _loadingZipcode = true;

//   String? thProvinceValue;
//   String? thAmphureValue;
//   String? thTambonValue;
//   String? zipcode;

//   List<String> provinceItems = provinces;
//   final thProvinceLable = 'จังหวัด';
//   final thAmphureLable = 'เขตอำเภอ';
//   List<String> amphureItems = [];
//   final thTambonLable = 'แขวงตำบล';
//   List<String> tambonItems = [];
//   AddressModel? address;
//   // void _loadAddress() {
//   //   switch (widget.typeOfAddress) {
//   //     case 'r':
//   //       address = registeredAddress;
//   //       break;
//   //     case 'c':
//   //       address = currentAddress;
//   //       break;
//   //     case 'o':
//   //       address = othersAddress;
//   //       break;
//   //   }
//   // }

//   Widget dropdownButtonBuilderFunction(
//       {required String? value,
//       required String label,
//       required List<String> items,
//       required Function(String?) onChanged,
//       required bool condition,
//       required String errorText,
//       Function()? onTabFunction}) {
//     return DropdownButtonFormField(
//       value: value,
//       decoration: InputDecoration(
//         errorText: condition ? errorText : null,
//         label: RichText(
//           text: TextSpan(text: label, children: const [
//             TextSpan(
//               text: '*',
//               style: TextStyle(
//                 color: Colors.red,
//               ),
//             )
//           ]),
//         ),
//       ),
//       onChanged: (String? value) {
//         setState(() {
//           onChanged(value);
//         });
//       },
//       onTap: onTabFunction,
//       items: items.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }

//   void getCurrentAmphure() async {
//     amphureItems = await api.getAmphure(thProvinceValue);
//     setState(() {
//       _loadingAmphure = false;
//     });
//     // print('amphure items: $amphureItems');
//   }

//   void getCurrentTambon() async {
//     tambonItems = await api.getTambon(thAmphureValue);
//     setState(() {
//       _loadingTambon = false;
//     });
//     // print('tambon items: $tambonItems');
//   }

//   void getCurrentProvince() async {
//     provinces = await api.getProvince();
//     countryController.text = 'ไทย';
//     // log('current provinces: $provinces');
//     setState(() {
//       provinceItems = provinces;
//       // thProvinceValue = provinceItems.first;
//     });
//   }

//   void getCurrentZipcode() async {
//     final zipname = thProvinceValue! + thAmphureValue! + thTambonValue!;
//     zipcode = await api.getZipCode(zipname);
//     zipCodeController.text = zipcode!;
//     setState(() {
//       _loadingZipcode = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // predefined address methods
//     final homeNumberTextField = misc.importantTextField(
//         textController: homeNumberController,
//         errorTextCondition: homeNumberErrorCondition,
//         errorTextMessage: misc.thErrorMessage(model.homeNumberSubject),
//         subject: model.homeNumberSubject,
//         filterPattern: RegExp(r'[0-9/-]'),
//         onchangedFunction: (value) {
//           if (value.isNotEmpty) {
//             print('not empty: $value');
//             setState(() {
//               address!.homenumber = value;
//               // address!.condition!.homenumber = false;
//             });
//           } else {
//             setState(() {
//               // address!.condition!.homenumber = true;
//             });
//           }
//         });

//     final villageNumberTextField = misc.importantTextField(
//         textController: villageNumberController,
//         errorTextCondition: _villageNumberErrorCondition,
//         errorTextMessage: misc.thErrorMessage(model.villageNoSubject),
//         subject: model.villageNoSubject,
//         filterPattern: model.numberfilter,
//         onchangedFunction: (value) {
//           if (value.isNotEmpty) {
//             print('not empty: $value');
//             setState(() {
//               address!.villageNumber = value;
//             });
//           }
//         },
//         onTabFunction: () {
//           if (homeNumberController.text.isNotEmpty) {
//             setState(() {
//               address!.condition!.homenumber = false;
//             });
//           } else {
//             setState(() {
//               address!.condition!.homenumber = true;
//             });
//           }
//         },
//         isimportant: false);
//     final villageNameTextField = misc.importantTextField(
//         textController: villageNameController,
//         errorTextCondition: _villageNameErrorCondition,
//         errorTextMessage: misc.thErrorMessage(model.villageNameSubject),
//         subject: model.villageNameSubject,
//         filterPattern: model.allfilter,
//         onchangedFunction: (value) {
//           if (value.isNotEmpty) {
//             print('not empty: $value');
//             setState(() {
//               address!.villageName = value;
//             });
//           }
//         },
//         isimportant: false);
//     final subStreetNameTextField = misc.importantTextField(
//         textController: subStreetNameController,
//         errorTextCondition: _subStreetNameErrorCondition,
//         errorTextMessage: misc.thErrorMessage(model.subStreetSubject),
//         subject: model.subStreetSubject,
//         filterPattern: model.allfilter,
//         onchangedFunction: (value) {
//           if (value.isNotEmpty) {
//             print('not empty: $value');
//             setState(() {
//               address!.subStreetName = value;
//             });
//           }
//         },
//         isimportant: false);
//     final streetNameTextField = misc.importantTextField(
//         textController: streetNameController,
//         errorTextCondition: _streetNameErrorCondition,
//         errorTextMessage: misc.thErrorMessage(model.streetSubject),
//         subject: model.streetSubject,
//         filterPattern: model.allfilter,
//         onchangedFunction: (value) {
//           if (value.isNotEmpty) {
//             print('not empty: $value');
//             setState(() {
//               address!.streetName = value;
//             });
//           }
//         },
//         isimportant: false);
//     final tambonDropdown = dropdownButtonBuilderFunction(
//       value: thTambonValue,
//       label: thTambonLable,
//       items: tambonItems,
//       condition: tambonErrorCondition,
//       errorText: misc.thErrorMessage(thTambonLable),
//       onChanged: (value) {
//         setState(() {
//           address!.subDistrictName = value;
//           thTambonValue = value;
//           getCurrentZipcode();
//         });
//         if (_loadingZipcode) {
//           return const CircularProgressIndicator();
//         }
//       },
//     );

//     final amphureDropdown = dropdownButtonBuilderFunction(
//       value: thAmphureValue,
//       label: thAmphureLable,
//       items: amphureItems,
//       condition: amphureErrorCondition,
//       errorText: misc.thErrorMessage(thAmphureLable),
//       onChanged: (String? value) {
//         setState(() {
//           address!.districtName = value;
//           thAmphureValue = value;
//           thTambonValue = null;
//           getCurrentTambon();
//           // if (thTambonValue!.isNotEmpty) {thTambonValue = null;}
//         });
//         if (_loadingTambon) {
//           return const CircularProgressIndicator();
//         }
//       },
//     );

//     final provinceDropdown = dropdownButtonBuilderFunction(
//       value: thProvinceValue,
//       label: thProvinceLable,
//       items: provinceItems,
//       condition: provinceErrorCondition,
//       errorText: misc.thErrorMessage(thProvinceLable),
//       onChanged: (String? value) {
//         setState(
//           () {
//             address!.provinceName = value;
//             thProvinceValue = value;
//             thAmphureValue = null;
//             thTambonValue = null;
//             getCurrentAmphure();
//           },
//         );
//         if (_loadingAmphure) {
//           return const CircularProgressIndicator();
//         }
//       },
//     );

//     final zipcodeTextField = misc.importantTextField(
//         textController: zipCodeController,
//         errorTextCondition: zipcodeErrorCondition,
//         errorTextMessage: misc.thErrorMessage(model.zipcodeSubject),
//         subject: model.zipcodeSubject,
//         onchangedFunction: (value) {
//           if (value.isNotEmpty) {
//             print('not empty: $value');
//             setState(() {
//               address!.zipcode = int.parse(value);
//               zipcodeErrorCondition = false;
//             });
//           } else {
//             setState(() {
//               zipcodeErrorCondition = true;
//             });
//           }
//         },
//         filterPattern: model.numberfilter);

//     final countryTextField = misc.importantTextField(
//         textController: countryController,
//         errorTextCondition: countryErrorCondition,
//         errorTextMessage: misc.thErrorMessage(model.countrySubject),
//         subject: model.countrySubject,
//         onchangedFunction: (value) {
//           if (value.isNotEmpty) {
//             print('not empty: $value');
//             setState(() {
//               address!.countryName = value;
//               countryErrorCondition = false;
//             });
//           } else {
//             setState(() {
//               countryErrorCondition = true;
//             });
//           }
//         },
//         filterPattern: model.allfilter);

//     return Container(
//       width: MediaQuery.of(context).size.width * displayWidth,
//       padding: const EdgeInsets.all(50),
//       decoration: BoxDecoration(
//           color: Colors.lightBlue.withOpacity(
//             .3,
//           ),
//           borderRadius: const BorderRadius.all(Radius.circular(10))),
//       child: Column(
//         children: [
//           Row(children: [
//             const Icon(Icons.home),
//             misc.subjectRichText(
//                 subject: model.registeredAddressSubject, fontsize: 25)
//           ]),
//           const SizedBox(height: 20),
//           Row(children: [
//             Expanded(flex: 3, child: homeNumberTextField),
//             const SizedBox(width: 10),
//             Expanded(flex: 1, child: villageNumberTextField),
//             const SizedBox(width: 10),
//             Expanded(flex: 3, child: villageNameTextField),
//             const SizedBox(width: 10),
//             Expanded(flex: 3, child: subStreetNameTextField),
//             const SizedBox(width: 10),
//             Expanded(flex: 3, child: streetNameTextField),
//           ]),
//           const SizedBox(height: 20),
//           Row(children: [
//             Expanded(flex: 3, child: tambonDropdown),
//             const SizedBox(width: 10),
//             Expanded(flex: 3, child: amphureDropdown),
//             const SizedBox(width: 10),
//             Expanded(flex: 3, child: provinceDropdown),
//             const SizedBox(width: 10),
//             Expanded(flex: 3, child: zipcodeTextField),
//             const SizedBox(width: 10),
//             Expanded(flex: 3, child: countryTextField),
//           ]),
//         ],
//       ),
//     );
//   }
// }

