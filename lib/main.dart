import 'package:flutter/material.dart';
import 'package:notebook/pages/note_list_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '''Note's''',
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        home: NoteListView());
  }
}
