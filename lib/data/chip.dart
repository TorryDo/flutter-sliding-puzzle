import 'dart:math';

import 'package:slide_puzzle/utils/serializable.dart';
import 'package:meta/meta.dart';

import 'point.dart';

@immutable
class Chip implements Serializable {
  /// Unique identifier of a chip, starts
  /// from a zero.
  final int number;

  final Point<int> targetPoint;

  final Point<int> currentPoint;

  const Chip(
    this.number,
    this.targetPoint,
    this.currentPoint,
  );

  Chip move(Point<int> point) => Chip(number, targetPoint, point);

  @override
  void serialize(SerializeOutput output) {
    output.writeInt(number);
    output.writeSerializable(PointSerializableWrapper(targetPoint));
    output.writeSerializable(PointSerializableWrapper(currentPoint));
  }
}

class ChipDeserializableFactory extends DeserializableHelper<Chip> {
  const ChipDeserializableFactory() : super();

  @override
  Chip deserialize(SerializeInput input) {
    const pd = PointDeserializableFactory();

    final number = input.readInt() ?? -1;
    final targetPoint = input.readDeserializable(pd)!;
    final currentPoint = input.readDeserializable(pd)!;
    return Chip(number, targetPoint, currentPoint);
  }
}
