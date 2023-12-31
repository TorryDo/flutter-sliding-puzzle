import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension ProviderX on BuildContext {
  T provider<T>({bool listen = true}) => Provider.of<T>(this, listen: listen);
}
