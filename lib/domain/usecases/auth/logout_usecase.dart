import 'package:ajoufinder/data/dto/auth/logout/logout_response.dart';
import 'package:ajoufinder/domain/repository/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _authRepository;

  LogoutUsecase(this._authRepository);

  Future<LogoutResponse> execute(String accessToken) async {
    if (accessToken.isEmpty) {
      throw ArgumentError('Access token cannot be empty.');
    }

    try {
      final response = await _authRepository.logout(accessToken);

      if (response.isSuccess) {
        print('로그아웃 성공 (Usecase): ${response.message}');
        // 이 시점에서 클라이언트 측 토큰 삭제(CookieService 사용)는
        // 보통 이 유스케이스를 호출한 ViewModel/Presenter에서 처리합니다. 완
        // 유스케이스는 주로 비즈니스 로직(서버와의 통신 조정)에 집중합니다. 
      } else {
        print('로그아웃 실패 (Usecase): ${response.message}, 코드: ${response.code}');
      }
      return response;
    } catch (e) {
      // 리포지토리에서 발생한 예외를 그대로 다시 던지거나,
      // 이 유스케이스에 특화된 예외로 변환하여 던질 수 있습니다.
      print('로그아웃 유스케이스 실행 중 오류 발생: $e');
      // 예: throw LogoutFailedException('서버 로그아웃 중 오류가 발생했습니다: ${e.toString()}');
      rethrow; // 호출한 곳에서 예외를 처리하도록 그대로 전파
    }
  }
}