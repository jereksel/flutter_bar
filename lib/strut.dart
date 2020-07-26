class PartialStrut {
  final int top;
  final int right;
  final int left;
  final int bottom;

  final int topStartX;
  final int topEndX;

  final int leftStartY;
  final int leftEndY;

  final int rightStartY;
  final int rightEndY;

  final int bottomStartX;
  final int bottomEndX;

  PartialStrut(
      {this.left = 0,
      this.right = 0,
      this.top = 0,
      this.bottom = 0,
      this.leftStartY = 0,
      this.leftEndY = 0,
      this.rightStartY = 0,
      this.rightEndY = 0,
      this.topStartX = 0,
      this.topEndX = 0,
      this.bottomStartX = 0,
      this.bottomEndX = 0});

  List<int> toStrutArray() {
    return [
      left,
      right,
      top,
      bottom,
      leftStartY,
      leftEndY,
      rightStartY,
      rightEndY,
      topStartX,
      topEndX,
      bottomStartX,
      bottomEndX
    ];
  }
}
