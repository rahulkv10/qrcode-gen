class StudentData {
  int _id;
  String _name;
  String _age;
  String _studentsId;

  // String _imageString;

  StudentData(this._name, this._studentsId, this._age);

  int get id => _id;
  String get name => _name;
  String get age => _age;
  String get studentId => _studentsId;

  // String get imageString => _imageString;
  set name(String newName) {
    this._name = newName;
  }

  set age(String newAge) {
    this._age = newAge;
  }

  set studentId(String newStudentId) {
    this._studentsId = newStudentId;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['age'] = _age;
    map['studentId'] = _studentsId;

    return map;
  }

  StudentData.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._age = map['age'];
    this._studentsId = map['studentId'];

    // this._imageString = map ['imagestring'];
  }
}
