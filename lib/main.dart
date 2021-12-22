import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/authentication.dart';
import 'package:lu_cse_community/provider/sign_up_provider.dart';
import 'package:lu_cse_community/view/Home/home.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/onboarding.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/reset_password.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/sign_in.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/sign_up.dart';
import 'package:lu_cse_community/view/sign_in_sign_up/varification.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => Authentication()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(414, 837),
        builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LU CSE Community',
          theme: ThemeData(
            textTheme: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme,
            ),
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Exception(
                  massage: "Error",
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return const MiddleOfHomeAndSignIn();
              }
              return const Exception(
                massage: "Loading",
              );
            },
          ),
          routes: {
            "SignIn": (ctx) => const SignIn(),
            "SignUp": (ctx) => const SignUp(),
            "OnBoarding": (ctx) => const OnBoarding(),
            "MiddleOfHomeAndSignIn": (ctx) => const MiddleOfHomeAndSignIn(),
            "ResetPassword": (ctx) => ResetPassword(),
          },
        ),
      ),
    );
  }
}

class Exception extends StatelessWidget {
  const Exception({Key? key, required this.massage}) : super(key: key);
  final String massage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: massage == "Error"
            ? const Text("An error occur")
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class MiddleOfHomeAndSignIn extends StatefulWidget {
  const MiddleOfHomeAndSignIn({Key? key}) : super(key: key);

  @override
  _MiddleOfHomeAndSignInState createState() => _MiddleOfHomeAndSignInState();
}

class _MiddleOfHomeAndSignInState extends State<MiddleOfHomeAndSignIn> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:
          Provider.of<Authentication>(context, listen: false).authStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: mainColor),
          );
        }
        if (snapshot.data != null && snapshot.data!.emailVerified) {
          return const Home();
        }
        return snapshot.data == null
            ? const OnBoarding()
            : const VerificationAndHomeScreen();
      },
    );
  }
}
