class PartialStrut {
  final int top;
  final int right;
  final int left;
  final int bottom;

  final int top_start_x;
  final int top_end_x;

  final int left_start_y;
  final int left_end_y;

  final int right_start_y;
  final int right_end_y;

  final int bottom_start_x;
  final int bottom_end_x;

  PartialStrut(
      {this.left = 0,
      this.right = 0,
      this.top = 0,
      this.bottom = 0,
      this.left_start_y = 0,
      this.left_end_y = 0,
      this.right_start_y = 0,
      this.right_end_y = 0,
      this.top_start_x = 0,
      this.top_end_x = 0,
      this.bottom_start_x = 0,
      this.bottom_end_x = 0});

  List<int> toStrutArray() {
    return [
      left,
      right,
      top,
      bottom,
      left_start_y,
      left_end_y,
      right_start_y,
      right_end_y,
      top_start_x,
      top_end_x,
      bottom_start_x,
      bottom_end_x
    ];
  }
}
