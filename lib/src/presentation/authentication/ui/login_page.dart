// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_base_project/src/presentation/authentication/bloc/auth_bloc.dart';
import 'package:flutter_bloc_base_project/src/presentation/router/app_router.dart';
import 'package:flutter_bloc_base_project/src/presentation/router/route_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // AuthBloc bloc = AuthBloc();

  String addStar = """
  mutation{
  getToken(loginDto:{
    loginMail:"clint@domain.com"
    password:"112233"
  })
}
""";
  void _onCompleted(data, BuildContext context) {
    print('vallueee');
    print(data);

    /// If they do, move to home page. If not, take them to select artist page for them to select artists.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialUserCheckState) {
            context.go(APPAGE.home.toPath);
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 32.0),
              Mutation(
                options: MutationOptions(
                  document: gql(addStar),
                  onCompleted: (data) => _onCompleted(data, context),
                ),
                builder: (RunMutation runMutation, QueryResult? result) {
                  print(result!.data);
                  if (result != null) {
                    if (result.isLoading) {
                      return const CircularProgressIndicator();
                    }

                    if (result.hasException) {
                      return Text('error');
                    }
                  }

                  return ElevatedButton(
                    onPressed: () {
                      String email = _emailController.text;
                      String password = _passwordController.text;

                      // Add your login logic here

                      // _googleButtonPressed(context, runMutation);

                      runMutation({});

                      BlocProvider.of<AuthBloc>(context)
                          .add(AuthValidatyCheckEvent());
                    },
                    child: Text('Login'),
                  );

                  // GoogleButton(
                  //   onPressed: () => _googleButtonPressed(context, runMutation),
                  // );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
