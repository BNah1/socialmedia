import 'package:bona/feature/friends/presentation/widget/request_tile.dart';
import 'package:bona/feature/friends/provider/get_all_request_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/screens/error_screen.dart';
import '../../../../core/widget/loading.dart';

class RequestList extends ConsumerStatefulWidget {
  const RequestList({super.key});

  @override
  ConsumerState<RequestList> createState() => _RequestListState();
}

class _RequestListState extends ConsumerState<RequestList> {
  @override
  Widget build(BuildContext context) {
    final requestList = ref.watch(getAllFriendRequestsProvider);
    return requestList.when(
      data: (request){
        return SliverList.builder(
            itemCount: request.length,
            itemBuilder: (context , index){
              final userId = request.elementAt(index);
          return RequestTile(userId: userId);});
      },
      error: (error, stackTrace) {
        return SliverToBoxAdapter(
          child: ErrorScreen(error: error.toString()),
        );
    },
      loading: () {
        return const SliverToBoxAdapter(
          child: Loader(),
        );
      },);
  }
}
