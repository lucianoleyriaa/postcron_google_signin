import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    Future showInvalidLoginAlert() {
      return showDialog(
        context: context, 
        builder: (context) {
          return const InvalidLoginAlert();
        }
      );
    }

    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 45),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    primary: const Color.fromARGB(255, 202, 35, 6)
                  ),
                  onPressed: () async {
                    try {
                      final response = await authService.loginWithGoogle();
      
                      if (response.status == 'error' && response.error == 'Something went wrong') {
                        return showInvalidLoginAlert();
                      } else if (response.status == 'error' && response.error == 'The process was cancelled') {
                        return;
                      }
      
                      Navigator.pushReplacementNamed(context, 'app', arguments: {'token': response.token, 'lang': response.lang});
      
                    } catch (e) {
                      return showInvalidLoginAlert();
                    }
                    
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget> [
                      Icon(FontAwesomeIcons.google),
                      SizedBox(width: 8),
                      Text("Continue with google")
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class InvalidLoginAlert extends StatelessWidget {
  const InvalidLoginAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Credenciales invalidas"),
      content: SingleChildScrollView(
        child: ListBody(
          children: const [Text("No se pudo iniciar sesion con google")],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}