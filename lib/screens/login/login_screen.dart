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
      child: SizedBox(
        width: 480,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gaps.v10,
            const Text(
              '로그인',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v36,
            //아이디 박스
            TextField(
              controller: _idController,
              // 입력 텍스트 스타일
              style: const TextStyle(
                color: Colors.white, // 입력되는 글자색
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                hintText: '아이디를 입력해주세요',
                hintStyle: const TextStyle(
                  color: MainColors.hinttext, // 힌트 텍스트 색상
                  fontSize: 16.0,
                ),
                filled: true,
                fillColor: MainColors.textfield,

                // 테두리 설정 (둥근 모서리)
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                // 내부 패딩
                contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              ),
            ),
            Gaps.v20,
            //비밀번호 입력 칸
            TextField(
              controller: _passwordController,
              // 입력 텍스트 스타일
              style: const TextStyle(
                color: Colors.white, // 입력되는 글자색
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                hintText: '비밀번호를 입력해주세요',
                hintStyle: const TextStyle(
                  color: MainColors.hinttext, // 힌트 텍스트 색상
                  fontSize: 16.0,
                ),
                filled: true,
                fillColor: MainColors.textfield,

                // 테두리 설정 (둥근 모서리)
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                // 내부 패딩
                contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              ),
            ),
            Gaps.v20,
            GestureDetector(
              onTap: () async {
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
                    '로그인하기',
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
            Gaps.v12,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    '아이디 찾기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Text(
                  ' | ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
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
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Text(
                  ' | ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
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
                      color: Colors.white,
                      fontSize: 12,
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
