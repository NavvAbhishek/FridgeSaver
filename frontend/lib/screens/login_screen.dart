import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String _errorMessage = '';

  //final String _baseUrl = "http://10.0.2.2:8080/api/auth";

  // for temporarly run app in browser
  final String _baseUrl = "http://localhost:8080/api/auth";

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': _email,
            'password': _password,
          }),
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          final token = responseBody['token'];
          final userName = responseBody['name'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          await prefs.setString('user_name', userName);

          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          }
        } else {
          setState(() {
            _errorMessage = 'Error: Invalid credentials. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage =
              'Error: Could not connect to the server. Please check your connection.';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          width: double.infinity,
          height: size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "LOGIN",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 50),
                RoundedInputField(
                  hintText: "Your Email",
                  icon: Icons.email,
                  onSaved: (value) => _email = value!,
                  validator: (value) =>
                      value!.isEmpty ? "Email cannot be empty" : null,
                ),
                const SizedBox(height: 20),
                RoundedInputField(
                  hintText: "Your Password",
                  icon: Icons.lock,
                  obscureText: true,
                  onSaved: (value) => _password = value!,
                  validator: (value) =>
                      value!.isEmpty ? "Password cannot be empty" : null,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : RoundedButton(text: "LOGIN", onPressed: _login),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/signup'),
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
