import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../reponsitory/story_repository.dart';

final storyProvider = Provider((ref) {
  return StoryRepository();
});