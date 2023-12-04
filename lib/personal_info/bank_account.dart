import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ico_open/config/config.dart';
import 'package:ico_open/personal_info/page.dart';
import 'package:ico_open/personal_info/widgets.dart';

class PersonalInformationBankAccount extends StatefulWidget {
  const PersonalInformationBankAccount({super.key});

  @override
  State<PersonalInformationBankAccount> createState() =>
      _PersonalInformationBankAccountState();
}

enum isAddedBankAccounts { yes, no }

class _PersonalInformationBankAccountState
    extends State<PersonalInformationBankAccount> {
  isAddedBankAccounts? _bankAccounts = isAddedBankAccounts.no;
  final _bankAccountNo = TextEditingController();
  final _2bankAccountNo = TextEditingController();

  final firstBank = BankAccountWidget(bankNo: '1');
  final secondBank = BankAccountWidget(bankNo: '2');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * displayWidth,
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.lightBlue.withOpacity(
          .3,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.location_on),
              Text(
                'บัญชีธนาคารของท่าน (เพื่อความสะดวกในการถอนเงินและรับเงินปันผล)',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Row(children: [Text('กรุณาระบุชื่อธนาคารก่อนกรอกชื่อสาขา')]),
          firstBank,
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              const Icon(Icons.location_on),
              const Text(
                'เพิ่มบัญชีธนาคารที่ 2 (เพื่อใช้ฝากเงิน)',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Expanded(
                flex: 3,
                child: SizedBox(),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  title: const Text('ใช้'),
                  leading: Radio<isAddedBankAccounts>(
                    value: isAddedBankAccounts.yes,
                    groupValue: _bankAccounts,
                    onChanged: (isAddedBankAccounts? value) {
                      setState(() {
                        _bankAccounts = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  title: const Text('ไม่ใช้'),
                  leading: Radio<isAddedBankAccounts>(
                    value: isAddedBankAccounts.no,
                    groupValue: _bankAccounts,
                    onChanged: (isAddedBankAccounts? value) {
                      setState(() {
                        _bankAccounts = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          (_bankAccounts == isAddedBankAccounts.yes)
              ? Column(
                  children: [
                    const Row(
                      children: [
                        Text('กรุณาระบุชื่อธนาคารก่อนกรอกชื่อสาขา'),
                      ],
                    ),
                  secondBank
                  ],
                )
              : const Column(),
        ],
      ),
    );
  }
}

class BankTitleDropdownButton extends StatefulWidget {
  const BankTitleDropdownButton({super.key});

  @override
  State<BankTitleDropdownButton> createState() =>
      _BankTitleDropdownButtonState();
}

const List<String> bankTitleLists = <String>[
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

class _BankTitleDropdownButtonState extends State<BankTitleDropdownButton> {
  String bankTitleDropdownValue = bankTitleLists.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        label: Text(
          'ธนาคาร',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      // iconSize: 0,
      alignment: Alignment.centerLeft,
      // elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        setState(() {
          bankTitleDropdownValue = value!;
          firstBank.bankName = value;
        });
      },
      items: bankTitleLists.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class BankBranchDropdownButton extends StatefulWidget {
  const BankBranchDropdownButton({super.key});

  @override
  State<BankBranchDropdownButton> createState() =>
      _BankBranchDropdownButtonState();
}

const List<String> bankBranchLists = <String>[
  'รายรับประจำ',
  'รายรับพิเศษ',
  'ค่าเช่า / ขายของ',
  'เงินโบนัส / เงินรางวัล',
  'กำไรจากการลงทุน',
  'เงินออม',
];

class _BankBranchDropdownButtonState extends State<BankBranchDropdownButton> {
  String bankBranchDropdownValue = bankBranchLists.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        label: Text(
          'ชื่อสาขา',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      // iconSize: 0,
      alignment: Alignment.centerLeft,
      // elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        setState(() {
          bankBranchDropdownValue = value!;
          firstBank.bankBranchName =value;
        });
      },
      items: bankBranchLists.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
