import 'package:flutter/material.dart';
import 'package:kidscustomer/auth/user_auth_sceen.dart';
import 'package:kidscustomer/style/color_container.dart';
import 'otp.dart';

class Phone extends StatefulWidget {
  static const String routeName = "Phone";

  const Phone({super.key});

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  TextEditingController phonec = TextEditingController();

  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Number"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, UserAuth.routeName);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: ColorsContainers(
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Form(
              key: form,
              child: TextFormField(
                autofocus: true,
                validator: (value) {
                  const String phonePattern = r'^(?:[+0][1-9])?[0-9]{11}$';
                  final regExp = RegExp(phonePattern);
                  if (value == null || value.isEmpty) {
                    return "Enter your phone number";
                  } else if (!regExp.hasMatch(value)) {
                    return "Enter a correct number";
                  }

                  return null;
                },
                controller: phonec,
                maxLength: 13,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    hintText: "+20 000 000 000",
                    constraints: BoxConstraints(maxWidth: 400),
                    label: Text(
                      "Enter your Phone number ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    //     floatingLabelBehavior: FloatingLabelBehavior.auto,
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    border: OutlineInputBorder()),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (form.currentState!.validate()) {
                  Navigator.pushReplacementNamed(context, OTP.routeName,
                      arguments: phonec.text);
                }
              },
              child: const Text("Send Code"))
        ]),
      ),
    );
  }

  @override
  void dispose() {
    // ignore: avoid_print
    print("dispose  phone c");
    phonec.dispose();
    super.dispose();
  }
}
