import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_reponsitory.dart';

final authProvider = Provider((ref) {
  return AuthRepository();
});