import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videoapp/presentation/widgets/custom_appbar.dart';
import 'package:videoapp/repository/models/video_model.dart';
import 'package:videoapp/utils/format_date_time.dart';

class PlayVideo extends StatefulWidget {
  const PlayVideo({super.key, required this.video});
  final VideoModel video;

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late FlickManager flickManager;
  bool isInitialized = false;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.video.videoUrl),
      ),
      autoPlay: false,
    );
    setState(() {
      isInitialized = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              isInitialized
                  ? FlickVideoPlayer(flickManager: flickManager)
                  : const CircularProgressIndicator(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.video.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.video.author,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.av_timer,
                                color: Colors.grey,
                              ),
                              Text(FormatDateTime()
                                  .getTimeAgo(widget.video.createdAt)),
                            ],
                          )
                        ],
                      )
                    ]),
              ),
              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black38),
                    child: Text(
                      widget.video.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 15),
                      overflow: TextOverflow.clip,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
