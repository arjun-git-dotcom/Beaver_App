
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_state.dart';
import 'package:social_media/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:social_media/features/presentation/cubit/credential/credential_state.dart';
import 'package:social_media/features/presentation/pages/main_screen/main_screen.dart';

import 'package:social_media/features/presentation/widgets/bottom_container_widget.dart';
import 'package:social_media/features/presentation/widgets/form_container_widget.dart';
import 'package:social_media/features/presentation/widgets/google_bottom_container_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: BlocConsumer<CredentialCubit, CredentialState>(
          listener: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              BlocProvider.of<AuthCubit>(context).loggedIn();
            }
            if (credentialState is CredentialFailure) {
              toast('Invalid Email and Password');
            }
          },
          builder: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authstate) {
                if (authstate is Authenticated) {
                  return MainScreen(uid: authstate.uid);
                } else {
                  return _bodyWidget(context);
                }
              });
            }
            return _bodyWidget(context);
          },
        ));
  }

  void _login() {
    setState(() {
      isLoggedIn = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .login(email: emailController.text.trim(), password: passwordController.text.trim())
        .then((value) => _clear());

        
  }

  void _clear() {
    emailController.clear();
    passwordController.clear();
    isLoggedIn = false;
  }

  _bodyWidget(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.210,
            ),
            Center(
                child: SvgPicture.asset(
              "assets/beaver-image.svg",
              height: 100,
              width: 100,
            )),
            sizeVer(10),
            FormContainerWidget(
              controller: emailController,
              hintText: "Email",
            ),
            sizeVer(10),
            FormContainerWidget(
              controller: passwordController,
              hintText: "password",
              isPasswordField: true,
            ),
            sizeVer(10),
            BottomContainerWidget(
              text: 'Login',
              color: blueColor,
              onTapListener: () => _login(),
            ),
sizeVer(10),
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 GestureDetector(
                  onTap: ()=>Navigator.pushNamed(context, 'forgotPasswordPage'),
                  child: const Text('Forgot Password?',style: TextStyle(color: blueColor,fontWeight: FontWeight.w400,fontSize: 12),)),
              ],
            ),
            sizeVer(10),
            const Text('or'),
            sizeVer(10),
            GoogleBottomContainerWidget(
              text: 'Sign in with Google',
              color: backgroundColor,
              image: 'assets/google-icon-logo-svgrepo-com.svg',
              onTapListener: () {
                BlocProvider.of<AuthCubit>(context).googleSignIn();
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.210,
            ),
            const Divider(color: primaryColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dont have an account?'),
                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'registerPage', (route) => false);
                        
                  },
                  child: const Text(
                    ' Register',
                    style: TextStyle(color: blueColor),
                  ),
                ),
                sizeVer(10),
                isLoggedIn == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Please wait ',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                          sizeHor(10),
                          const CircularProgressIndicator()
                        ],
                      )
                    : const SizedBox(
                        height: 0,
                        width: 0,
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
