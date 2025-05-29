import 'package:ajoufinder/const/network.dart';
import 'package:ajoufinder/data/dto/logout/logout_response.dart';
import 'package:ajoufinder/data/dto/sign_up/sign_up_request.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/interfaces/cookie_service.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:ajoufinder/domain/usecases/login_usecase.dart';
import 'package:ajoufinder/domain/usecases/logout_usecase.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final CookieService _cookieService;
  final LogoutUsecase _logoutUsecase;
  final LoginUsecase _loginUsecase;

  bool _isLoggedIn = false;
  bool _isLoading = false;
  int? _userUid;
  User? _currentUser;
  String? _authErrorMessage;
  //테스트용 삭제할 것.
  User testUser = User(id: 1, name: '장한', nickname: '닉네임', email: 'egnever4434@naver.com', password: '1234', role: 'common', updatedAt: DateTime(2002, 10, 12, 23, 59, 59, 99, 0), joinDate: DateTime(2002, 10, 12, 23, 59, 59, 99, 0), phoneNumber: "010-5560-8529", profileImage: "https://siape.veta.naver.com/fxclick?eu=EU10043565&calp=-&oj=cQgn6aire5OCkDs5f7%2BPJ4O3qbsJzHyS0J7a3X2KOumz1M2JFLhyvOvzYS65R9Xj3Uyod%2FLw9f3rv0E7yis2wh8iAc05TbugzxX%2F41dsXFH5WgZkric4e%2FVJwo5hKV6wctRzZMZGLy7qAnSQcXmU%2Fev47hlmG9S2wq%2BDrzLexRocWl11sYqmqvwcBMOjcOaeQ5sJneYKbTkYZfOumM9ijpPqnfPpxiGrWcs4F74%2BEyPgy%2BoloYhsMxvwkG6KJVxRjvkZRxz8a72A9FlU06lTryrSgAhsix95uXbdwcWSqXpgkKVnhxT4LG6zPv6Fpkja9VUn3aD3j4thSAlb2ZdUtI8t97sD5Cf8V%2BfrBROaCPKqr%2FQPXbJd%2FN%2F4hBpY8cGM&ac=9120481&src=7597723&br=4735566&evtcd=P901&x_ti=1505&tb=&oid=&sid1=&sid2=&rk=Ke2G5X5Z-FTEs-vCLRXToA&eltts=tJM52nE%2BLRD%2FYUZwXtZdrw%3D%3D&brs=Y&");

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  int? get userUid => _userUid;
  User? get currentUser => _currentUser;
  String? get authErrorMessage => _authErrorMessage;

  AuthViewModel(this._userRepository, this._cookieService, this._logoutUsecase, this._loginUsecase) {
    checkLoginStatusOnStartup();
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _updateAuthState({
    required bool isLoggedIn,
    User? user,
    String? errorMessage,
  }) {
    _isLoggedIn = isLoggedIn;
    _currentUser = user;
    _userUid = user?.id;
    _authErrorMessage = errorMessage;
    notifyListeners();
  }

  Future<bool> _fetchAndSetUser(String cookie) async {
    try {
      final User? fetchedUser = await _userRepository.findByAccessToken(cookie);
      if (fetchedUser != null) {
        _updateAuthState(isLoggedIn: true, user: fetchedUser);
        print('AuthViewModel: 사용자 정보 로드 성공 - ID: ${fetchedUser.id}');
        return true;
      } else {
        print('AuthViewModel: 사용자를 찾을 수 없습니다. ID: $cookie');
        // 사용자를 못 찾으면 로그아웃 상태로 처리
        await _clearAuthDataAndNotify(errorMessage: '사용자 정보를 찾을 수 없습니다.');
        return false;
      }
    } catch (e) {
      print('AuthViewModel: 사용자 정보 로드 중 오류: $e');
      await _clearAuthDataAndNotify(errorMessage: '사용자 정보 로드 중 오류가 발생했습니다.');
      return false;
    }
  }

  Future<void> _clearAuthDataAndNotify({String? errorMessage}) async {
    await _cookieService.deleteCookie(cookieName); 
    _updateAuthState(isLoggedIn: false, user: null, errorMessage: errorMessage);
  }

  Future<void> checkLoginStatusOnStartup() async {
    _setLoading(true);
    _authErrorMessage = null;

    try {
      final accessToken = await _cookieService.getCookie(cookieName);

      if (accessToken != null && accessToken.isNotEmpty) {
        User? user = await _userRepository.findByAccessToken(accessToken);

        if (user != null) {
          _updateAuthState(isLoggedIn: true, user: user);
          print('AuthViewModel: 세션을 통해 로그인 상태 복원 성공 - 사용자: ${user.name}');
        } else {
          await _clearAuthDataAndNotify(errorMessage: '세션이 만료되었거나 유효하지 않습니다.');
        }
      } else {
        _updateAuthState(isLoggedIn: false);
      }
    } catch (e) {
      print("Error checking login status: $e");
      await _clearAuthDataAndNotify(errorMessage: '로그인 상태 확인 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login({required String email, required String password}) async {
    _setLoading(true);
    _authErrorMessage = null;

    try {
      final response = await _loginUsecase.execute(email: email, password: password);

      if (response.isSuccess) {
        final sessionId = response.result;
        await _cookieService.setCookie(cookieName, sessionId, maxAgeInSeconds: 60 * 60 * 5);
        final cookie = await _cookieService.getCookie(cookieName);

        // 쿠키 활용하는 구조로 바꾸기
        if (cookie == null) {
          await _clearAuthDataAndNotify(errorMessage: '잘못된 사용자 ID 형식입니다.');
        } else {
          await _fetchAndSetUser(cookie);
          print('AuthViewModel: 로그인 성공');
        }
      } else {
        _clearAuthDataAndNotify(errorMessage:  response.message);
        print('AuthViewModel: 로그인 실패 - ${response.message} (코드: ${response.code})');
      }
    } on ArgumentError catch (e) {
      _clearAuthDataAndNotify(errorMessage:  e.message);
      print('AuthViewModel: 로그인 입력 오류 - ${e.message}');
    } catch (e) {
      _clearAuthDataAndNotify(errorMessage: '로그인 중 오류가 발생했습니다. 네트워크 연결을 확인하거나 잠시 후 다시 시도해주세요.');
      print('AuthViewModel: 로그인 중 예외 발생 - $e');
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    String? accessToken;

    try {
      accessToken = await _cookieService.getCookie(cookieName);

      if (accessToken != null && accessToken.isNotEmpty) {
        final LogoutResponse response = await _logoutUsecase.execute(accessToken);

        if (response.isSuccess) {
          print("AuthViewModel: 서버 로그아웃 성공 - ${response.message}");
        } else {
          print("AuthViewModel: 서버 로그아웃 실패 - ${response.message} (코드: ${response.code})");
        }
      } else {
        print("AuthViewModel: 로컬에 액세스 토큰이 없어 서버 로그아웃을 건너<0xEB><0_>니다.");
      }     
    } catch (e) {
      print("AuthViewModel: 로그아웃 유스케이스 실행 중 오류: $e");
    } finally {
      await _cookieService.deleteCookie(cookieName);

      _isLoggedIn = false;
      _userUid = null;
      _currentUser = null;
      _setLoading(false);
    }
  }

  //테스트용. 삭제할 것.
  void testlogin() {
    _isLoggedIn = !_isLoggedIn;
    _currentUser = testUser;
    _userUid = testUser.id;
    notifyListeners(); 
  }

  Future<void> signUp({required String email, required String password, required String name, required String nickname, required String? phone, required String? description, required BuildContext context}) async {
    
  }
}