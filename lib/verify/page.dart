import 'package:flutter/material.dart';

import 'package:ico_open/config/config.dart';
import 'package:ico_open/verify/bottom.dart';
import 'package:ico_open/verify/email_mobile.dart';

// enum CurrentAddress { registered, others }

// const double displayWidth = 0.6;

class Verify extends StatefulWidget {
  final String id;
  const Verify({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  // CurrentAddress? _currentAddress = CurrentAddress.registered;
  // final TextEditingController _homeNumber = TextEditingController();
  // final TextEditingController _thsurname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _userid = widget.id;
    double _height = 50;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HighSpace(height: _height),
              const VerifyHeader(),
              const HighSpace(height: 20),
              const Text(
                'กรุณายืนยันหมายเลข "โทรศัพท์" และ "อีเมล์" ของท่าน',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                ),
              ),
              const HighSpace(height: 20),
              const VerifyEmailMobile(),
              HighSpace(height: _height),
              // VerifyResults(),
              // HighSpace(height: _height),
              // CustomerFATCA(),
              // HighSpace(height: _height),
              // CustomerAgreement(),
              // HighSpace(height: _height),
              // VerifyAdvisors(),
              // HighSpace(height: _height),
              VerifyBottom(id: _userid),
              HighSpace(height: _height),
            ],
          ),
        ),
      ),
    );
  }
}

class HighSpace extends StatelessWidget {
  const HighSpace({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class VerifyHeader extends StatelessWidget {
  const VerifyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * displayWidth,
      padding: const EdgeInsets.all(pagePaddingValue),
      decoration: BoxDecoration(
          color: Colors.lightGreen.withOpacity(
            .3,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: const Text(
        'ยืนยันหมายเลขโทรศัพท์ และ อีเมล',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
