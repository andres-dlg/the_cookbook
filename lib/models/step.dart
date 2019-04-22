class Step {

  int stepId;
  int _recipeId;
  String _title;
  String _description;
  String _photoBase64Encoded;

  Step(this._recipeId, this._title, this._description, this._photoBase64Encoded, {this.stepId});

  int get recipeId => _recipeId;
  String get title => _title;
  String get description => _description;
  String get photoBase64Encoded => _photoBase64Encoded;

  set description(value) => this._description = value;
  set recipeId(value) => this._recipeId = value;
  set photoBase64Encoded(value) => this._photoBase64Encoded = value;

  Step.map(dynamic obj){
    this._recipeId = obj["recipeId"];
    this._title = obj["title"];
    this._description = obj["description"];
    this._photoBase64Encoded = obj["photoBase64Encoded"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["recipeId"] = _recipeId;
    map["title"] = _title;
    map["description"] = _description;
    map["photoBase64Encoded"] = _photoBase64Encoded;
    return map;
  }

  void setStepId(int stepId) {
    this.stepId = stepId;
  }

}