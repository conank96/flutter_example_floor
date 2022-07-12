import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sqlite_demo/miniplayer/uiplayer/video_card.dart';
import 'package:sqlite_demo/miniplayer/uiplayer/player_provider.dart';
import 'package:sqlite_demo/miniplayer/uiplayer/player_provider.dart';
import 'package:video_player/video_player.dart';

import '../../extension.dart';
import '../miniplayer.dart';
import 'player_provider.dart';
import 'Video.dart';

const double videoBoxHeight = 220;
const double videoBoxRatio = 360 / 205;

Widget videoScreen(
    MiniplayerController provider,
    double percentage,
    double screenWidth,
    ScrollController scrollController,
    PlayerManager playerManager,
    VoidCallback callback) {
  var videos = fakeItems();

  double? opacity = calculateOpacity(percentage);
  double? opacityList = lerpDouble(0.0, 1.0, percentage);

  double videoWidth = lerp((screenWidth - (56 * 2)) / 2, screenWidth, percentage * 10);
  double videoHeight = videoWidth / playerManager.controller.value.aspectRatio;

  double? clipHeightFactor = percentage > 0.1
      ? lerp(112 / (screenWidth / videoBoxRatio), 1, percentage)
      : 1;

  notify("percentage: $percentage --- clip: $clipHeightFactor");

  return Column(
    children: [
      Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          contentVideoMini(playerManager, opacity, () {
            callback();
          }),
          GestureDetector(
              onTap: () {
                notify("click video");
                if (playerManager.controller.value.isPlaying) {
                  playerManager.pause();
                } else {
                  playerManager.play();
                }
              }, // Image tapped
              child: ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  heightFactor: clipHeightFactor,
                  child: SizedBox(
                      height: videoHeight,
                      width: videoWidth,
                      child: VideoPlayer(playerManager.controller)), //
                ),
              )),
        ],
      ),
      Expanded(
          flex: 1,
          child: listVideos(videos, scrollController, opacityList ?? 0.0))
    ],
  );
}

Widget iconViews() {
  return Row(
    children: const [
      Expanded(
        flex: 1,
        child: Icon(
          Icons.link_off,
          size: 25,
        ),
      ),
      Expanded(
        flex: 1,
        child: Icon(
          Icons.share,
          size: 25,
        ),
      ),
      Expanded(
        flex: 1,
        child: Icon(
          Icons.download,
          size: 25,
        ),
      ),
      Expanded(
        flex: 1,
        child: Icon(
          Icons.cut,
          size: 25,
        ),
      ),
      Expanded(
        flex: 1,
        child: Icon(
          Icons.save_alt,
          size: 25,
        ),
      )
    ],
  );
}

Widget contentVideoMini(
    PlayerManager playerManager, double opacity, VoidCallback callback) {
  return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.only(left: 170),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: const [
                Text(
                  "this is content video",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                Text("robert fukuda",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w200)),
              ],
            )),
            InkWell(
                onTap: () {
                  if (playerManager.controller.value.isPlaying) {
                    playerManager.pause();
                  } else {
                    playerManager.play();
                  }
                  callback();
                },
                child: Icon(
                  playerManager.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  size: 32,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.close,
                  size: 32,
                )),
          ],
        ),
      ));
}

Widget navigationBar() {
  return Container(
    color: Colors.white,
    height: 48,
    child: Row(
      children: const [
        Expanded(
            flex: 1,
            child: Icon(
              Icons.home,
              size: 25,
            )),
        Expanded(
            flex: 1,
            child: Icon(
              Icons.short_text_outlined,
              size: 25,
            )),
        Expanded(
            flex: 1,
            child: Icon(
              Icons.add,
              size: 25,
            )),
        Expanded(
            flex: 1,
            child: Icon(
              Icons.subscriptions,
              size: 25,
            )),
        Expanded(
            flex: 1,
            child: Icon(
              Icons.video_library,
              size: 25,
            )),
      ],
    ),
  );
}

Widget content() {
  return const Padding(
    padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
    child: Text(
      "Tập thể dục buổi sáng, Gà trống mèo con Cún con - Liên khúc nhạc thiếu nhi",
      maxLines: 2,
      style: TextStyle(fontSize: 16),
    ),
  );
}

Widget listVideos(
    List<Video> videos, ScrollController scrollController, double opacity) {
  return Scrollbar(
      child: Opacity(
          opacity: opacity,
          child: ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              var item = videos[index];
              if (item.type == Type.header) {
                return headerItem();
              } else {
                return VideoCard(video: videos[index]);
              }
            },
            itemCount: videos.length,
          )));
}

Widget headerItem() {
  return Container(
    width: double.infinity,
    alignment: Alignment.topLeft,
    height: 80,
    child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Text(
            "But if you want to change the opacity of all the widget, in your case a Container, you can wrap it into a Opacity widget like this",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: iconViews(),
        )
      ],
    ),
  );
}
