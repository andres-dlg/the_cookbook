class Ingredient {
  int ingredientId;
  int _recipeId;
  String _description;

  Ingredient(this._recipeId, this._description);

  set recipeId(value) => _recipeId = value;
  set description(value) => _description = value;

  int get recipeId => _recipeId;
  String get description => _description;

  Ingredient.map(dynamic obj){
    this._recipeId = obj["recipeId"];
    this._description = obj["description"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["recipeId"] = _recipeId;
    map["description"] = _description;
    return map;
  }

  void setIngredientId(int ingredientId) {
    this.ingredientId = ingredientId;
  }

}