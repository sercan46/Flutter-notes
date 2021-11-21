import 'package:flutter/material.dart';
import 'package:notebook/data/db_helper.dart';
import 'package:notebook/models/note_models.dart';
import 'package:notebook/validations/note_validaton.dart';
import 'package:url_launcher/url_launcher.dart';

class NodeDetailView extends StatefulWidget {
  NoteVM? noteVm;
  bool? isNewNote;

  NodeDetailView({
    Key? key,
    this.noteVm,
    required this.isNewNote,
  });

  @override
  _NodeDetailViewState createState() => _NodeDetailViewState();
}

class _NodeDetailViewState extends State<NodeDetailView> with NoteValidation {
  var titleTxt = TextEditingController();
  var descriptionTxt = TextEditingController();
  var urlTxt = TextEditingController();
  var dbHelper = DBHelper();
  var formKey = GlobalKey<FormState>();
  var noteModel = NoteVM();
  @override
  void initState() {
    if (widget.isNewNote == false) {
      titleTxt.text = widget.noteVm!.title.toString();
      descriptionTxt.text = widget.noteVm!.description.toString();
      urlTxt.text = widget.noteVm!.url.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isNewNote == true
            ? Text('Add New Note')
            : Text(widget.noteVm!.title.toString()),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 20,
                  controller: titleTxt,
                  validator: (value) => validateTitle(value!),
                  onSaved: (value) {
                    noteModel.title = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.redAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionTxt,
                  maxLines: 10,
                  validator: (value) => validateDescription(value!),
                  onSaved: (value) {
                    noteModel.description = value;
                  },
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: "Description",
                    labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.redAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: urlTxt,
                  validator: (value) => validateUrl(value!),
                  onSaved: (value) {
                    noteModel.url = value;
                  },
                  decoration: InputDecoration(
                    labelText: "URL",
                    labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.redAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                widget.isNewNote == false
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: () {
                              launch(widget.noteVm!.url.toString());
                            },
                            child: Text('Open URL')))
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                widget.isNewNote == true
                    ? ElevatedButton(
                        onPressed: () {
                          addNote();
                        },
                        child: Text(
                          'Add New Note',
                          style: TextStyle(fontSize: 15),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent)),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          updateNote();
                        },
                        child: Text(
                          'Update ${widget.noteVm!.title} Note',
                          style: TextStyle(fontSize: 15),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent)),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addNote() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      noteModel.datetime = DateTime.now().toString();
      print(noteModel.title);
      var result = await dbHelper.insert(noteModel);
      Navigator.pop(context, true);
    }
  }

  void updateNote() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      noteModel.datetime = DateTime.now().toString();
      noteModel.id = widget.noteVm!.id;

      var result = await dbHelper.update(noteModel);
      Navigator.pop(context, true);
    }
  }
}
