import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kidscustomer/auth/text_otp.dart';
// import 'package:kidscustomer/auth/auth_model.dart';
import '../style/color_container.dart';
import '../style/controllers.dart';
import '../widget/appbar_screen.dart';
import 'textfield_otp.dart';

class OTP extends StatefulWidget {
  static const String routeName = "OTP";
  final String phone;

  const OTP(this.phone, {super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  @override
  void initState() {
    // ignore: avoid_print
    print("initState");
    phoneAuth();
    // serviceAuth.phoneAuth(widget.phone, verifId!);
    startTimer();

    super.initState();
  }

  int counter = 60;
  late Timer _timer;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? verifId;
  // ServiceAuth serviceAuth = ServiceAuth();

  void startTimer() {
    setState(() {
      counter = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // ignore: avoid_print
      print(timer.tick);

      if (!mounted || counter == 0) {
        timer.cancel();
      } else {
        setState(() {
          if (counter > 0) {
            counter--;
          }
        });
      }
    });
  }

  bool correct = true;

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print

    return Scaffold(
        appBar: AppBar(
          title: const Text("OTP"),
          centerTitle: true,
        ),
        body: ColorsContainers(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width / 8,
              ),
              const TextOTP(),
              Text(
                widget.phone,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 60,
              ),
              TextFieldOTPWidget(correct: correct),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  children: [
                    const Text("Don't Recive any code ?"),
                    TextButton(
                        onPressed: () {
                          if (counter == 0) {
                            startTimer();
                            phoneAuth();
                            //   serviceAuth.phoneAuth(widget.phone, verifId!);
                          }
                        },
                        child: const Text("send again")),
                    const Spacer(),
                    Text(
                      "$counter",
                      style: const TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 8,
              ),
              ElevatedButton(
                  onPressed: () {
                    sentCode();
                    // serviceAuth.sentCode(verifId, correct);
                  },
                  child: const Text("confirm", style: TextStyle(fontSize: 20))),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // ignore: avoid_print
    print("dispose");
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();
    c5.dispose();
    c6.dispose();
    _timer.cancel();
    super.dispose();
  }

  // phoneAuth();

  void phoneAuth() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        // ignore: avoid_print
        print("ex");
      },
      codeSent: (String verificationId, int? resendToken) async {
        verifId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verifId = verificationId;
      },
    );
  }

  sentCode() async {
    try {
      String smsCode =
          c1.text + c2.text + c3.text + c4.text + c5.text + c6.text;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verifId!, smsCode: smsCode);

      await auth.signInWithCredential(credential).then((value) {
        if (value.user != null && correct) {
          Navigator.pushReplacementNamed(context, AppBarScreen.routeName);
        }
      });
    } catch (ex) {
      setState(() {
        correct = false;
      });
    }
  }
}

class TextFieldOTPWidget extends StatelessWidget {
  const TextFieldOTPWidget({
    super.key,
    required this.correct,
  });

  final bool correct;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextFieldOTP(
            correct: correct, first: true, last: false, controller: c1),
        TextFieldOTP(
            correct: correct, controller: c2, first: false, last: false),
        TextFieldOTP(
            correct: correct, controller: c3, first: false, last: false),
        TextFieldOTP(
            correct: correct, controller: c4, first: false, last: false),
        TextFieldOTP(
            correct: correct, controller: c5, first: false, last: false),
        TextFieldOTP(
            correct: correct, controller: c6, first: false, last: true),
      ],
    );
  }
}
