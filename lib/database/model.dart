class Photo {
  int id;
  String photoName;
  String name;
  String result;
  String prob;
  String date;

  Photo(
      {this.id, this.photoName, this.name, this.result, this.prob, this.date});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      if (id != null) 'id': id,
      'photoName': photoName,
      'name': name,
      'result': result,
      'prob': prob,
      'date': date,
    };
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    photoName = map['photoName'];
    name = map['name'];
    result = map['result'];
    prob = map['prob'];
    date = map['date'];
  }
}
