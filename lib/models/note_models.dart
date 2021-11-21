class NoteVM {
  int? id;
  String? title;
  String? description;
  String? datetime;
  String? url;
  NoteVM({this.id, this.title, this.description, this.datetime, this.url});

  NoteVM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    datetime = json['datetime'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['datetime'] = this.datetime;
    data['url'] = this.url;
    return data;
  }
}
