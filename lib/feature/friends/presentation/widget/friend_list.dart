import 'package:bona/feature/friends/provider/get_all_friends_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/screens/error_screen.dart';
import '../../../../core/widget/loading.dart';
import 'friend_tile.dart';

class FriendList extends ConsumerStatefulWidget {
  const FriendList({super.key});

  @override
  ConsumerState<FriendList> createState() => _RequestListState();
}

class _RequestListState extends ConsumerState<FriendList> {
  @override
  Widget build(BuildContext context) {
    final friendList = ref.watch(getAllFriendsProvider);
    return friendList.when(
      data: (request){
        return SliverList.builder(
            itemCount: request.length,
            itemBuilder: (context , index){
              final userId = request.elementAt(index);
              return FriendTile(userId: userId);});
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
