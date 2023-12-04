import 'package:flutter/material.dart';

import 'package:ico_open/config/config.dart';
import 'package:ico_open/misc/misc.dart' as misc;
import 'package:ico_open/personal_info/page.dart';
import 'package:ico_open/questions/fatca_information.dart';

enum IsFATCA { yes, no }

class CustomerFATCA extends StatefulWidget {
  final Widget fatcaInformationWidget;
  final bool usPerson;
  const CustomerFATCA(
      {super.key,
      required this.fatcaInformationWidget,
      required this.usPerson});

  @override
  State<CustomerFATCA> createState() => _CustomerFATCAState();
}

class _CustomerFATCAState extends State<CustomerFATCA> {
  IsFATCA? _isFATCA = IsFATCA.no;
  Widget fatcaInformationWidget = const Column();
  bool usPerson = false;
  // final TextEditingController _homeNumber = TextEditingController();

  void loadFatcaInfomationWidget() {
    setState(() {
      fatcaInformationWidget = widget.fatcaInformationWidget;
      usPerson = widget.usPerson;
      // fatcaInformationWidget = Row(children: [Text('test')],);
    });
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
          const Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  child: Text(
                    'กรอกข้อมูล FATCA',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 25, color: Colors.blueAccent),
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
          const HighSpace(height: 20),
          const Text(
            'ข้าพเจ้ามีข้อใดข้อหนึ่งดังนี้',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
            textAlign: TextAlign.left,
          ),
          const Text(
            '- มีสัญชาติอเมริกัน / เกิดที่อเมริกา / มีที่อยู่ในอเมริกาสำหรับพักอาศัยและติดต่อ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          const Text(
            '- โอนเงินเป็นประจำไปบัญชีที่อเมริกา',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.up,
              children: [
                Expanded(
                  flex: 1,
                  child: ListTile(
                    title: const Text(
                      'ใช่',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    leading: Radio<IsFATCA>(
                      value: IsFATCA.yes,
                      groupValue: _isFATCA,
                      onChanged: (IsFATCA? value) {
                        setState(() {
                          _isFATCA = value;
                          loadFatcaInfomationWidget();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListTile(
                    title: const Text(
                      'ไม่ใช่',
                    ),
                    titleAlignment: ListTileTitleAlignment.center,
                    titleTextStyle: const TextStyle(
                      fontSize: 13,
                    ),
                    leading: Radio<IsFATCA>(
                      value: IsFATCA.no,
                      groupValue: _isFATCA,
                      onChanged: (IsFATCA? value) {
                        setState(() {
                          _isFATCA = value;
                        });
                      },
                    ),
                  ),
                ),
                const Expanded(
                  flex: 8,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          (_isFATCA == IsFATCA.yes) ? fatcaInformationWidget : const Column(),
          // const W9FormTable(),
          const Text(
            'ข้าพเจ้าเข้าใจว่าเมื่อข้อมูลข้างต้นเปลี่ยนแปลง ข้าพเจ้าจะแจ้งบริษัทฯในทันที',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
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

class W9FormTable extends StatelessWidget {
  const W9FormTable({super.key});

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
          child: const SingleChildScrollView(
            child: Column(
              children: [
                Row(),
              ],
            ),
          ),
    );
  }
}
