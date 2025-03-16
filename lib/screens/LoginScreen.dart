import 'package:flutter/material.dart';
import 'package:quran_project/screens/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var username = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF785447),
        title: Text("Muslim"),
      ),
      body: Stack(
        children: [
          //Positioned.fill(
          SizedBox.expand(
            child: Image.network(
              "images/pexels-a-darmel-8164743.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              height: 300,
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      labelText: "User Name",
                      hintText: "User Name",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),

                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: Icon(Icons.key),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },

                        icon: Icon(
                          _isObscure
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      hintText: "Password",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 's1');
                    },
                    color: Colors.brown,
                    child: Text("Login"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          // Go to the recording screen when you press the button
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
