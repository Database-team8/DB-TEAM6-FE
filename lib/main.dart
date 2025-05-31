import 'package:ajoufinder/domain/interfaces/cookie_service.dart';
import 'package:ajoufinder/domain/usecases/alarm/my_alarms_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/detailed_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/user/change_password_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/found_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/itemtype/itemtypes_usecase.dart';
import 'package:ajoufinder/domain/usecases/location/locations_usecase.dart';
import 'package:ajoufinder/domain/usecases/auth/login_usecase.dart';
import 'package:ajoufinder/domain/usecases/auth/logout_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/lost_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/my_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/my_comments_usecase.dart';
import 'package:ajoufinder/domain/usecases/user/profile_usecase.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/navigations/auth_gate.dart';
import 'package:ajoufinder/ui/viewmodels/alarm_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/condition_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/navigator_bar_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/page_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependencies();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)  => AuthViewModel(
            getIt<CookieService>(),
            getIt<LogoutUsecase>(),
            getIt<LoginUsecase>(),
            getIt<ChangePasswordUsecase>(),
            getIt<ProfileUsecase>(),
          ),
        ),  
        ChangeNotifierProvider(create: (_) => BoardViewModel(
          getIt<ItemtypesUsecase>(),
          getIt<LocationsUsecase>(),
          getIt<MyBoardsUsecase>(),
          getIt<LostBoardsUsecase>(),
          getIt<FoundBoardsUsecase>(),
          getIt<DetailedBoardUsecase>(),
        )),  
        ChangeNotifierProvider(create: (_) => CommentViewModel(
          getIt<MyCommentsUsecase>(),
        )),  
        ChangeNotifierProvider(create: (_) => AlarmViewModel(
          getIt<MyAlarmsUsecase>(),
        )),
        ChangeNotifierProvider(create: (_) => ConditionViewModel()),
        ChangeNotifierProvider(create: (_) => NavigatorBarViewModel()),
        ChangeNotifierProvider(create: (context) => PageViewModel(
          Provider.of<NavigatorBarViewModel>(context, listen: false),
        ),),        
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color.fromARGB(255, 18, 32, 186);
    
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
      shadow: const Color.fromARGB(1, 0, 0, 0).withValues(alpha: 0.1),
      surfaceTint: const Color.fromARGB(255, 220, 220, 220),
      onSurfaceVariant: const Color.fromARGB(255, 100, 100, 110),
    );
    
    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color.fromARGB(255, 35, 0, 212);
              } else if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
              } else {
              return const Color.fromARGB(255, 43, 1, 255);
              }
            },
          ),
          elevation: WidgetStateProperty.resolveWith<double>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                return 12.0;
                } else if (states.contains(WidgetState.disabled)) {
                return 0.0;
                }
                return 6.0;
              }
            ), 
          shadowColor: WidgetStateProperty.all(Colors.black.withValues(alpha: 0.7)),
        ),
      );
    
    final floatingActionButonTheme = FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 6.0,
      hoverColor: scheme.primary,
      shape: const StadiumBorder(side: BorderSide(style: BorderStyle.none,)),
      extendedSizeConstraints: const BoxConstraints(
        minHeight: 40,
        minWidth: 320,
      ),
      extendedIconLabelSpacing: 12.0, 
    );

    final iconThemeData = IconThemeData(
      color: scheme.onSurface,
      shadows: <Shadow>[
        Shadow(
          color: Colors.black.withValues(alpha: 0.15),
          offset: Offset(-1.5, 1.5),
          blurRadius: 3.0,
        )
      ],

    );

    final primayIconThemeData = iconThemeData.copyWith(
      color: scheme.primary,
    );

    final ThemeData lightTheme = ThemeData.light().copyWith(
      colorScheme: scheme,
      elevatedButtonTheme: elevatedButtonTheme,
      floatingActionButtonTheme: floatingActionButonTheme,
      primaryIconTheme: primayIconThemeData,
      iconTheme: iconThemeData,
      hintColor: const Color.fromARGB(64, 83, 83, 83),
    );

    return MaterialApp(
      title: 'AjouFinder',
      home: AuthGate(),
      theme: lightTheme,
      themeMode: ThemeMode.system,
      themeAnimationCurve: Curves.ease,  
      navigatorObservers: [routeObserver],
  );
  }
}