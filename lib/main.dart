import 'package:ajoufinder/domain/interfaces/cookie_service.dart';
import 'package:ajoufinder/domain/usecases/alarm/alarms_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/board_statuses_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/delete_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/detailed_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/filter_found_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/filter_lost_boards_usecase.dart';
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
import 'package:ajoufinder/domain/usecases/boards/my_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/user/profile_usecase.dart';
import 'package:ajoufinder/domain/usecases/user/sign_up_usecase.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/navigations/auth_gate.dart';
import 'package:ajoufinder/ui/viewmodels/alarm_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/condition_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/filter_state_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/navigator_bar_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigatorBarViewModel()),
        ChangeNotifierProvider(
          create:
              (_) => FilterStateViewModel(
                getIt<LocationsUsecase>(),
                getIt<ItemtypesUsecase>(),
                getIt<BoardStatusesUsecase>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => AuthViewModel(
                getIt<CookieService>(),
                getIt<LogoutUsecase>(),
                getIt<LoginUsecase>(),
                getIt<ChangePasswordUsecase>(),
                getIt<ProfileUsecase>(),
                getIt<SignUpUsecase>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => BoardViewModel(
                getIt<MyBoardsUsecase>(),
                getIt<LostBoardsUsecase>(),
                getIt<FoundBoardsUsecase>(),
                getIt<DetailedBoardUsecase>(),
                getIt<PostLostBoardUsecase>(),
                getIt<PostFoundBoardUsecase>(),
                getIt<DeleteBoardUsecase>(),
                getIt<FilterLostBoardsUsecase>(),
                getIt<FilterFoundBoardsUsecase>(),
              ),
        ),
        ChangeNotifierProvider(create: (_) => CommentViewModel()), // 인자 없이 생성
        ChangeNotifierProvider(
          create: (_) => AlarmViewModel(getIt<AlarmsUsecase>()),
        ),
        ChangeNotifierProvider(
          create:
              (_) => ConditionViewModel(
                getIt<ConditionsUsecase>(),
                getIt<PostConditionUsecase>(),
                getIt<DeleteConditionUsecase>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => PageViewModel(
                Provider.of<NavigatorBarViewModel>(context, listen: false),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = const Color.fromARGB(255, 18, 32, 186);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      primary: seed,
      onPrimary: const Color.fromARGB(212, 255, 255, 255),
      contrastLevel: 0.5,
      surface: Colors.white,
      onSurface: Colors.black,
      surfaceContainer: Colors.white,
      error: const Color.fromARGB(255, 188, 57, 50),
      onError: Colors.white,
      shadow: const Color.fromARGB(1, 0, 0, 0).withAlpha(25),
      surfaceTint: const Color.fromARGB(255, 220, 220, 220),
      onSurfaceVariant: const Color.fromARGB(255, 100, 100, 110),
    );

    final ThemeData lightTheme = ThemeData.light().copyWith(
      colorScheme: scheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(scheme.primary),
          elevation: WidgetStateProperty.all(6),
          shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.7)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
      primaryIconTheme: IconThemeData(color: scheme.primary),
      hintColor: const Color.fromARGB(64, 83, 83, 83),
    );

    return MaterialApp(
      title: 'AjouFinder',
      theme: lightTheme,
      themeMode: ThemeMode.system,
      home: const AuthGate(),
      navigatorObservers: [routeObserver],
    );
  }
}
