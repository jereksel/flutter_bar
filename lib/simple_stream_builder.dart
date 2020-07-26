import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/text.dart';

typedef SimpleAsyncWidgetBuilder<T> = Widget Function(T data);

class SimpleStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final SimpleAsyncWidgetBuilder<T> builder;

  const SimpleStreamBuilder({
    Key key,
    @required this.stream,
    @required this.builder,
  })  : assert(builder != null),
        assert(stream != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return text("ERROR: ${snapshot.error}");
        }
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        return builder(snapshot.data);
      },
    );
  }
}
