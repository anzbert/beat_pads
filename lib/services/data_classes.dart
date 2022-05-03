class Vector2D {
  /// A simple class that holds an integer x and y value
  const Vector2D(this.x, this.y);

  final int x;
  final int y;

  int get area {
    return x * y;
  }

  List<int> toList() {
    return [x, y];
  }
}
