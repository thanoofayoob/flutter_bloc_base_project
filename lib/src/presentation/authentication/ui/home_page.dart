import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app_themes/bloc/theme_bloc.dart';
import '../../router/route_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Home Screen'),
              IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
              BlocBuilder<ThemeBloc, ThemeState>(
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
                              context.read<ThemeBloc>().add(
                                  ThemeModeSwitched(themeMode: newThemeMode));
                            }
                          },
                        );
                      }).toList(),
                      IconButton(
                          icon: Icon(Icons.skip_next),
                          onPressed: () =>
                              context.goNamed(APPAGE.login.toName)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
