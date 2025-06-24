// 로그인 화면
// 일단 가운데 박스는 고정 크기로 해두었습니다
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // id 입력 칸 controller
  final TextEditingController _idController = TextEditingController();
  // 비밀번호 입력 칸 controller
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: 480,
        height: 360,
        decoration: ShapeDecoration(
          color: MainColors.window,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Gaps.v10,
            const Text(
              '로그인',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v20,
            //아이디 박스
            TextField(
              controller: _idController,
              // 입력 텍스트 스타일
              style: const TextStyle(
                color: Colors.black87, // 입력되는 글자색
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                hintText: '아이디',
                hintStyle: const TextStyle(
                  color: Colors.black87, // 힌트 텍스트 색상
                  fontSize: 16.0,
                ),
                filled: true,
                fillColor: const Color(0xFFF3F3F3),

                // 테두리 설정 (둥근 모서리)
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                // 내부 패딩
                contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              ),
            ),
            Gaps.v16,
            //비밀번호 입력 칸
            TextField(
              obscureText: true,
              controller: _passwordController,
              style: const TextStyle(
                color: Colors.black87, // 입력되는 글자색
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                hintText: '비밀번호',
                hintStyle: const TextStyle(
                  color: Colors.black87, // 힌트 텍스트 색상
                  fontSize: 16.0,
                ),
                filled: true,
                fillColor: const Color(0xFFF3F3F3),

                // 테두리 설정 (둥근 모서리)
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                // 내부 패딩
                contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              ),
            ),
            Gaps.v16,
            GestureDetector(
              onTap: () async {
                print('버튼눌렸다~~');
                final userId = _idController.text.trim();
                final password = _passwordController.text.trim();

                if (userId.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("아이디와 비밀번호를 모두 입력해주세요.")),
                  );
                  return;
                }

                try {
                  final res = await http.post(
                    Uri.parse('$BASE_URL/login'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'userId': userId,
                      'password': password,
                    }),
                  );

                  if (res.statusCode == 200) {
                    final data = jsonDecode(res.body);
                    print("로그인 성공: $data");
                  } else {
                    print("로그인 실패: ${res.statusCode}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("로그인 실패. 아이디 또는 비밀번호를 확인하세요.")),
                    );
                  }
                } catch (e) {
                  print("에러 발생: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("서버와 통신 중 오류가 발생했습니다.")),
                  );
                }
              },
              child: Container(
                width: 160,
                height: 48,
                decoration: ShapeDecoration(
                  color: const Color(0xFFACB2BC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
            Gaps.v12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    '아이디 찾기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Text(
                  ' | ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    '비밀번호 재설정',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Text(
                  ' | ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    '회원가입하기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
