import 'package:flutter/material.dart';
import 'package:projectdemo/services/api_services.dart';
import 'package:projectdemo/views/college_list_view.dart';
import 'package:provider/provider.dart';

import 'viewmodels/college_list_viewmodel.dart';


void main() {
runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
Widget build(BuildContext context) {
final apiService = ApiService();


return MultiProvider(
providers: [
ChangeNotifierProvider(create: (_) => CollegeListViewModel(apiService: apiService)),
],
child: App(),
);
}
}


class App extends StatelessWidget {
  const App({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Colleges MVVM',
debugShowCheckedModeBanner: false,
theme: ThemeData(
primarySwatch: Colors.green,
visualDensity: VisualDensity.adaptivePlatformDensity,
),
home: CollegeListView(),
);
}
}