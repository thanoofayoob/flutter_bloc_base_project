import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_base_project/src/core/themes/app_themes.dart';
import 'package:flutter_bloc_base_project/src/core/utils/app_bloc_observer.dart';
import 'package:flutter_bloc_base_project/src/presentation/app_themes/bloc/theme_bloc.dart';
import 'package:flutter_bloc_base_project/src/presentation/authentication/bloc/auth_bloc.dart';
import 'package:flutter_bloc_base_project/src/presentation/router/app_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:path_provider/path_provider.dart';

import 'src/core/local_storage/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyGlobalObserver();
  final userRepository = SecureStorage();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  final HttpLink httpLink = HttpLink('http://www.othalanga.co.in/graphql');

  // final AuthLink authLink = AuthLink(
  //   getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  //   // OR
  //   // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  // );
  await initHiveForFlutter();

  final Link link = (httpLink);
  ValueNotifier<GraphQLClient>? client;
  try {
    client = ValueNotifier(
      GraphQLClient(
        link: link,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  } catch (e) {
    print(e.toString());
  }

  runApp(
    BlocProvider<AuthBloc>(
      create: (context) {
        return AuthBloc(userRepository: userRepository);
      },
      child: MyApp(
        client: client,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  ValueNotifier<GraphQLClient>? client;
  MyApp({required this.client, super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(create: (BuildContext context) {
            BlocProvider.of<AuthBloc>(context).add(AppStarted());
            return ThemeBloc();
          }),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            ThemeMode themeMode = state.themeMode;
            initializeDateFormatting();
            return GraphQLProvider(
              client: client,
              child: MaterialApp.router(
                routerDelegate: AppRouter.goRouter.routerDelegate,
                routeInformationParser:
                    AppRouter.goRouter.routeInformationParser,
                routeInformationProvider:
                    AppRouter.goRouter.routeInformationProvider,
                title: 'Flutter Demo',
                themeMode: themeMode,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
              ),
            );
          },
        ),
      );
    });
  }
}
