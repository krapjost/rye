import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

final pressedDialProvider = StateProvider<List<Widget>>((ref) => [SizedBox()]);
final pageProvider = StateProvider((ref) => 0);
