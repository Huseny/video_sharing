import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:videoapp/bloc/video_bloc/video_bloc.dart';
import 'package:videoapp/bloc/video_bloc/video_events.dart';
import 'package:videoapp/routes_config/route_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.refresh});

  final bool? refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(color: Colors.black38),
      child: Row(
        children: [
          const Expanded(
            child: Row(
              children: [
                Icon(Icons.camera_enhance_rounded),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Share Videos",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (refresh != null)
            IconButton(
                onPressed: () {
                  BlocProvider.of<VideoBloc>(context).add(LoadVideo());
                },
                icon: const Icon(Icons.refresh)),
          PopupMenuButton(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(255, 255, 255, 1)),
              child: Icon(
                Icons.add,
                color: Colors.blue.shade900,
              ),
            ),
            itemBuilder: (context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  child: const Text("Upload Video"),
                  onTap: () {
                    GoRouter.of(context).pushNamed(RouteConstants.upload);
                  },
                )
              ];
            },
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(0, kToolbarHeight);
}
