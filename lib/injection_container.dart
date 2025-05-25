import 'package:ajoufinder/data/services/repository_impls/board_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/comment_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/condition_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/location_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/alarm_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/user_repository_impl.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';
import 'package:ajoufinder/domain/repository/comment_repository.dart';
import 'package:ajoufinder/domain/repository/condition_repository.dart';
import 'package:ajoufinder/domain/repository/location_repository.dart';
import 'package:ajoufinder/domain/repository/alarm_repository.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerLazySingleton<BoardRepository>(() => BoardRepositoryImpl());
  getIt.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl());
  getIt.registerLazySingleton<AlarmRepository>(() => AlarmRepositoryImpl());
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  getIt.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl());
  getIt.registerLazySingleton<ConditionRepository>(() => ConditionRepositoryImpl());
}