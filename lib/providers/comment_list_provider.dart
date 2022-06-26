

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_saver_client/models/comment.dart';

final StateProvider<List<Comment>> counterProvider = StateProvider((_) => 0);