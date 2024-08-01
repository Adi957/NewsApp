// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ResetPassword extends StatefulWidget {
//   @override
//   _ResetPasswordState createState() => _ResetPasswordState();
// }

// class _ResetPasswordState extends State<ResetPassword> {
//   final TextEditingController passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     // Retrieve the oobCode from the URL
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final Uri uri = Uri.base; // Get the current URL
//       final String? oobCode = uri.queryParameters['oobCode']; // Extract oobCode

//       if (oobCode != null) {
//         // Store the oobCode for use during password reset
//         _oobCode = oobCode;
//       } else {
//         // Handle case where oobCode is not present
//         Navigator.pop(context);
//       }
//     });
//   }

//   String? _oobCode;

//   Future<void> _resetPassword() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         await FirebaseAuth.instance.confirmPasswordReset(
//           code: _oobCode!,
//           newPassword: passwordController.text,
//         );

//         // Password reset successful
//         Navigator.pop(context);
//         _showSuccessDialog('Your password has been reset successfully.');
//       } on FirebaseAuthException catch (e) {
//         String message;
//         if (e.code == 'invalid-action-code') {
//           message = 'The password reset link is invalid or has expired.';
//         } else if (e.code == 'weak-password') {
//           message = 'The password is too weak.';
//         } else {
//           message = 'An error occurred. Please try again.';
//         }
//         _showErrorDialog(message);
//       } catch (e) {
//         _showErrorDialog('An error occurred. Please try again.');
//       }
//     }
//   }

//   void _showSuccessDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Reset Password"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter new password',
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue, width: 1.0),
//                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a password';
//                   }
//                   if (!RegExp(
//                           r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
//                       .hasMatch(value)) {
//                     return 'Password must be strong';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _resetPassword,
//                 child: const Text("Reset Password"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
