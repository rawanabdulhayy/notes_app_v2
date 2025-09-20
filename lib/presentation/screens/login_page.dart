import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/logic/sign_up_bloc/signup_bloc.dart';
import 'package:notes_app_firebase/presentation/screens/sign_up_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 135, left: 45, right: 45),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hi, Welcome Back!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  style: TextStyle(color: Colors.white), //Input Text Color
                  //Decoration - label and hintText
                  decoration: InputDecoration(
                    // //Label
                    // labelText: "Email",
                    // labelStyle: TextStyle(color: Colors.white),
                    //Hint Text
                    hintText: "example@gmail.com",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    //background color
                    fillColor: AppColors.secondaryColor,
                    filled: true,
                    //border
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  //extras about textFields:
                  //     enabledBorder: Border when not focused.
                  // focusedBorder: Border when focused.
                  // errorBorder: Border when error is shown.
                  // focusedErrorBorder: Border when error + focused.
                  // border: Default border if none of the above apply.
                  // All use OutlineInputBorder or UnderlineInputBorder.
                ),
                SizedBox(height: 15),
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  style: TextStyle(color: Colors.white), //Input Text Color
                  //Decoration - label and hintText
                  decoration: InputDecoration(
                    // //Label
                    // labelText: "Email",
                    // labelStyle: TextStyle(color: Colors.white),
                    //Hint Text
                    hintText: "Enter Your Password",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    //background color
                    fillColor: AppColors.secondaryColor,
                    filled: true,
                    //border
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  //password specific obscuring
                  obscureText: true,
                ),
              ],
            ),
            SizedBox(height: 80),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    //width and height in elevated buttons -- denoted by minimum size property (width, height)
                    minimumSize: Size(312, 48),
                    backgroundColor: Colors.white, // button background color
                    foregroundColor:
                        AppColors.primaryColor, // text (and icon) color
                    // In textField, borderRadius was nested under the border property, nested under InputDecoration.
                    // In elevated button, borderRadius was nested under the shape property, nested under ElevatedButton,styleFrom.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // rounded corners
                    ),
                  ),
                  child: Text("Login"),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    //width and height in elevated buttons -- denoted by minimum size property (width, height)
                    minimumSize: Size(312, 48),
                    backgroundColor: Colors.white, // button background color
                    foregroundColor:
                        AppColors.primaryColor, // text (and icon) color
                    // In textField, borderRadius was nested under the border property, nested under InputDecoration.
                    // In elevated button, borderRadius was nested under the shape property, nested under ElevatedButton,styleFrom.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // rounded corners
                    ),
                  ),
                  child: Text("Continue with Google"),
                ),
              ],
            ),
            SizedBox(height: 230),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => SignupBloc(FirebaseAuth.instance),
                        child: SignUpPage(),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
