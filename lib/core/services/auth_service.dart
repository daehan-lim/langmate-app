import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 현재 사용자 가져오기
  User? get currentUser => _auth.currentUser;

  // 인증 상태 변경 Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 구글로 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print("Google 로그인 시도");
      
      // 구글 로그인 프로세스 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print("Google 로그인 계정 선택 결과: ${googleUser != null ? '성공' : '사용자가 취소함'}");
      
      if (googleUser == null) {
        // 사용자가 취소한 경우, null 반환 (예외 발생하지 않음)
        return null;
      }

      // 구글 인증 정보 가져오기
      print("Google 인증 정보 요청");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print(
        "Google 인증 정보 받음: accessToken=${googleAuth.accessToken != null}, idToken=${googleAuth.idToken != null}",
      );

      // Firebase 인증 정보 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인
      print("Firebase 로그인 시도");
      final userCredential = await _auth.signInWithCredential(credential);
      print("Firebase 로그인 성공: ${userCredential.user?.displayName}");
      
      return userCredential;
    } catch (e) {
      print("Google 로그인 오류 상세 내용: $e");
      // 실제 오류가 발생한 경우에만 예외 발생
      throw Exception("로그인에 실패했습니다. 다시 시도해 주세요");
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      print("로그아웃 시도");
      await _googleSignIn.signOut();
      await _auth.signOut();
      print("로그아웃 성공");
    } catch (e) {
      print("로그아웃 오류: $e");
    }
  }
}