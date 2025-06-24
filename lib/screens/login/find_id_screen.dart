import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';

class FindIdScreen extends StatefulWidget {
  const FindIdScreen({super.key});

  @override
  State<FindIdScreen> createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

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
                '아이디 찾기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v36,
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
              TextField(
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
              Gaps.v20,
              TextField(
                controller: _firstNameController,
                style: const TextStyle(
                  color: Colors.white,
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
              Gaps.v20,
              GestureDetector(
                onTap: () async {
                    final url = Uri.parse('$BASE_URL/find_id');
                    final body = {
                        "phoneNum": _phoneNumController.text,
                        "name": {
                            "firstName": _firstNameController.text,
                            "lastName": _lastNameController.text,
                        },
                    };

                    final response = await http.post(
                        url,
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode(body),
                    );
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
                      '재설정하기',
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
