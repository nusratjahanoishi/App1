class AllFoodModel {
  final String _image;
  final String _protein;
  final String _name;
  final String _ready;
  final bool _isvagitarian;

  AllFoodModel(this._image, this._protein, this._name, this._ready, this._isvagitarian);
  String get image => _image;
  String get protein => _protein;
  String get name => _name;
  String get  ready => _ready;
  bool get isvagitarian => _isvagitarian;

  // Used to convert a user object into a map / json
  Map<String, dynamic> toJson() => {
    'image': _image,
    "protein": _protein,
    'name': _name,
    'ready': _ready,
    'isvagitarian': _isvagitarian
  };
}