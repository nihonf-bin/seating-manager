import 'package:flutter/material.dart';
import 'package:online_seating_chart/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart'; // Import GoRouter

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Seating Chart'),
        titleTextStyle: TextStyle(
          color: Styles.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Styles.primaryColor,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5, // Set the width to half of the screen width
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Handle login logic here
                    String username = emailController.text;
                    String password = passwordController.text;
                    // print('Login with email: $username, password: $password');
                    var url = Uri.parse('http://localhost:3000/api/login');
                    var response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'username': username, 'password': password}),
                    );
                    // print('Response status: ${response.statusCode}');
                    // print('Response body: ${response.body}');
                    
                    var responseBody = jsonDecode(response.body);
                    if (responseBody['success'] == true) {
                      // Navigate to landing page
                      context.go('/landing');
                    } else {
                      // Show popup message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Login Failed'),
                            content: Text('Wrong credentials. Please try again.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}