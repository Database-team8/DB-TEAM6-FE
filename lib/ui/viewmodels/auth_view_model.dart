import 'package:ajoufinder/data/dto/sign_up_request.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  int? _userUid;
  User? _currentUser;
  //테스트용 삭제할 것.
  User testUser = User(id: 1, name: '장한', nickname: '닉네임', email: 'egnever4434@naver.com', password: '1234', role: 'common', updatedAt: DateTime(2002, 10, 12, 23, 59, 59, 99, 0), joinDate: DateTime(2002, 10, 12, 23, 59, 59, 99, 0), phoneNumber: "010-5560-8529", profileImage: "https://siape.veta.naver.com/fxclick?eu=EU10043565&calp=-&oj=cQgn6aire5OCkDs5f7%2BPJ4O3qbsJzHyS0J7a3X2KOumz1M2JFLhyvOvzYS65R9Xj3Uyod%2FLw9f3rv0E7yis2wh8iAc05TbugzxX%2F41dsXFH5WgZkric4e%2FVJwo5hKV6wctRzZMZGLy7qAnSQcXmU%2Fev47hlmG9S2wq%2BDrzLexRocWl11sYqmqvwcBMOjcOaeQ5sJneYKbTkYZfOumM9ijpPqnfPpxiGrWcs4F74%2BEyPgy%2BoloYhsMxvwkG6KJVxRjvkZRxz8a72A9FlU06lTryrSgAhsix95uXbdwcWSqXpgkKVnhxT4LG6zPv6Fpkja9VUn3aD3j4thSAlb2ZdUtI8t97sD5Cf8V%2BfrBROaCPKqr%2FQPXbJd%2FN%2F4hBpY8cGM&ac=9120481&src=7597723&br=4735566&evtcd=P901&x_ti=1505&tb=&oid=&sid1=&sid2=&rk=Ke2G5X5Z-FTEs-vCLRXToA&eltts=tJM52nE%2BLRD%2FYUZwXtZdrw%3D%3D&brs=Y&");
  
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  int? get userUid => _userUid;
  User? get currentUser => _currentUser;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    _setLoading(true);

    try {
      //추후 구현
    }catch (e) {
      _userUid = null;
      _currentUser = null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userUid = null;
    _currentUser = null;
    notifyListeners();
  }

  //테스트용. 삭제할 것.
  void testlogin() {
    _isLoggedIn = !_isLoggedIn;
    _currentUser = testUser;
    _userUid = testUser.id;
    notifyListeners(); 
  }

  Future<void> fetchUser(int uuid) async {
    final userRepository = getIt<UserRepository>();
    _setLoading(true);

    try {
      _currentUser = await userRepository.findById(uuid);
    }catch (e) {
      _currentUser = null;
    } finally {
      _setLoading(false);
    }
  }

  Future<(bool isSuccess, String message)> signUp({required String email, required String password, required String name, required String nickname, required String? phone, required String? description, required BuildContext context}) async {
    final userRepository = getIt<UserRepository>();
    final request = SignUpRequest(
      email: email, 
      password: password, 
      name: name, 
      nickname: nickname, 
      phone: phone, 
      description: description, 
      role: 'GUEST', 
      profile_image: null
    );

    _setLoading(true);

    try {
      final response = await userRepository.signUp(request);
      
      if (int.parse(response.code) >= 200 && int.parse(response.code) < 300) {
        _userUid = response.result;
        await fetchUser(_userUid!);
        notifyListeners();
        return (true, '회원가입이 완료되었습니다.');
        } else {
          return (false, '회원가입 실패: ${response.message ?? "알 수 없는 오류"}');
        }
      } catch (e) {
        return (false, '회원가입 중 오류가 발생했습니다: $e');
      } finally {
        _setLoading(false);
      }
  }
}