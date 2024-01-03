import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoapp/bloc/video_bloc/video_bloc.dart';
import 'package:videoapp/bloc/video_bloc/video_events.dart';
import 'package:videoapp/presentation/widgets/custom_appbar.dart';
import 'package:videoapp/presentation/widgets/list_videos.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: const CustomAppBar(
              refresh: true,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<VideoBloc>(context).add(LoadVideo());
              },
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          hintText: "Search",
                          prefixIcon: const Icon(
                            Icons.search,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.5))),
                    ),
                  ),
                  const ShowVideos()
                ],
              ),
            )));
  }
}
