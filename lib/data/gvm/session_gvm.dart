import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 1. 창고 관리자
final sessionProvider = NotifierProvider<SessionGVM, SessionModel>(() {
  return SessionGVM();
});

/// 2. 창고 상태가 변경되어도 화면 갱신 안함 -> watch 하지 말라는 뜻
class SessionGVM extends Notifier<SessionModel> {
  @override
  SessionModel build() {
    return SessionModel();
  }

  Future<void> join(String usernaem, String email, String password) async {}

  Future<void> login(String usernaem, String password) async {}

  Future<void> logout() async {}
}

/// 3. 창고 데이터 타입
class SessionModel {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionModel({this.id, this.username, this.accessToken, this.isLogin = false});
}
