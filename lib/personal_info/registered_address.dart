// import 'package:flutter/material.dart';
// import 'dart:developer';

// import 'package:ico_open/config/config.dart';
// import 'package:ico_open/personal_info/api.dart' as api;
// import 'package:ico_open/personal_info/page.dart'as page;
// import 'package:ico_open/misc/misc.dart' as misc;
// import 'package:ico_open/model/model.dart' as model;
// import 'package:ico_open/personal_info/registered_address_widget.dart';
// import 'package:ico_open/personal_info/widgets.dart';

// class PersonalInformationRegisteredAddress extends StatefulWidget {
//   const PersonalInformationRegisteredAddress({
//     super.key,
//   });

//   @override
//   State<PersonalInformationRegisteredAddress> createState() =>
//       _PersonalInformationRegisteredAddressState();
// }
//   bool homeCondition = false;
//     // var registeredAddressWidget = AddressWidget(typeOfAddress: 'r',condition: homeCondition);
// class _PersonalInformationRegisteredAddressState
//     extends State<PersonalInformationRegisteredAddress> {

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
//           child: const RegisteredAddressWidget(),
//     );
//   }
// }
