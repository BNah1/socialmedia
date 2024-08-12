import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/post_reponsitory.dart';

final postsProvider = Provider((ref) {
  return PostRepository();
});