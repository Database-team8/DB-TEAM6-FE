import 'package:ajoufinder/data/dto/login/login_request.dart';
import 'package:ajoufinder/data/dto/login/login_response.dart';
import 'package:ajoufinder/domain/repository/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _authRepository;

  LoginUsecase(this._authRepository);

  Future<LoginResponse> execute({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      // 실제 앱에서는 사용자 정의 예외 또는 특정 오류 DTO를 반환하는 것이 좋습니다.
      // 예: return LoginResponseDto(code: "VALIDATION_ERROR", message: "이메일과 비밀번호를 모두 입력해주세요.", result: "", isSuccess: false);
      throw ArgumentError('이메일과 비밀번호는 비워둘 수 없습니다.');
    }

    final request = LoginRequest(email: email, password: password);

    try {
      final response = await _authRepository.login(request);

      if (response.isSuccess) {
        // 로그인 성공 시, response.result가 sessionId 입니다[1].
        // 이 sessionId는 이후 인증이 필요한 요청의 Cookie 헤더에 사용되어야 합니다.
        // sessionId 저장 및 활용 로직은 이 유스케이스를 호출하는 ViewModel/Presenter 또는
        // 별도의 세션 관리 서비스에서 처리하는 것이 일반적입니다.
        print('로그인 성공 (Usecase): sessionId - ${response.result}');
      } else {
        // 서버에서 isSuccess: false로 응답한 경우
        print('로그인 실패 (Usecase): ${response.message}, 코드: ${response.code}');
      }
      return response;
    } catch (e) {
      // 네트워크 오류, 파싱 오류 등 리포지토리에서 발생한 예외 처리
      print('로그인 유스케이스 실행 중 오류 발생: $e');
      // 이 유스케이스에 특화된 예외로 변환하거나, 기본 오류 응답 DTO를 반환할 수 있습니다.
      // 예: return LoginResponseDto(code: "CLIENT_ERROR", message: "로그인 중 오류가 발생했습니다: ${e.toString()}", result: "", isSuccess: false);
      rethrow; // 호출한 곳에서 예외를 처리하도록 그대로 전파
    }
  }
}