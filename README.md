# PIEthon3.0_team5_FE

PIEthon3.0 5팀의 프런트엔드(Flutter) 프로젝트입니다.
*README는 개발 중 계속해서 업데이트하겠습니다.
*커밋 메시지 convention은 따로 정해두지 않았습니다!

# 중요
CORS 설정으로 인해 테스트 시에 (https://spikez.tistory.com/457)를 참고하여 브라우저 관련 설정을 따로 해 주셔야 합니다! 
그렇지 않으면 http 관련 기능이 일부 제대로 동작하지 않을 수 있습니다.

# 파일 트리 설명

### screens

각 화면에 해당하는 코드들입니다.

### widgets

공통적으로 사용되는 위젯 모음입니다.

- gaps.dart : 간격을 나타내는 위젯(SizedBox 이용)
- maincolors.dart : 색상 정의

### functions

- API 연결 관련 함수들 모음
- 그 외 필요한 함수들은 여기에 저장합니다

## provider
상태 관리에는 provider를 사용하기로 결정했습니다. 
이 디렉토리에 provider 코드를 작성하시면 됩니다. 

# Route 관련
- 경로 이름이 필요한 스크린의 경우 main.dart의 MaterialApp에 경로 이름(routes)을 등록한 다음 pushNamed를 이용하여 화면을 전환하도록 구현하고, 
별도의 경로 이름을 지정할 필요 없이 그냥 위로 쌓아도 되는 경우에는 push를 이용해서 화면을 전환하도록 구현하시면 됩니다. 
- MaterialApp의 routes에 들어가는 각각의 경로 이름에는 간단한 주석을 함께 달아 주세요.

# Getting Started

Check requirements by:

```bash
flutter doctor # flutter doctor -v
```

Run by:

```bash
flutter pub get # if needed
flutter run
```

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
