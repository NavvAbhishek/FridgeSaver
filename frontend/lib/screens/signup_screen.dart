import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      const mockToken =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkZsdXR0ZXIgRGV2IiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', mockToken);

      setState(() {
        _isLoading = false;
      });

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
