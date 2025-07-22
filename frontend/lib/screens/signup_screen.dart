import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/rounded_button.dart';
import '../widgets/rounded_input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String _errorMessage = '';

  //final String _baseUrl = "http://10.0.2.2:8080/api/auth";

  // for temporarly run app in browser
  final String _baseUrl = "http://localhost:8080/api/auth";

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': _name,
            'email': _email,
            'password': _password,
          }),
        );

        if (response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Registration successful! Please login.')),
            );
            Navigator.pushReplacementNamed(context, '/login');
          }
        } else {
          final responseBody = jsonDecode(response.body);
          setState(() {
            _errorMessage = responseBody.toString();
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: Could not connect to the server.';
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
        title: const Text("Sign Up"),
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
                  "SIGN UP",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 50),
                RoundedInputField(
                  hintText: "Your Name",
                  icon: Icons.person,
                  onSaved: (value) => _name = value!,
                  validator: (value) =>
                      value!.isEmpty ? "Name cannot be empty" : null,
                ),
                const SizedBox(height: 20),
                RoundedInputField(
                  hintText: "Your Email",
                  icon: Icons.email,
                  onSaved: (value) => _email = value!,
                  validator: (value) {
                    if (value!.isEmpty) return "Email cannot be empty";
                    if (!value.contains('@')) return "Enter a valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                RoundedInputField(
                  hintText: "Your Password",
                  icon: Icons.lock,
                  obscureText: true,
                  onSaved: (value) => _password = value!,
                  validator: (value) {
                    if (value!.isEmpty) return "Password cannot be empty";
                    if (value.length < 6)
                      return "Password must be at least 6 characters";
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : RoundedButton(text: "SIGN UP", onPressed: _signup),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: Text(
                    "Already have an account? Login",
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
