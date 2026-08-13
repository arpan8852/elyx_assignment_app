abstract class Either<L, R> {
  const Either();
}

class Left<L, R> extends Either<L, R> {
  final L value;

  Left({required this.value});
}

class Right<L, R> extends Either<L, R> {
  final R value;

  Right({required this.value});
}
