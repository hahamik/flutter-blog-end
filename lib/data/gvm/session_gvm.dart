import 'package:flutter/material.dart' show ScaffoldMessenger, Text, SnackBar, Navigator;
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/model/user.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/ui/pages/auth/join_page/join_fm.dart';
import 'package:flutter_blog/ui/pages/auth/login_page/login_fm.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// 1. 창고 관리자
final sessionProvider = NotifierProvider<SessionGVM, SessionModel>(() {
  // 의존하는 VM

  return SessionGVM();
});

/// 2. 창고 (상태가 변경되어도, 화면 갱신 안함 - watch 하지마)
class SessionGVM extends Notifier<SessionModel> {
  final mContext = navigatorKey.currentContext!;

  @override
  SessionModel build() {
    return SessionModel();
  }

  Future<void> autoLogin() async {
    String? accessToken = await secureStorage.read(key: "accessToken");

    if (accessToken == null) {
      Navigator.pushNamed(mContext, "/login"); // Splash 페이지 없애고 이동
      return;
    }
    Map<String, dynamic> body = await UserRepository().autoLogin(accessToken);
    if (!body["success"]) {
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("${body["errorMessage"]}")),
      );
      Navigator.pushNamed(mContext, "/login"); // Splash 페이지 없애고 이동
      return;
    }

    User user = User.fromMap(body["response"]);
    user.accessToken = accessToken;

    state = SessionModel(user: user, isLogin: true);

    // 6. dio의 header에 토큰 세팅 (Bearer 이거 붙어 있음)
    dio.options.headers["Authorization"] = user.accessToken;

    // 7. 게시글 목록 페이지 이동
    Navigator.pushNamed(mContext, "/post/list");
  }

  Future<void> join(String username, String email, String password) async {
    Logger().d("username : ${username}, email : ${email}, password : ${password}");
    bool isValid = ref.read(joinProvider.notifier).validate();
    if (!isValid) {
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("유효성 검사 실패입니다")),
      );
      return;
    }

    Map<String, dynamic> body = await UserRepository().join(username, email, password);
    if (!body["success"]) {
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("${body["errorMessage"]}")),
      );
      return;
    }

    Navigator.pushNamed(mContext, "/login");
  }

  Future<void> login(String username, String password) async {
    // 1. 유효성 검사
    Logger().d("username : ${username}, password : ${password}");
    bool isValid = ref.read(loginProvider.notifier).validate();
    if (!isValid) {
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("유효성 검사 실패입니다")),
      );
      return;
    }

    // 2. 통신
    Map<String, dynamic> body = await UserRepository().login(username, password);
    if (!body["success"]) {
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("${body["errorMessage"]}")),
      );
      return;
    }

    // 3. 파싱
    User user = User.fromMap(body["response"]);

    // 4. 토큰을 디바이스 저장 (앱을 다시 시작할 때 자동 로그인 하려고)
    await secureStorage.write(key: "accessToken", value: user.accessToken);

    // 5. 세션모델 갱신
    state = SessionModel(user: user, isLogin: true);

    // 6. dio의 header에 토큰 세팅 (Bearer 이거 붙어 있음)
    dio.options.headers["Authorization"] = user.accessToken;

    // 7. 게시글 목록 페이지 이동
    Navigator.pushNamed(mContext, "/post/list");
  }

  Future<void> logout() async {
    // 1. 토큰 디바이스 제거
    await secureStorage.delete(key: "accessToken");

    // 2. 세션모델 초기화
    state = SessionModel();

    // 3. dio 세팅 제거
    dio.options.headers["Authorization"] = "";

    // 4. login 페이지 이동
    scaffoldKey.currentState!.openEndDrawer();
    Navigator.pushNamedAndRemoveUntil(mContext, "/login", (route) => false);
  }
}

/// 3. 창고 데이터 타입 (불변 아님)
class SessionModel {
  User? user;
  bool? isLogin;

  SessionModel({this.user, this.isLogin = false});

  @override
  String toString() {
    return 'SessionModel{user: $user, isLogin: $isLogin}';
  }
}
