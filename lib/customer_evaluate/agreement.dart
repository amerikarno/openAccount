import 'package:flutter/material.dart';

import 'package:ico_open/config/config.dart';
import 'package:ico_open/personal_info/page.dart';

// enum IsFATCA { yes, no }

class CustomerAgreement extends StatefulWidget {
  const CustomerAgreement({super.key});

  @override
  State<CustomerAgreement> createState() => _CustomerAgreementState();
}

class _CustomerAgreementState extends State<CustomerAgreement> {
  // IsFATCA? _isFATCA = IsFATCA.no;
  // final TextEditingController _homeNumber = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * displayWidth,
      padding: const EdgeInsets.all(paddingValue),
      decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(
            .3,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: const  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  child: Text(
                    'กรุณาอ่านและทำเครื่องหมายในช่องสี่เหลี่ยม',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 5,
                ),
              ),
            ],
          ),
          HighSpace(height: 20),
          Row(
            children: [
              AgreementCheckbox(),
              SizedBox(
                width: 5,
              ),
              Text(
                'ข้าพเจ้ามีข้อใดข้อหนึ่งดังนี้',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AgreementCheckbox extends StatefulWidget {
  const AgreementCheckbox({super.key});
  // bool isChecked;
  @override
  State<AgreementCheckbox> createState() => _AgreementCheckboxState();
}

class _AgreementCheckboxState extends State<AgreementCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return Colors.white;
    }

    return Checkbox(
      checkColor: Colors.black,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

// class CustomerRisksDropdownButton extends StatefulWidget {
//   const CustomerRisksDropdownButton({super.key});

//   @override
//   State<CustomerRisksDropdownButton> createState() =>
//       _CustomerRisksDropdownButtonState();
// }

// const List<String> customerRiskLists = <String>[
//   'เสี่ยงต่ำ',
//   'เสี่ยงปานกลางค่อนข้างต่ำ',
//   'เสี่ยงปานกลางค่อนข้างสูง',
//   'เสี่ยงสูง',
//   'เสี่ยงสูงมาก',
// ];

// class _CustomerRisksDropdownButtonState
//     extends State<CustomerRisksDropdownButton> {
//   String customerRiskDropdownValue = customerRiskLists.first;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(
//         label: Text(
//           'เลือกระดับความเสี่ยงประเภทนักลงทุน',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 15,
//           ),
//         ),
//       ),
//       iconSize: 0,
//       alignment: Alignment.centerLeft,
//       elevation: 16,
//       style: const TextStyle(color: Colors.deepPurple),
//       onChanged: (String? value) {
//         setState(() {
//           customerRiskDropdownValue = value!;
//         });
//       },
//       items: customerRiskLists.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }

// class SuitableTest extends StatelessWidget {
//   const SuitableTest({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () => showDialog<String>(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: const Text(
//               'กรุณาเลือกข้อที่ตรงกับท่านมากที่สุดเพื่อท่านจะได้ทราบว่าท่านเหมาะที่จะลงทุนในทรัพย์สินประเภทใด'),
//           content: SizedBox(
//             width: (MediaQuery.of(context).size.width * 0.6),
//             child: const SingleChildScrollView(
//               padding: EdgeInsetsDirectional.all(paddingValue),
//               child: Text(agreement),
//             ),
//           ),
//           actionsAlignment: MainAxisAlignment.center,
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, 'OK');
//               },
//               child: const Text(
//                 'OK',
//               ),
//             ),
//           ],
//         ),
//       ),
//       child: const Text(
//         'ศึกษาหรือแก้ไขรายละเอียดแบบประเมิน',
//         textAlign: TextAlign.left,
//         style: TextStyle(
//           fontSize: 15,
//           color: Colors.orange,
//           decoration: TextDecoration.underline,
//         ),
//       ),
//     );
//   }
// }

// const String agreement = "agreement";
