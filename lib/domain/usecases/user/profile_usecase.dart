import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/auth_repository.dart';

class ProfileUsecase {
  final AuthRepository _authRepository;

  ProfileUsecase(this._authRepository);

  Future<User?> execute() async {
    try {

      final response = await _authRepository.getCurrentUserProfile();

      if (response.isSuccess && response.result != null) {
        print('프로필 정보 조회 성공 (Usecase): ${response.result!.name}');
        return response.result;
      } else {
        print('프로필 정보 조회 실패 (Usecase - isSuccess:false or result:null): ${response.message}, 코드: ${response.code}');
        // 이 경우, UI에 메시지를 전달하기 위해 null을 반환하거나 특정 예외를 발생시킬 수 있습니다.
        // 여기서는 null을 반환하여 ViewModel에서 처리하도록 합니다.
        // throw ProfileFetchException(response.message); // 또는 예외 발생
        return null;
      }
    } catch (e) {
      // 네트워크 오류 또는 리포지토리에서 발생한 기타 예외 처리
      print('프로필 정보 조회 유스케이스 실행 중 오류 발생: $e');
      // 필요에 따라 특정 타입의 예외로 변환하여 다시 던지거나 null을 반환합니다.
      // 여기서는 null을 반환합니다.
      // throw ProfileFetchException('프로필 정보를 가져오는 중 오류가 발생했습니다: ${e.toString()}');
      return null;
    }
  }
}