import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldOTP extends StatelessWidget {
  final TextEditingController controller;
  final bool last;
  final bool first;
  final bool correct;

  const TextFieldOTP({
    required this.correct,
    required this.controller,
    required this.first,
    required this.last,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(width: 1, color: correct ? Colors.blueGrey : Colors.red),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 30),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 8),
        ),
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          } else if (value.isEmpty && last == true) {}
        },
        textInputAction: TextInputAction.none,
      ),
    );
  }
}
