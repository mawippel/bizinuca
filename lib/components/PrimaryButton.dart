import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPress;
  final String buttonText;
  final Color buttonColor;

  PrimaryButton(this.buttonText, this.onPress, this.buttonColor);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 0),
        child: MaterialButton(
          child: Text(buttonText,
              style: TextStyle(fontSize: 15, color: Colors.white)),
          color: buttonColor,
          onPressed: onPress,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ));
  }
}
