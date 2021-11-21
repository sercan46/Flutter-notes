import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:notebook/data/db_helper.dart';
import 'package:notebook/models/note_models.dart';
import 'package:notebook/pages/node_detail_view.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({Key? key}) : super(key: key);

  @override
  _NoteListViewState createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  var dbHelper = DBHelper();
  List<NoteVM> notes = [];
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  @override
  void initState() {
    getNot();
    super.initState();
  }

  FutureOr onGoBack(dynamic value) {
    getNot();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('''NOTE's'''),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: notes.length > 0
            ? ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: UniqueKey(),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        deleteNot(notes[index]);
                      }),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            deleteNot(notes[index]);
                          },
                          backgroundColor: Color(0xFFEF5350),
                          foregroundColor: Colors.black,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(0.0, 1.0),
                                blurRadius: 6.0,
                              ),
                            ]),
                        child: ListTile(
                          leading: Icon(
                            Icons.create_sharp,
                            size: 22,
                          ),
                          title: Text(
                            notes[index].title.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(inputFormat.format(DateTime.parse(
                              notes[index].datetime.toString()))),
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => NodeDetailView(
                                      noteVm: notes[index],
                                      isNewNote: false,
                                    ));
                            Navigator.push(context, route).then(onGoBack);
                          },
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: CircularProgressIndicator(
                color: Colors.redAccent,
              )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Route route = MaterialPageRoute(
              builder: (context) => NodeDetailView(
                    isNewNote: true,
                  ));
          Navigator.push(context, route).then(onGoBack);
        },
      ),
    );
  }

  void getNot() {
    dbHelper.getNotes()!.then((value) {
      setState(() {
        notes = value;
      });
    });
  }

  void deleteNot(NoteVM note) {
    dbHelper.delete(note).then((val) {
      getNot();
    });
  }
}
