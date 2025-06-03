import 'package:ajoufinder/data/dto/user/signup/signup_request.dart';
import 'package:ajoufinder/data/dto/user/signup/signup_response.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';

class SignUpUsecase {
  final UserRepository _userRepository;

  SignUpUsecase(this._userRepository);

  Future<SignUpResponse> execute(SignUpRequest request) async {
    try {
      final response = await _userRepository.signUp(request);

      if (response.isSuccess) {
        print('회원가입 성공 : user id ${response.result}');
        return response;
      } else {
        print('회원가입 실패: ${response.message}, 코드: ${response.code}');
        // 실패 시 예외를 던지거나 null을 반환할 수 있습니다.
        throw Exception('회원가입 실패: ${response.message}');
      }
    } catch (e) {
      // 네트워크 오류 또는 리포지토리에서 발생한 기타 예외 처리
      print('회원가입 유스케이스 실행 중 오류 발생: $e');
      // 필요에 따라 특정 타입의 예외로 변환하여 다시 던지거나 null을 반환합니다.
      rethrow;
    }
  }
}