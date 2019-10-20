import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_auth/ui/home.dart';
import 'package:flutter_fire_auth/utils/firebase_auth.dart';
import 'package:toast/toast.dart';

//-----------------------------------
class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // -------- controllers ---------------
  TextEditingController _cadEmail;
  TextEditingController _cadSenha;

  @override
  void initState() {
    super.initState();
    _cadEmail = TextEditingController(text: '');
    _cadSenha = TextEditingController(text: '');
  }

  // ------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            title: Text('Criar conta', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blueGrey[900]),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 90),
                Icon(Icons.person_add, size: 150, color: Colors.white,),
                Divider(),
                Text(
                  'Crie sua conta, é rápido',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                SizedBox(height: 50),
                TextField(
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  decoration: InputDecoration(
                      labelText: 'Seu E-mail',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      border: OutlineInputBorder()),
                  controller: _cadEmail,
                ),
                SizedBox(height: 20),
                TextField(
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    decoration: InputDecoration(
                        labelText: 'Crie uma Senha',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 20),
                        border: OutlineInputBorder()),
                    controller: _cadSenha,
                    obscureText: true),
                SizedBox(height: 20),
                SizedBox(
                  width: 220,
                  height: 50,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.red)),
                      color: Colors.red,
                      child: Text(
                        'Cadastrar',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_cadEmail.text.isEmpty || _cadSenha.text.isEmpty) {
                          Toast.show('Campos vazios!', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          return;
                        } else {
                          FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _cadEmail.text, password: _cadSenha.text);
                          bool res = await AuthProvider().signInWithEmail(
                              _cadEmail.text, _cadSenha.text);
                          Toast.show('Conta criada', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          // LIMPANDO OS CAMPOS
                          _cadEmail.text = '';
                          _cadSenha.text = '';
                          if (!res) {
                            Toast.show('Cadastro falhou!', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          }
                        }
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
