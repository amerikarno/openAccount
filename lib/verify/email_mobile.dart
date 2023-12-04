import 'package:flutter/material.dart';

import 'package:ico_open/config/config.dart';

enum IsFATCA { yes, no }


class VerifyEmailMobile extends StatefulWidget {
  const VerifyEmailMobile({super.key});

  @override
  State<VerifyEmailMobile> createState() => _VerifyEmailMobileState();
}

class _VerifyEmailMobileState extends State<VerifyEmailMobile> {
  // IsFATCA? _isFATCA = IsFATCA.no;
  // final TextEditingController _homeNumber = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
bool isEmailEditable = true;
bool isMobileEditable = true;
  @override
  void initState() {
    super.initState();
    mobileNo.text = '01234567789';
    email.text = 'test@example.com';
  }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.phone_iphone,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      readOnly: isMobileEditable,
                      controller: mobileNo,
                      decoration: const InputDecoration(
                        label: Text(
                          '1.ยืนยันหมายเลขโทรศัพท์ของท่านผ่าน OTP',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      onSaved: (value){
                        mobileNo.text = value!;
                        setState(() {
                          isEmailEditable = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.grey.withOpacity(.5),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isMobileEditable = false;
                    });
                  },
                  child: const Text(
                    'แก้ไข',
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.orange.withOpacity(.5),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'ยืนยัน',
                  ),
                ),
              ),
              const Expanded(
                flex: 10,
                child: SizedBox(),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.email,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      readOnly: isEmailEditable,
                      controller: email,
                      decoration: const InputDecoration(
                        label:  Text(
                      '2.ยืนยันอีเมลของท่าน',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.grey.withOpacity(.5),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isEmailEditable = false;
                    });
                  },
                  child: const Text(
                    'แก้ไข',
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.orange.withOpacity(.5),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'ยืนยัน',
                  ),
                ),
              ),
              const Expanded(
                flex: 10,
                child: SizedBox(),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class CustomerRisksDropdownButton extends StatefulWidget {
  const CustomerRisksDropdownButton({super.key});

  @override
  State<CustomerRisksDropdownButton> createState() =>
      _CustomerRisksDropdownButtonState();
}

const List<String> customerRiskLists = <String>[
  'เสี่ยงต่ำ',
  'เสี่ยงปานกลางค่อนข้างต่ำ',
  'เสี่ยงปานกลางค่อนข้างสูง',
  'เสี่ยงสูง',
  'เสี่ยงสูงมาก',
];

class _CustomerRisksDropdownButtonState
    extends State<CustomerRisksDropdownButton> {
  String customerRiskDropdownValue = customerRiskLists.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        label: Text(
          'เลือกระดับความเสี่ยงประเภทนักลงทุน',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
      iconSize: 0,
      alignment: Alignment.centerLeft,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        setState(() {
          customerRiskDropdownValue = value!;
        });
      },
      items: customerRiskLists.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class SuitableTest extends StatelessWidget {
  const SuitableTest({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
              'กรุณาเลือกข้อที่ตรงกับท่านมากที่สุดเพื่อท่านจะได้ทราบว่าท่านเหมาะที่จะลงทุนในทรัพย์สินประเภทใด'),
          content: SizedBox(
            width: (MediaQuery.of(context).size.width * 0.6),
            child: const SingleChildScrollView(
              padding: EdgeInsetsDirectional.all(paddingValue),
              child: Text(agreement),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
              },
              child: const Text(
                'OK',
              ),
            ),
          ],
        ),
      ),
      child: const Text(
        'ศึกษาหรือแก้ไขรายละเอียดแบบประเมิน',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15,
          color: Colors.orange,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

const String agreement = "agreement";
