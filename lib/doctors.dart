class Doctors {
  final String _name;
  final String _uid;
  final String _department;
  final String _image;
  final String _time;
  final bool _appointment;
  final String _rating;

  Doctors(this._image, this._name, this._appointment, this._department,this._time,this._rating,this._uid);
  String get name => _name;

  String get image => _image;
  String get uid => _uid;
  String get rating => _rating;


  bool get appointment => _appointment;

  String get department => _department;
  String get time => _time;

  // Used to convert a user object into a map / json
  Map<String, dynamic> toJson() => {
    'name': _name,
    'image': _image,
    "rating": _rating,
    'appointment': _appointment,
    'department': _department,
    'time':_time,
    'uid':_uid
  };
}