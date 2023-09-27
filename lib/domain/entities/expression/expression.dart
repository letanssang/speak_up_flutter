class Expression {
  final int expressionID;
  final String name;
  final int expressionTypeID;
  final String translation;

  Expression({
    required this.expressionID,
    required this.name,
    required this.expressionTypeID,
    required this.translation,
  });

  factory Expression.initial() {
    return Expression(
      expressionID: 0,
      name: '',
      expressionTypeID: 0,
      translation: '',
    );
  }
}
