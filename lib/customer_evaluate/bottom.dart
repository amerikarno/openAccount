import 'package:flutter/material.dart';
import 'package:ico_open/config/config.dart';
import 'package:ico_open/personal_info/page.dart';
import 'package:ico_open/verify/page.dart';

class CustomerEvaluateBottom extends StatelessWidget {
  final String id;
  const CustomerEvaluateBottom({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // final userid = Widget..id;
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
                            return PersonalInformation(id: id,);
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
              const Text('ย้อนกลับ', style: TextStyle(fontSize: 15),),
              const Expanded(
                flex: 30,
                child: SizedBox(),
              ),
              const Text('ถัดไป', style: TextStyle(fontSize: 15),),
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
                      // print(_lasercodestr);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Verify(id: id);
                          },
                        ),
                      );
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
