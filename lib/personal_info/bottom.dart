import 'package:flutter/material.dart';
import 'package:ico_open/config/config.dart';
import 'package:ico_open/personal_info/page.dart'as page;
import 'package:ico_open/idcard/page.dart';
import 'package:ico_open/personal_info/registered_address.dart' as r;
import 'package:ico_open/personal_info/registered_address_widget.dart';
// import 'package:ico_open/personal_info/registered_address.dart' as registered;

class PersonalInformationBottom extends StatefulWidget {
  final String id;
  const PersonalInformationBottom({super.key, required this.id});

  @override
  State<PersonalInformationBottom> createState() => _PersonalInformationBottomState();
}

class _PersonalInformationBottomState extends State<PersonalInformationBottom> {
  // final register = registered.PersonalInformationRegisteredAddress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * displayWidth,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: FittedBox(
                  alignment: Alignment.bottomLeft,
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
                flex: 1,
                child: FittedBox(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.orange,
                    onPressed: () {
                      // print('registered home number: ${page.registeredAddress.homenumber} ${page.registeredAddress.villageName} ${page.registeredAddress.subStreetName} ${page.registeredAddress.streetName}, ${page.registeredAddress.typeOfAddress}');
                      // print('current home number: ${page.currentAddress.homenumber}, ${page.currentAddress.typeOfAddress}');
                      // print('others home number: ${page.othersAddress.homenumber}, ${page.othersAddress.typeOfAddress}');
                      // print('occupation: ${page.occupation.sourceOfIncome}, ${page.occupation.currentOccupation}, ${page.occupation.officeName}, ${page.occupation.typeOfBusiness}, ${page.occupation.positionName}, ${page.occupation.salaryRange}');
                      // print('1st bank account: ${page.firstBank.bankAccountID}, ${page.firstBank.bankName}, ${page.firstBank.bankBranchName}, ${page.firstBank.serviceType}');
                      // print('2st bank account: ${page.secondBank.bankAccountID}, ${page.secondBank.bankName}, ${page.secondBank.bankBranchName}, ${page.secondBank.serviceType}');
                      
                      // if (page.registeredAddress.homenumber.isEmpty) {
                      //   setState(() {
                      //     homeNumberErrorCondition = true;
                      //   });
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
        ],
      ),
    );
  }
}
