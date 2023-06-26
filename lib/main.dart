import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_base_project/src/common/themes/app_themes.dart';
import 'package:flutter_bloc_base_project/src/common/utils/app_bloc_observer.dart';
import 'package:flutter_bloc_base_project/src/presentation/router/app_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'src/presentation/appThemes/bloc/theme_bloc.dart';
import 'package:path_provider/path_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyGlobalObserver();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (BuildContext context) => ThemeBloc(),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            ThemeMode themeMode = state.themeMode;
            return MaterialApp.router(
              routerDelegate: AppRouter.goRouter.routerDelegate,
              routeInformationParser: AppRouter.goRouter.routeInformationParser,
              routeInformationProvider:
                  AppRouter.goRouter.routeInformationProvider,
              title: 'Flutter Demo',
              themeMode: themeMode,
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              // home: const MyHomePage(),
            );
          },
        ),
      );
    });
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hhh'),
      ),
      body: Center(
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                ...ThemeMode.values.map((themeMode) {
                  return RadioListTile<ThemeMode>(
                    value: themeMode,
                    groupValue: state.themeMode,
                    title: Text(themeMode.name),
                    onChanged: (newThemeMode) {
                      if (newThemeMode != null) {
                        context
                            .read<ThemeBloc>()
                            .add(ThemeModeSwitched(themeMode: newThemeMode));
                      }
                    },
                  );
                }).toList()
              ],
            );
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
