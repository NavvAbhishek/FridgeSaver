import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_input_field.dart';

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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      const mockToken =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkZsdXR0ZXIgRGV2IiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

      // Store the token using shared_preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', mockToken);

      setState(() {
        _isLoading = false;
      });

      // Navigate to home screen, removing all previous routes
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
