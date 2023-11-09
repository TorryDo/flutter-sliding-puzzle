extension MapX<SRC> on Iterable<SRC> {
  List<DST> mapNotNull<DST>(DST? Function(SRC) adapter) {
    List<DST> ts = [];
    for (final element in this) {
      final temp = adapter(element);
      if (temp == null) continue;
      ts.add(temp);
    }
    return ts;
  }
}
