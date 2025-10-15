enum MealType {
  breakfast("아침", "breakfast"),
  lunch("점심", "lunch"),
  dinner("저녁", "dinner"),
  snack("간식", "snack");

  final String name;
  final String code;
  const MealType(this.name, this.code);
}
