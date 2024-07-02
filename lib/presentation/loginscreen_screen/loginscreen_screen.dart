import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart'; // ignore_for_file: must_be_immutable

class LoginscreenScreen extends StatefulWidget {
  final Function()? onTap;
  LoginscreenScreen({
    Key? key,
    this.onTap,
  }) : super(
          key: key,
        );

  @override
  State<LoginscreenScreen> createState() => _LoginscreenScreenState();
}

class _LoginscreenScreenState extends State<LoginscreenScreen> {
  TextEditingController userNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Sign user in method
  Future<void> signInUser(BuildContext context) async {
    // Showing loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
    // Trying to sign in
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userNameController.text,
        password: passwordController.text,
      );
      print("Signed in with account. UID: ${userCredential.user?.uid}");
      Navigator.pop(context); // Dismiss loading circle
    } on FirebaseAuthException catch (e) {
      // Dismiss loading circle before showing error dialog
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongEmailMessage(context); // Call wrongEmailMessage function
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage(context); // Call wrongPasswordMessage function
      } else {
        // If other FirebaseAuthException, show general error
        showErrorDialog(context, e.toString());
      }
    } catch (e) {
      // If any other error, show general error
      showErrorDialog(context, e.toString());
    }
  }

// Function to show general error dialog
  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

// Function to show wrong email error dialog
  void wrongEmailMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("No user found for that email."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

// Function to show wrong password error dialog
  void wrongPasswordMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("Wrong password provided for that user."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              height: SizeUtils.height,
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgTteventify1,
                        height: 218.v,
                        width: 390.h,
                      ),
                      SizedBox(height: 26.v),
                      Text(
                        "Welcome",
                        style: theme.textTheme.headlineLarge,
                      ),
                      SizedBox(height: 21.v),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: CustomTextFormField(
                          controller: userNameController,
                          hintText: "Email/Username",
                          textInputType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 24.v),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: CustomTextFormField(
                          controller: passwordController,
                          hintText: "Password",
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.visiblePassword,
                          suffix: Container(
                            margin: EdgeInsets.fromLTRB(30.h, 15.v, 15.h, 17.v),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgDepth6Frame1,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                            ),
                          ),
                          suffixConstraints: BoxConstraints(
                            maxHeight: 56.v,
                          ),
                          obscureText: true,
                          contentPadding: EdgeInsets.only(
                            left: 15.h,
                            top: 16.v,
                            bottom: 16.v,
                          ),
                        ),
                      ),
                      Spacer(),
                      CustomElevatedButton(
                        onPressed: (() {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder:
                          //         AppRoutes.routes[AppRoutes.homescreenPage]!));
                          signInUser(context);
                        }),
                        text: "Log in",
                        margin: EdgeInsets.symmetric(horizontal: 16.h),
                        buttonTextStyle: CustomTextStyles.titleMediumBold_1,
                      ),
                      SizedBox(height: 17.v),
                      SizedBox(height: 14.v),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Don't Have an Account?",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(height: 11.v),
                      Container(
                        height: 20.v,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: appTheme.gray100,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
