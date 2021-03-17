import 'package:fetch_data/model/user.dart';
import 'package:fetch_data/network_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStateFuture = FutureProvider<List<User>>((ref) async {
  return fetchUsers();
});
