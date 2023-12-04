import 'package:flutter/material.dart';

import 'package:ico_open/config/config.dart';

enum PersonalAdvisor { yes, no }

class PersonalInformationAdvisors extends StatefulWidget {
  const PersonalInformationAdvisors({super.key});

  @override
  State<PersonalInformationAdvisors> createState() =>
      _PersonalInformationAdvisorsState();
}

class _PersonalInformationAdvisorsState
    extends State<PersonalInformationAdvisors> {
  PersonalAdvisor? _currentAddress = PersonalAdvisor.no;
  // final TextEditingController _homeNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * displayWidth,
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(
            .3,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on),
              const Text(
                'ท่านมีเจ้าหน้าที่การตลาด (ผู้แนะนำการลงทุน) ที่ต้องการหรือไม่',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  title: const Text('ไม่มี'),
                  leading: Radio<PersonalAdvisor>(
                    value: PersonalAdvisor.no,
                    groupValue: _currentAddress,
                    onChanged: (PersonalAdvisor? value) {
                      setState(() {
                        _currentAddress = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  title: const Text('มี'),
                  leading: Radio<PersonalAdvisor>(
                    value: PersonalAdvisor.yes,
                    groupValue: _currentAddress,
                    onChanged: (PersonalAdvisor? value) {
                      setState(() {
                        _currentAddress = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          // (_currentAddress == PersonalAdvisor.no)
          //     ? Column(
          //         children: [
          //           const SizedBox(
          //             height: 20,
          //           ),
          //           Row(
          //             children: [
          //               Expanded(
          //                 flex: 3,
          //                 child: TextField(
          //                   controller: _homeNumber,
          //                   decoration: const InputDecoration(
          //                     hintText: 'เลขที่',
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 flex: 1,
          //                 child: TextField(
          //                   controller: _homeNumber,
          //                   decoration: const InputDecoration(
          //                     hintText: 'หมู่ที่',
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 flex: 3,
          //                 child: TextField(
          //                   controller: _homeNumber,
          //                   decoration: const InputDecoration(
          //                     hintText: 'หมู่บ้าน',
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 flex: 3,
          //                 child: TextField(
          //                   controller: _homeNumber,
          //                   decoration: const InputDecoration(
          //                     hintText: 'ซอย',
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 flex: 3,
          //                 child: TextField(
          //                   controller: _homeNumber,
          //                   decoration: const InputDecoration(
          //                     hintText: 'ถนน',
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           const SizedBox(
          //             height: 20,
          //           ),
          //           Row(
          //             children: [
          //               Expanded(
          //                 flex: 3,
          //                 child: TextField(
          //                   controller: _homeNumber,
          //                   decoration: const InputDecoration(
          //                     hintText: 'แขวงตำบล',
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 flex: 3,
          //                 child: TextField(
          //                   controller: _homeNumber,
          //                   decoration: const InputDecoration(
          //                     hintText: 'เขตอำเภอ',
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 flex: 3,
          //                 child: TextField(
          //                   controller: _homeNumber,
          //                   decoration: const InputDecoration(
          //                     hintText: 'จังหวัด',
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 flex: 3,
          //                 child: TextField(
          //                   controller: _homeNumber,
          //                   decoration: const InputDecoration(
          //                     hintText: 'รหัสไปรษณีย์',
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 flex: 3,
          //                 child: TextField(
          //                   controller: _homeNumber,
          //                   decoration: const InputDecoration(
          //                     hintText: 'ประเทศ',
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       )
          //     : const Column()
        ],
      ),
    );
  }
}
