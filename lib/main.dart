import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/screens/login/change_pw_screen.dart';
import 'package:piethon_team5_fe/screens/login/find_id_screen.dart';
import 'package:piethon_team5_fe/screens/login/login_screen.dart';
import 'package:piethon_team5_fe/screens/patients/patients_screen.dart';
import 'package:piethon_team5_fe/screens/patients/create_new_patient_screen.dart';
import 'package:piethon_team5_fe/screens/register/register_screen.dart';
import 'package:piethon_team5_fe/screens/profile/doctor_profile_screen.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PIEthon3.0 team5',
      home: const LoginScreen(),
      initialRoute: "/login",
      routes: {
        '/login': (context) => const LoginScreen(), //로그인 화면
        '/login/register': (context) => const RegisterScreen(), //회원가입 화면
        '/login/findID': (context) => const FindIdScreen(), //ID 찾기 화면
        '/login/changePW': (context) => const ChangePwScreen(), //비밀번호 재설정 화면
        '/patients': (context) => const PatientsScreen(), // 환자 보기 탭
        '/patients/create': (context) => const CreateNewPatientScreen(), // 환자 생성 화면
        '/profile/doctor': (context) => const DoctorProfileScreen(), // 의사 프로필 화면
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: MainColors.background,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
      ),
    );
  }
}
