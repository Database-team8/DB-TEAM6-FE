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
import 'package:ajoufinder/domain/usecases/alarm/alarms_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/board_statuses_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/delete_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/detailed_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/filter_found_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/filter_lost_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/my_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/patch_board_active_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/patch_board_completed_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/patch_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/post_found_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/post_lost_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/condition/conditions_usecase.dart';
import 'package:ajoufinder/domain/usecases/condition/delete_condition_usecase.dart';
import 'package:ajoufinder/domain/usecases/condition/post_condition_usecase.dart';
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
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerLazySingleton<http.Client>(() => BrowserClient()..withCredentials = true);
  getIt.registerLazySingleton<CookieService>(() => CookieServiceWeb());
  getIt.registerLazySingleton<BoardRepository>(() => BoardRepositoryImpl(
    getIt<http.Client>(), 
  ));
  getIt.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl());
  getIt.registerLazySingleton<AlarmRepository>(() => AlarmRepositoryImpl(
    getIt<http.Client>(),
    getIt<CookieService>(),
  ));
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
    getIt<http.Client>(),
  ));
  getIt.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl(
    getIt<http.Client>(),
  ));
  getIt.registerLazySingleton<ConditionRepository>(() => ConditionRepositoryImpl(
    getIt<http.Client>(),
  ));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    getIt<http.Client>(), 
    getIt<CookieService>()
  ));
  getIt.registerFactory<ItemtypesUsecase>(() => ItemtypesUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<BoardStatusesUsecase>(() => BoardStatusesUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<LogoutUsecase>(() => LogoutUsecase(
    getIt<AuthRepository>()
  ));
  getIt.registerFactory<LoginUsecase>(() => LoginUsecase(
    getIt<AuthRepository>()
  ));
  getIt.registerFactory<LocationsUsecase>(() => LocationsUsecase(
    getIt<LocationRepository>()
  ));
  getIt.registerFactory<ChangePasswordUsecase>(() => ChangePasswordUsecase(
    getIt<AuthRepository>()
  ));
  getIt.registerFactory<ProfileUsecase>(() => ProfileUsecase(
    getIt<AuthRepository>()
  ));
  getIt.registerFactory<MyCommentsUsecase>(() => MyCommentsUsecase(
    getIt<CommentRepository>()
  ));
  getIt.registerFactory<MyBoardsUsecase>(() => MyBoardsUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<LostBoardsUsecase>(() => LostBoardsUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<FoundBoardsUsecase>(() => FoundBoardsUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<DetailedBoardUsecase>(() => DetailedBoardUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<SignUpUsecase>(() => SignUpUsecase(
    getIt<UserRepository>()
  ));
  getIt.registerFactory<AlarmsUsecase>(() => AlarmsUsecase(
    getIt<AlarmRepository>()
  ));
  getIt.registerFactory<PostLostBoardUsecase>(() => PostLostBoardUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<PostFoundBoardUsecase>(() => PostFoundBoardUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<FilterLostBoardsUsecase>(() => FilterLostBoardsUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<FilterFoundBoardsUsecase>(() => FilterFoundBoardsUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<PatchBoardActiveUsecase>(() => PatchBoardActiveUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<PatchBoardCompletedUsecase>(() => PatchBoardCompletedUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<DeleteBoardUsecase>(() => DeleteBoardUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<PatchBoardUsecase>(() => PatchBoardUsecase(
    getIt<BoardRepository>()
  ));
  getIt.registerFactory<PostConditionUsecase>(() => PostConditionUsecase(
    getIt<ConditionRepository>()
  ));
  getIt.registerFactory<ConditionsUsecase>(() => ConditionsUsecase(
    getIt<ConditionRepository>()
  ));
  getIt.registerFactory<DeleteConditionUsecase>(() => DeleteConditionUsecase(
    getIt<ConditionRepository>()
  ));
}