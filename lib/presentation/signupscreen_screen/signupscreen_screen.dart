import 'package:another_flushbar/flushbar.dart';
import 'package:atteventify/presentation/homescreen_page/homescreen_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

class SignupscreenScreen extends StatefulWidget {
  final Function()? onTap;

  SignupscreenScreen({Key? key, this.onTap}) : super(key: key);

  @override
  _SignupscreenScreenState createState() => _SignupscreenScreenState();
}

class _SignupscreenScreenState extends State<SignupscreenScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Sign user up method
  Future<void> signUserUp() async {
    // Showing loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Trying to sign up
    try {
      if (passwordController.text != confirmpasswordController.text) {
        throw FirebaseAuthException(
          code: 'passwords-do-not-match',
          message: 'Passwords do not match',
        );
      }

      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userNameController.text,
        password: passwordController.text,
      );
      print("Signed in with account. UID: ${userCredential.user?.uid}");
      Navigator.pop(context); // Dismiss loading circle
      // Show sign up success message
      showSignUpSuccess(context);

// Navigate to the  home screen after signing up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomescreenPage()), // Replace 'HomePage' with your actual homepage widget
      );
    } on FirebaseAuthException catch (e) {
      // Dismiss loading circle before showing error dialog
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        showErrorDialog(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showErrorDialog(context, 'The account already exists for that email.');
      } else {
        showErrorDialog(context, e.message ?? 'An error occurred');
      }
    } catch (e) {
      // If any other error, show general error
      showErrorDialog(context, e.toString());
    }
  }

  // Function to show error dialog
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
                    _buildUserName(context),
                    SizedBox(height: 24.v),
                    _buildPassword(context),
                    SizedBox(height: 24.v),
                    _buildConfirmPassword(context),
                    Spacer(),
                    _buildSignupButton(context),
                    SizedBox(height: 17.v),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Already have an account",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 10.v),
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
    );
  }

  Widget _buildUserName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: CustomTextFormField(
        controller: userNameController,
        hintText: "Username",
      ),
    );
  }

  Widget _buildPassword(BuildContext context) {
    return Padding(
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
    );
  }

  Widget _buildConfirmPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: CustomTextFormField(
        controller: confirmpasswordController,
        hintText: "Confirm Password",
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
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: signUserUp,
      text: "Sign Up",
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      buttonTextStyle: CustomTextStyles.titleMediumBold_1,
    );
  }
}

void showSignUpSuccess(BuildContext context) {
  Flushbar(
    message: 'Successfully Signed Up',
    backgroundColor: Colors.blueAccent.shade100,
    duration: Duration(seconds: 2),
  )..show(context);
}
