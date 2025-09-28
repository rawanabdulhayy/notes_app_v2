import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/logic/delete_note/delete_notes_bloc.dart';
import 'package:notes_app_firebase/logic/get_notes/get_notes_bloc.dart';
import 'package:notes_app_firebase/logic/login_bloc/login_bloc.dart';
import 'package:notes_app_firebase/logic/login_bloc/login_event.dart';
import 'package:notes_app_firebase/logic/login_bloc/login_state.dart';
import 'package:notes_app_firebase/logic/sign_up_bloc/signup_bloc.dart';
import 'package:notes_app_firebase/presentation/screens/notes_display.dart';
import 'package:notes_app_firebase/presentation/screens/sign_up_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors/app_colors.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //keyboard as an additional layer.
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginStateLoading) {
            showDialog(
              context: context,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is LoginStateLoaded) {
            Navigator.of(context).pop(); // close loader
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Login Successful")));
            // Navigate after login success
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => GetNoteBloc()),
                    BlocProvider(create: (context) => DeleteNotesBloc()),
                  ],
              //       If you wrap NotesDisplay in a MultiBlocProvider inside MaterialPageRoute, then every time you navigate to it, you create brand new bloc instances. That means:
              //   Any state in the blocs is lost.
              //   If you later try to context.read<GetNoteBloc>() in another screen, it might not find it.
              // That’s why sometimes the provider error pops up — Flutter can’t find the bloc in the widget tree you expect.
              // ✅ A common fix is to decide whether your blocs are:
              // Scoped to a single page → then your current approach is fine.
              // App-wide (e.g. you always need GetNotes across multiple screens) → then you should provide them above your MaterialApp, in the root widget.
                  child: NotesDisplay(),
                ),
              ),
            );
            // Navigate to home screen or notes page
          } else if (state is LoginStateError) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
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
                    controller: emailController,
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
                    controller: passwordController,
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
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        context.read<LoginBloc>().add(
                          LoginButtonPressed(email, password),
                        );
                        // ALERT!!! Only navigate after login is successful, inside your BlocListener for LoginBloc, mesh inside the button, because it doesn't account for states.
                        // The button only ever fires the LoginButtonPressed event.
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) {
                        //       return BlocProvider(
                        //         create: (context) => NoteBloc(),
                        //         child: NotesDisplay(),
                        //       );
                        //     },
                        //   ),
                        // );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all fields"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      //width and height in elevated buttons -- denoted by minimum size property (width, height)
                      minimumSize: Size(312, 48),
                      backgroundColor: Colors.white, // button background color
                      foregroundColor:
                          AppColors.primaryColor, // text (and icon) color
                      // In textField, borderRadius was nested under the border property, nested under InputDecoration.
                      // In elevated button, borderRadius was nested under the shape property, nested under ElevatedButton,styleFrom.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          5,
                        ), // rounded corners
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
                        borderRadius: BorderRadius.circular(
                          5,
                        ), // rounded corners
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
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) => SignupBloc(FirebaseAuth.instance),
                            ),
                            BlocProvider(create: (context) => GetNoteBloc()),
                          ],
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
      ),
    );
  }
}
