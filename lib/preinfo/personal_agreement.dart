import 'package:flutter/material.dart';
import 'package:ico_open/model/personal_agreement.dart';

  bool validatePersonalAgreement = false;
  bool isPersonalAgreementChecked = false;

class CheckboxPersonalAggreement extends StatefulWidget {
  const CheckboxPersonalAggreement({super.key});

  @override
  State<CheckboxPersonalAggreement> createState() =>
      _CheckboxPersonalAggreementState();
}

class _CheckboxPersonalAggreementState
    extends State<CheckboxPersonalAggreement> {

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      if (isPersonalAgreementChecked) {
        return Colors.blue;
      }
      return Colors.grey;
    }

    return CheckboxListTile(
      // contentPadding: const EdgeInsets.all(0),
      activeColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashRadius: 0,
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isPersonalAgreementChecked,
      onChanged: (bool? value) {
        setState(() {
          validatePersonalAgreement = value!;
          isPersonalAgreementChecked = value;
        });
      },
    );
  }
}

class PersonalAgreement extends StatelessWidget {
  const PersonalAgreement({super.key});

  // final Function() func;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('นโยบายความเป็นส่วนตัว'),
          content: SizedBox(
            width: (MediaQuery.of(context).size.width * 0.6),
            child: const SingleChildScrollView(
              padding: EdgeInsetsDirectional.all(15),
              child: Text(agreement),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            StatefulBuilder(builder: (BuildContext context, StateSetter setState) {

            return TextButton(
              onPressed: () {
                print('1: $validatePersonalAgreement, $isPersonalAgreementChecked');
                setState(() {
                  validatePersonalAgreement = true;
                  isPersonalAgreementChecked = true;
                });
                print('2: $validatePersonalAgreement, $isPersonalAgreementChecked');
                Navigator.pop(context, 'OK');
              },
              child: const Text(
                'OK',
              ),
            );
            })
          ],
        ),
      ),
      onFocusChange: (hasFocus) {},
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(EdgeInsets.zero),
        overlayColor: MaterialStatePropertyAll(Colors.transparent),
      ),
      child: const Text('อ่านรายละเอียดเพิ่มเติม'),
    );
  }
}
