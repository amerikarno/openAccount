import 'package:flutter/material.dart';
import 'package:ico_open/model/personal_info.dart';
import 'package:ico_open/misc/misc.dart' as misc;
import 'package:ico_open/model/model.dart' as model;

class AddressWidget extends StatelessWidget {
  const AddressWidget({super.key, this.setHomeNumberState});
  
  final dynamic Function(String)? setHomeNumberState;

  @override
  Widget build(BuildContext context) {
    final homeNumberController = TextEditingController();
    bool homeNumberErrorCondition = false;
    final homenumber = misc.importantTextField(
        textController: homeNumberController,
        errorTextCondition: homeNumberErrorCondition,
        errorTextMessage: misc.thErrorTextFieldMessage(model.homeNumberSubject),
        subject: model.homeNumberSubject,
        filterPattern: model.allfilter,
        onchangedFunction: setHomeNumberState);

    return Column(children: [

       homenumber,
    ]);
  }
}
