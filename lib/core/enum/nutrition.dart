enum Nutrition {
  carbo("탄수화물", "carbo", "g"),
  sugar("당", "sugar", "g"),
  dietFib("식이섬유", "dietFib", "g"),
  prot("단백질", "prot", "g"),
  fat("지방", "fat", "g"),
  satFat("포화지방", "satFat", "g"),
  transFat("트랜스지방", "transFat", "g"),
  kcal("칼로리", "kcal", "kcal");

  final String text;
  final String code;
  final String unit;

  const Nutrition(this.text, this.code, this.unit);
}
