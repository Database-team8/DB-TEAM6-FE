import 'package:ajoufinder/data/network/cookie_service_web.dart';
import 'package:ajoufinder/data/services/repository_impls/auth_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/board_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/comment_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/condition_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/location_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/alarm_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/user_repository_impl.dart';
import 'package:ajoufinder/domain/interfaces/cookie_service.dart';
import 'package:ajoufinder/domain/repository/auth_repository.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';
import 'package:ajoufinder/domain/repository/comment_repository.dart';
import 'package:ajoufinder/domain/repository/condition_repository.dart';
import 'package:ajoufinder/domain/repository/location_repository.dart';
import 'package:ajoufinder/domain/repository/alarm_repository.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:ajoufinder/domain/usecases/alarm/my_alarms_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/detailed_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/my_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/user/change_password_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/found_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/itemtype/itemtypes_usecase.dart';
import 'package:ajoufinder/domain/usecases/location/locations_usecase.dart';
import 'package:ajoufinder/domain/usecases/auth/login_usecase.dart';
import 'package:ajoufinder/domain/usecases/auth/logout_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/lost_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/my_comments_usecase.dart';
import 'package:ajoufinder/domain/usecases/user/profile_usecase.dart';
import 'package:ajoufinder/domain/usecases/user/sign_up_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<CookieService>(() => CookieServiceWeb());
  getIt.registerLazySingleton<BoardRepository>(() => BoardRepositoryImpl(getIt<http.Client>(), getIt<CookieService>()));
  getIt.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl());
  getIt.registerLazySingleton<AlarmRepository>(() => AlarmRepositoryImpl());
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
    getIt<http.Client>(),
  ));
  getIt.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl(getIt<http.Client>(),));
  getIt.registerLazySingleton<ConditionRepository>(() => ConditionRepositoryImpl());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<http.Client>(), getIt<CookieService>()));
  getIt.registerFactory<ItemtypesUsecase>(() => ItemtypesUsecase(getIt<BoardRepository>()),);
  getIt.registerFactory<LogoutUsecase>(() => LogoutUsecase(getIt<AuthRepository>()),);
  getIt.registerFactory<LoginUsecase>(() => LoginUsecase(getIt<AuthRepository>()),);
  getIt.registerFactory<LocationsUsecase>(() => LocationsUsecase(getIt<LocationRepository>()),);
  getIt.registerFactory<ChangePasswordUsecase>(() => ChangePasswordUsecase(getIt<AuthRepository>()),);
  getIt.registerFactory<ProfileUsecase>(() => ProfileUsecase(getIt<AuthRepository>()),);
  getIt.registerFactory<MyCommentsUsecase>(() => MyCommentsUsecase(getIt<CommentRepository>()),);
  getIt.registerFactory<MyBoardsUsecase>(() => MyBoardsUsecase(getIt<BoardRepository>()),);
  getIt.registerFactory<LostBoardsUsecase>(() => LostBoardsUsecase(getIt<BoardRepository>()),);
  getIt.registerFactory<FoundBoardsUsecase>(() => FoundBoardsUsecase(getIt<BoardRepository>()),);
  getIt.registerFactory<MyAlarmsUsecase>(() => MyAlarmsUsecase(getIt<AlarmRepository>()),);
  getIt.registerFactory<DetailedBoardUsecase>(() => DetailedBoardUsecase(getIt<BoardRepository>()),);
  getIt.registerFactory<SignUpUsecase>(() => SignUpUsecase(getIt<UserRepository>()),);
}