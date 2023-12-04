import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ico_open/misc/misc.dart' as misc;

Widget importantTextField({
  required TextEditingController textController,
  required bool errorTextCondition,
  required String errorTextMessage,
  required String subject,
  required Pattern filterPattern,
  Function(String)? onsubmittedFunction,
  Function(String)? onchangedFunction,
  Function()? onTabFunction,
  bool? isimportant,
}) {
  isimportant = isimportant ?? true;
  return TextField(
      controller: textController,
      decoration: InputDecoration(
          errorText: errorTextCondition ? errorTextMessage : null,
          label: isimportant
              ? RichText(
                  text: TextSpan(
                    text: subject,
                    style: const TextStyle(fontSize: 12),
                    children: const [
                      TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                )
              : Text(subject, style:const TextStyle(fontSize: 13),)),
      inputFormatters: [
        FilteringTextInputFormatter.allow(filterPattern),
      ],
      onSubmitted: onsubmittedFunction,
      onTap: onTabFunction,
      onChanged: onchangedFunction);
}

Widget subjectText({
  required String subject,
  Color? color,
  double? fontsize,
}) {
  color = color ?? Colors.orange;
  fontsize = fontsize ?? 20;

  return Text(
    subject,
    style: TextStyle(
      fontSize: fontsize,
      color: color,
    ),
  );
}

Widget subjectRichText({
  required String subject,
  Color? color,
  double? fontsize,
}) {
  color = color ?? Colors.black;
  fontsize = fontsize ?? 20;

  return RichText(
    text: TextSpan(
      text: subject,
      style: TextStyle(fontSize: fontsize, color: color),
      children: [
        TextSpan(
          text: (subject.isEmpty) ? '' : '*',
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
}

String thErrorTextFieldMessage(String message) {
  return 'กรุณากรอก $message';
}

String thErrorDropdownMessage(String message) {
  return 'กรุณาเลือก $message';
}

Widget dropdownButtonBuilderFunction(
    {required String? value,
    required String label1,
    required String label2,
    required List<String> items,
    required bool condition,
    required String errorText,
    double? itemHeight,
    Function(String?)? onChanged,
    Function()? onTabFunction}) {
  return DropdownButtonFormField(
    itemHeight: itemHeight?? 50,
    value: value,
    style: const TextStyle(fontSize: 12),
    decoration: InputDecoration(
      errorText: condition ? errorText : null,
      label: RichText(
          text: TextSpan(text: label1, children: [
        TextSpan(text: label2, style: const TextStyle(color: Colors.red))
      ])),
    ),
    onChanged: onChanged,
    onTap: onTabFunction,
    items: items.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

Widget getTitleRow(String titleWidget) {
  return Row(children: [
    const Icon(Icons.home),
    misc.subjectRichText(subject: titleWidget, fontsize: 25)
  ]);
}

Widget addressFunction(
    {required String titleWidget,
    required Widget homeWidget,
    required Widget villegeNumberWidget,
    required Widget villegeNameWidget,
    required Widget subStreetNameWidget,
    required Widget streetNameWidget,
    required Widget subDistrictNameWidget,
    required Widget districtNameWidget,
    required Widget provinceNameWidget,
    required Widget zipCodeWidget,
    required Widget countryWidget}) {
  return Column(children: [
    Row(children: [
      if (titleWidget.isNotEmpty) const Icon(Icons.home),
      misc.subjectRichText(subject: titleWidget, fontsize: 15)
    ]),
    Row(children: [
      Expanded(flex: 3, child: homeWidget),
      const SizedBox(width: 5),
      Expanded(flex: 1, child: villegeNumberWidget),
      const SizedBox(width: 5),
      Expanded(flex: 3, child: villegeNameWidget),
      const SizedBox(width: 5),
      Expanded(flex: 3, child: subStreetNameWidget),
      const SizedBox(width: 5),
      Expanded(flex: 3, child: streetNameWidget),
    ]),
    const SizedBox(height: 10),
    Row(children: [
      Expanded(flex: 4, child: subDistrictNameWidget),
      const SizedBox(width: 5),
      Expanded(flex: 4, child: districtNameWidget),
      const SizedBox(width: 5),
      Expanded(flex: 4, child: provinceNameWidget),
      const SizedBox(width: 5),
      Expanded(flex: 2, child: zipCodeWidget),
      const SizedBox(width: 5),
      Expanded(flex: 2, child: countryWidget),
    ])
  ]);
}

Widget containerWidget(
    Widget customerRiskDropdownWidget, Widget suitableTestWidget, double paddingValue, double displayWidth, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * displayWidth,
    padding: EdgeInsets.all(paddingValue),
    decoration: BoxDecoration(
        color: Colors.lightBlue.withOpacity(
          .3,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10))),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(flex: 1, child: customerRiskDropdownWidget),
            const SizedBox(width: 5),
            suitableTestWidget,
            const Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ],
    ),
  );
}


