import 'package:flutter/material.dart';
import 'package:online_seating_chart/styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
              color: Styles.white,
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
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
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
                  onPressed: () {
                    // Handle login logic here
                    String email = emailController.text;
                    String password = passwordController.text;
                    print('Login with email: $email, password: $password');
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 16),
                // Text("If you don't have an account, click here to sign up"),
                // SizedBox(height: 16),
                // ElevatedButton(
                //   onPressed: () {
                //     // Navigate to signup page
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => SignupPage()),
                //     );
                //   },
                //   child: Text('Signup'),
                // ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class SignupPage extends StatelessWidget {
//   const SignupPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController usernameController = TextEditingController();
//     final TextEditingController passwordController = TextEditingController();
//     final TextEditingController fullNameController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Signup'),
//         titleTextStyle: TextStyle(
//           color: Styles.white,
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//         ),
//         backgroundColor: Styles.primaryColor,
//       ),
//       body: Center(
//         child: FractionallySizedBox(
//           widthFactor: 0.5, // Set the width to half of the screen width
//           child: Container(
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10.0,
//                   spreadRadius: 5.0,
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(bottom: 16.0), // Add margin to the bottom
//                   child: TextField(
//                     controller: usernameController,
//                     decoration: InputDecoration(
//                       labelText: 'Username',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(bottom: 16.0), // Add margin to the bottom
//                   child: TextField(
//                     controller: passwordController,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       border: OutlineInputBorder(),
//                     ),
//                     obscureText: true,
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(bottom: 16.0), // Add margin to the bottom
//                   child: TextField(
//                     controller: fullNameController,
//                     decoration: InputDecoration(
//                       labelText: 'Full Name',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle signup logic here
//                     String username = usernameController.text;
//                     String password = passwordController.text;
//                     String fullName = fullNameController.text;
//                     print('Signup with username: $username, password: $password, full name: $fullName');
//                   },
//                   child: Text('Signup'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }