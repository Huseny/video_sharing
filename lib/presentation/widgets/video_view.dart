import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:videoapp/presentation/widgets/custom_shimmer.dart';
import 'package:videoapp/repository/models/video_model.dart';
import 'package:videoapp/routes_config/route_constants.dart';
import 'package:videoapp/utils/format_date_time.dart';

class VideoView extends StatelessWidget {
  const VideoView({super.key, required this.video});
  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CachedNetworkImage(
          imageUrl: video.thumbnailUrl,
          placeholder: (context, url) {
            return const VideoShimmer();
          },
          imageBuilder: (context, imageProvider) {
            return GestureDetector(
              onTap: () {
                GoRouter.of(context)
                    .pushNamed(RouteConstants.play, pathParameters: {
                  'id': video.id,
                  'title': video.title,
                  'videoUrl': video.videoUrl,
                  'author': video.author,
                  'description': video.description,
                  'createdAt': video.createdAt.toString(),
                  'thumbnailUrl': video.thumbnailUrl,
                });
              },
              child: Column(children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Row(
                          children: [
                            Text(
                              "By ${video.author}",
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
                                    .getTimeAgo(video.createdAt)),
                              ],
                            )
                          ],
                        )
                      ]),
                )
              ]),
            );
          },
        ));
  }
}
