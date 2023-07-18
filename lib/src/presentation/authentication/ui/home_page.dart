// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../shared/plugins/lib/src/calendar_overlay/calendar_overlay.dart';
import '../../../shared/plugins/lib/tie_picker.dart';
import '../../app_themes/bloc/theme_bloc.dart';
import '../../router/route_utils.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
//language=GraphQl
  String readRepositories = """
  query{
   findAllDepartment{
     departmentId
     name
   }
 }

""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Home Screen'),
              IconButton(
                  onPressed: () async {
                    final dateresult = await ModalPicker.datePicker(
                      context: context,
                      date: DateTime.now(),
                      mode: CalendarMode.day,
                    );

                    print(dateresult);
                  },
                  icon: const Icon(Icons.home)),

              // BlocBuilder<ThemeBloc, ThemeState>(
              //   builder: (context, state) {
              //     return Column(
              //       children: <Widget>[
              //         ...ThemeMode.values.map((themeMode) {
              //           return RadioListTile<ThemeMode>(
              //             value: themeMode,
              //             groupValue: state.themeMode,
              //             title: Text(themeMode.name),
              //             onChanged: (newThemeMode) {
              //               if (newThemeMode != null) {
              //                 context.read<ThemeBloc>().add(
              //                     ThemeModeSwitched(themeMode: newThemeMode));
              //               }
              //             },
              //           );
              //         }).toList(),
              //         IconButton(
              //             icon: Icon(Icons.skip_next),
              //             onPressed: () =>
              //                 context.goNamed(APPAGE.login.toName)),
              //       ],
              //     );
              //   },
              // ),

              // ...
              Query(
                options: QueryOptions(
                  document: gql(
                      readRepositories), // this is the query string you just created
                  variables: const {
                    'nRepositories': 50,
                  },
                  pollInterval: const Duration(milliseconds: 500),
                ),
                // Just like in apollo refetch() could be used to manually trigger a refetch
                // while fetchMore() can be used for pagination purpose
                builder: (QueryResult result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  // print(result.data);/
                  // print(result.parsedData);/
                  print(result.data);
                  print(result.exception);

                  // print(result.parserFn(result.data!));
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return const Text('Loading');
                  }
                  // print('........');

                  // print(json.encode(result.data));

                  // List<Department> graphqlResponse = parseDepartmentList(
                  //     json.encode(result.data?['findAllDepartment']));
                  // result.data?['findAllDepartment'];

                  // print(graphqlResponse);

                  var data = json.encode(result.data);

                  SampleResponse? repositories =
                      SampleResponse.fromJson(json.decode(data));
                  // print('jjjjjjjj');
                  // print(repositories.findAllDepartment!.length);

                  // List? repositories =
                  //     result.data?['viewer']?['repositories']?['nodes'];

                  if (repositories.findAllDepartment!.isEmpty) {
                    return const Text('No repositories');
                  }

                  return Flexible(
                    child: ListView.builder(
                        itemCount: repositories.findAllDepartment!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final repository =
                              repositories.findAllDepartment![index];

                          return Text(repository.name ?? '');
                        }),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SampleResponse {
  String? sTypename;
  List<FindAllDepartment>? findAllDepartment;

  SampleResponse({this.sTypename, this.findAllDepartment});

  SampleResponse.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['findAllDepartment'] != null) {
      findAllDepartment = <FindAllDepartment>[];
      json['findAllDepartment'].forEach((v) {
        findAllDepartment!.add(FindAllDepartment.fromJson(v));
      });
    }
  }
}

class FindAllDepartment {
  String? sTypename;
  int? departmentId;
  String? name;

  FindAllDepartment({this.sTypename, this.departmentId, this.name});

  FindAllDepartment.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    departmentId = json['departmentId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['__typename'] = sTypename;
    data['departmentId'] = departmentId;
    data['name'] = name;
    return data;
  }
}
