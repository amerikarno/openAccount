import 'package:flutter/material.dart';


enum SingingCharacter { single, married, disvorced }

class MarriageStatus extends StatefulWidget {
  const MarriageStatus({super.key});

  @override
  State<MarriageStatus> createState() => _MarriageStatusState();
}

class _MarriageStatusState extends State<MarriageStatus> {
  SingingCharacter? _character = SingingCharacter.single;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          ListTile(
            title: const Text('โสด'),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.single,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('สมรส'),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.married,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('หย่า'),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.disvorced,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
