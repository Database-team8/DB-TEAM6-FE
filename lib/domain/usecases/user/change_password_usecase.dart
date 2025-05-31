import 'package:ajoufinder/data/dto/password/change_password_request.dart';
import 'package:ajoufinder/data/dto/password/change_password_response.dart';
import 'package:ajoufinder/domain/repository/auth_repository.dart';

class ChangePasswordUsecase {
  final AuthRepository _authRepository;

  ChangePasswordUsecase(this._authRepository);

  Future<ChangePasswordResponse> execute({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      // 실제 앱에서는 사용자 정의 예외 또는 특정 오류 DTO를 반환하는 것이 좋습니다.
      // 예: return ChangePasswordResponseDto(code: "VALIDATION_ERROR", message: "모든 필드를 입력해주세요.", result: "", isSuccess: false);
      throw ArgumentError('현재 비밀번호와 새 비밀번호는 비워둘 수 없습니다.');
    } 

    if (currentPassword == newPassword) {
        throw ArgumentError('새 비밀번호는 현재 비밀번호와 달라야 합니다.');
    }

    final request = ChangePasswordRequest(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    try {
      final response = await _authRepository.changePassword(request);

      if (response.isSuccess) {
        print('비밀번호 변경 성공 (Usecase): ${response.message}');
      } else {
        // 서버에서 isSuccess: false로 응답한 경우
        print('비밀번호 변경 실패 (Usecase): ${response.message}, 코드: ${response.code}');
      }
      return response;
    } catch (e) {
      // 네트워크 오류, 파싱 오류 등 리포지토리에서 발생한 예외 처리
      print('비밀번호 변경 유스케이스 실행 중 오류 발생: $e');
      // 이 유스케이스에 특화된 예외로 변환하거나, 기본 오류 응답 DTO를 반환할 수 있습니다.
      // 예: return ChangePasswordResponseDto(code: "CLIENT_ERROR", message: "비밀번호 변경 중 오류: ${e.toString()}", result: "", isSuccess: false);
      rethrow; // 호출한 곳에서 예외를 처리하도록 그대로 전파
    }
  }
}