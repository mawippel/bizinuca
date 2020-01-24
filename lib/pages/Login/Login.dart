import 'package:bizinuca/components/PrimaryInput.dart';
import 'package:bizinuca/components/SecondaryButton.dart';
import 'package:bizinuca/services/FeedBackService.dart';
import 'package:bizinuca/services/authentication_service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;

  handleLogin() async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await AuthenticationService.loginWithEmail(
          email: emailController.text, password: passwordController.text);
      if (response is String) {
        FeedBackService.showAlertDialog(context, "Senha ou email errados");
      } else {
        Navigator.popAndPushNamed(context, '/');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      FeedBackService.showAlertDialog(
          context, "Houve um erro ao tentar logar.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 128,
              width: 128,
              child: Image.asset("images/tacos2.png"),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Bem vindo ao Bizinuca!",
              style: TextStyle(
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            PrimaryInput("Email", TextInputType.emailAddress, emailController),
            SizedBox(
              height: 20,
            ),
            PrimaryInput(
              "Senha",
              TextInputType.text,
              passwordController,
              obscureText: true,
            ),
            SizedBox(
              height: 30,
            ),
            isLoading
                ? FeedBackService.showSpinner(Colors.green)
                : SecondaryButton("Fazer Login", handleLogin),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 40,
              child: FlatButton(
                child: Text(
                  "Cadastre-se",
                  textAlign: TextAlign.center,
                ),
                textColor: Colors.green,
                onPressed: () => Navigator.pushNamed(context, '/signup'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
