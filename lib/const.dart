const String BASE_URL = 'http://localhost:8000'; // 로컬- 배포 후 변경

// 엔드포인트
class ApiEndpoints {
  static const String login = '$BASE_URL/login';
  static const String register = '$BASE_URL/register';
}