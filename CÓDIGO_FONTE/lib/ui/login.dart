//import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_fire_auth/ui/cadastro.dart';
import 'package:flutter_fire_auth/utils/firebase_auth.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 180.0),
              Center(
                  child: Image.asset('imgs/logo.png')),
              const SizedBox(height: 40.0),
              TextField(
                style: TextStyle(color: Colors.white, fontSize: 25),
                decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                    border: OutlineInputBorder()),
                controller: _emailController,
              ),
              const SizedBox(height: 20.0),
              TextField(
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      border: OutlineInputBorder()),
                  controller: _passwordController,
                  obscureText: true),
              const SizedBox(height: 25.0),
              Center(
                  child: SizedBox(
                    width: 220,
                    height: 40,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.red)),
                      color: Colors.red,
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          Toast.show('Campos vazios', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                          return;
                        }
                        bool res = await AuthProvider().signInWithEmail(
                            _emailController.text, _passwordController.text);
                        if (!res) {
                          Toast.show('E-mail ou senha inválidos', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      },
                    ),
                  )),
              const SizedBox(height: 35.0),
              GoogleSignInButton(
                onPressed: () async {
                  bool res = await AuthProvider().loginWithGoogle();
                  if (!res) Toast.show('Erro no login com o Google', context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                },
                darkMode: false, // default: false
              ),
              SizedBox(height: 25,),
              GestureDetector(
                child: Text(
                  'Não tenho conta',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroPage()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
