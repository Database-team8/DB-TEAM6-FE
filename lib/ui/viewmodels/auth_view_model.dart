import 'package:ajoufinder/const/network.dart';
import 'package:ajoufinder/data/dto/auth/logout/logout_response.dart';
import 'package:ajoufinder/data/dto/user/signup/signup_request.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/interfaces/cookie_service.dart';
import 'package:ajoufinder/domain/usecases/user/change_password_usecase.dart';
import 'package:ajoufinder/domain/usecases/auth/login_usecase.dart';
import 'package:ajoufinder/domain/usecases/auth/logout_usecase.dart';
import 'package:ajoufinder/domain/usecases/user/profile_usecase.dart';
import 'package:ajoufinder/domain/usecases/user/sign_up_usecase.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final CookieService _cookieService;
  final LogoutUsecase _logoutUsecase;
  final LoginUsecase _loginUsecase;
  final ChangePasswordUsecase _changePasswordUsecase;
  final ProfileUsecase _profileUsecase;
  final SignUpUsecase _signUpUsecase;

  bool _isLoggedIn = false;
  bool _isLoading = false;
  
  User? _currentUser;
  String? _authErrorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  
  User? get currentUser => _currentUser;
  String? get authErrorMessage => _authErrorMessage;

  AuthViewModel(
    this._cookieService, 
    this._logoutUsecase, 
    this._loginUsecase, 
    this._changePasswordUsecase, 
    this._profileUsecase, 
    this._signUpUsecase,
    ) {
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
    
    _authErrorMessage = errorMessage;
    notifyListeners();
  }

  Future<bool> _fetchAndSetUser() async {
    try {
      final fetchedUser = await _profileUsecase.execute();
      _updateAuthState(isLoggedIn: true, user: fetchedUser);
      print('AuthViewModel: 사용자 정보 로드 성공 - ID: ${fetchedUser.name}');
      return true;
      /**
      if (fetchedUser != null) {
        _updateAuthState(isLoggedIn: true, user: fetchedUser);
        print('AuthViewModel: 사용자 정보 로드 성공 - ID: ${fetchedUser.name}');
        return true;
      } else {
        print('AuthViewModel: 사용자를 찾을 수 없습니다.');
        // 사용자를 못 찾으면 로그아웃 상태로 처리
        await _clearAuthDataAndNotify(errorMessage: '사용자 정보를 찾을 수 없습니다.');
        return false;
      }*/
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
        User? user = await _profileUsecase.execute();

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

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _authErrorMessage = null;
    bool success = false;

    try {
      final response = await _loginUsecase.execute(email: email, password: password);

      if (response.isSuccess) {
        final sessionId = response.result;
        await _cookieService.setCookie(cookieName, sessionId, maxAgeInSeconds: 60 * 60 * 24 * 7);
        final cookie = await _cookieService.getCookie(cookieName);

        // 쿠키 활용하는 구조로 바꾸기
        if (cookie == null) {
          await _clearAuthDataAndNotify(errorMessage: '잘못된 사용자 ID 형식입니다.');
        } else {
          await _fetchAndSetUser();
          print('AuthViewModel: 로그인 성공');
          success = true;
        }
      } else {
        _clearAuthDataAndNotify(errorMessage:  response.message);
        print('AuthViewModel: 로그인 실패 - ${response.message} (코드: ${response.code})');
        success = false;
      }
    } on ArgumentError catch (e) {
      _clearAuthDataAndNotify(errorMessage:  e.message);
      print('AuthViewModel: 로그인 입력 오류 - ${e.message}');
      success = false;
    } catch (e) {
      _clearAuthDataAndNotify(errorMessage: '로그인 중 오류가 발생했습니다. 네트워크 연결을 확인하거나 잠시 후 다시 시도해주세요.');
      print('AuthViewModel: 로그인 중 예외 발생 - $e');
      success = false;
    } finally {
      _setLoading(false);
    }
    return success;
  }

  Future<void> logout() async {
    _setLoading(true);
    String? cookie;

    try {
      cookie = await _cookieService.getCookie(cookieName);

      if (cookie != null && cookie.isNotEmpty) {
        final LogoutResponse response = await _logoutUsecase.execute(cookie);

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
      
      _currentUser = null;
      _setLoading(false);
    }
  }


  Future<bool> signUp({
    required String name, 
    required String nickname, 
    required String email, 
    required String password, 
    String? description, 
    String? profileImage, 
    String? phoneNumber,
    required String role,
    }) async {
    _setLoading(true);
    _authErrorMessage = null;
    bool success = false;

    final request = SignUpRequest(
      name: name,
      nickname: nickname,
      email: email,
      password: password,
      description: description,
      profileImage: profileImage,
      phoneNumber: phoneNumber,
      role: role,
    );

    try {
      final response = await _signUpUsecase.execute(request);

      if (response.isSuccess) {
        print('AuthViewModel: 회원가입 성공 - 사용자 ID: ${response.result}');
        success = true;
      } else {
        _authErrorMessage = response.message;
        print('AuthViewModel: 회원가입 실패 - ${response.message} (코드: ${response.code})');
      }
    } on ArgumentError catch (e) {
      _authErrorMessage = e.message;
      print('AuthViewModel: 회원가입 입력 오류 - ${e.message}');
    } catch (e) {
      _authErrorMessage = '회원가입 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
      print('AuthViewModel: 회원가입 중 예외 발생 - $e');
    } finally {
      _setLoading(false);
    }
    return success;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _authErrorMessage = null;

    bool success = false;

    try {
      final response = await _changePasswordUsecase.execute(currentPassword: currentPassword, newPassword: newPassword);

      if (response.isSuccess) {
        print('AuthViewModel: 비밀번호 변경 성공');
        success = true;
      } else {
        _authErrorMessage = response.message;
        print('AuthViewModel: 비밀번호 변경 실패 - ${response.message} (코드: ${response.code})');
      }
    } on ArgumentError catch (e) {
      _authErrorMessage = e.message;
      print('AuthViewModel: 비밀번호 변경 입력 오류 - ${e.message}');
    } catch (e) {
      _authErrorMessage = '비밀번호 변경 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
      print('AuthViewModel: 비밀번호 변경 중 예외 발생 - ${e.toString()}');
    } finally {
      _setLoading(false);
    }
    return success;
  }
}