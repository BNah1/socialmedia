import 'package:bona/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:bona/feature/post/presentation/widget/round_profile_tile.dart';

class StoryTile extends StatelessWidget {
  const StoryTile({
    super.key,
    required this.imageUrl,
    required this.userPic,
    required this.userName,
  });

  final String imageUrl;
  final String userPic;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageUrl),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 110,
                height: 60,
                color: Colors.white30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  RoundProfileTile(url: userPic),
                  Text(
                    userName,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

