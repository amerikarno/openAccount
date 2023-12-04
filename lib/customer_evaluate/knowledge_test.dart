import 'package:flutter/material.dart';

import 'package:ico_open/config/config.dart' as config;
import 'package:ico_open/customer_evaluate/page.dart';
import 'package:ico_open/misc/misc.dart' as misc;

// enum KnowledgeTestEnum { yes, no }

class KnowledgeTestWidget extends StatelessWidget {
  final Widget widget1;
  final Widget widget2;
  final Widget widget3;
  const KnowledgeTestWidget({super.key, required this.widget1, required this.widget2, required this.widget3});

  @override
  Widget build(BuildContext context) {
    // KnowledgeTestEnum? knowledgeTestChoice;

    return Container(
        width: MediaQuery.of(context).size.width * config.displayWidth,
        padding: const EdgeInsets.all(config.paddingValue),
        decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(
              .3,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Row(
              children: [
                const Text('ท่านต้องการทำแบบทดสอบความรู้ Knowledge Test',
                    style: TextStyle(fontSize: 20)),
                const SizedBox(width: 20),
                widget1,
                widget2,
              ],
            ),
            widget3,
            // (knowledgeTestChoice)
          ],
        ));
  }
}
