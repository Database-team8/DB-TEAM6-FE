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
import 'package:ajoufinder/domain/usecases/logout_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<BoardRepository>(() => BoardRepositoryImpl());
  getIt.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl());
  getIt.registerLazySingleton<AlarmRepository>(() => AlarmRepositoryImpl());
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  getIt.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl());
  getIt.registerLazySingleton<ConditionRepository>(() => ConditionRepositoryImpl());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<http.Client>()));
   getIt.registerFactory<LogoutUsecase>(() => LogoutUsecase(getIt<AuthRepository>()),);
  getIt.registerLazySingleton<CookieService>(() => CookieServiceWeb());
}