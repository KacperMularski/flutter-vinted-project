import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_firebase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await AuthFirebase().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (_controllerPassword.text != _controllerConfirmPassword.text) {
      setState(() {
        errorMessage = 'Hasła nie są identyczne.';
      });
      return;
    }
    try {
      await AuthFirebase().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return Text(isLogin ? 'Logowanie' : 'Rejestracja');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    bool isPassword,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: title,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole jest wymagane';
        }
        if (isPassword && value.length < 6) {
          return 'Hasło musi mieć co najmniej 6 znaków';
        }
        return null;
      },
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Błąd: $errorMessage');
  }

  final _formKey = GlobalKey<FormState>();
  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          isLogin
              ? signInWithEmailAndPassword()
              : createUserWithEmailAndPassword();
        }
      },
      child: Text(isLogin ? 'Zaloguj' : 'Zarejestruj'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
          isLogin
              ? 'Nie posiadasz konta? Zarejestruj się'
              : 'Masz już założone konto? Zaloguj się',
          style: TextStyle(color: Colors.black)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _entryField('Email', _controllerEmail, false),
              _entryField('Hasło', _controllerPassword, true),
              if (!isLogin)
                _entryField(
                    'Potwierdź hasło', _controllerConfirmPassword, true),
              _errorMessage(),
              _submitButton(),
              _loginOrRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}
