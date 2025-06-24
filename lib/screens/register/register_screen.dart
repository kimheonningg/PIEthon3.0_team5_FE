import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 480,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gaps.v10,
              const Text(
                '회원가입',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v36,
              TextField(
                controller: _emailController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  hintText: '이메일',
                  hintStyle: const TextStyle(
                    color: MainColors.hinttext,
                    fontSize: 16.0,
                  ),
                  filled: true,
                  fillColor: MainColors.textfield,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                ),
              ),
              Gaps.v20,
              TextField(
                controller: _phoneNumController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  hintText: '전화번호',
                  hintStyle: const TextStyle(
                    color: MainColors.hinttext,
                    fontSize: 16.0,
                  ),
                  filled: true,
                  fillColor: MainColors.textfield,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                ),
              ),
              Gaps.v20,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _lastNameController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                        hintText: '성',
                        hintStyle: const TextStyle(
                          color: MainColors.hinttext,
                          fontSize: 16.0,
                        ),
                        filled: true,
                        fillColor: MainColors.textfield,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _firstNameController,
                      style: const TextStyle(
                        color: MainColors.hinttext,
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                        hintText: '이름',
                        hintStyle: const TextStyle(
                          color: MainColors.hinttext,
                          fontSize: 16.0,
                        ),
                        filled: true,
                        fillColor: MainColors.textfield,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      ),
                    ),
                  ),
                ],
              ),
              Gaps.v20,
              TextField(
                controller: _idController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  hintText: '아이디',
                  hintStyle: const TextStyle(
                    color: MainColors.hinttext,
                    fontSize: 16.0,
                  ),
                  filled: true,
                  fillColor: MainColors.textfield,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                ),
              ),
              Gaps.v20,
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  hintStyle: const TextStyle(
                    color: MainColors.hinttext,
                    fontSize: 16.0,
                  ),
                  filled: true,
                  fillColor: MainColors.textfield,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                ),
              ),
              Gaps.v20,
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse('$BASE_URL/register');
                  final body = {
                    "email": _emailController.text,
                    "phoneNum": _phoneNumController.text,
                    "name": {
                      "firstName": _firstNameController.text,
                      "lastName": _lastNameController.text,
                    },
                    "userId": _idController.text,
                    "password": _passwordController.text,
                    "position": "doctor",
                  };
                  try {
                    final response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode(body),
                    );

                    if (response.statusCode == 200 || response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('회원가입 성공')),
                      );
                      Navigator.pop(context); 
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('회원가입 실패: ${response.body}')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('에러 발생: $e')),
                    );
                  }
                },
                child: Container(
                  width: 480,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: MainColors.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '회원가입하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
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
