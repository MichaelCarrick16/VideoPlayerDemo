import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController controller;
  ChewieController? chewieController;

  Future<void> loadVideoPlayer() async {
    controller = VideoPlayerController.network(
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4');

    await Future.wait([
      controller.initialize()
    ]);

    chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: false,
        looping: false,
        subtitle: Subtitles(
          [
            Subtitle(
                index: 0,
                start: const Duration(seconds: 4),
                end: const Duration(seconds: 7),
                text: 'What\'s up?'
            )
          ],
        ),
        subtitleBuilder: (context, subtitle) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        }
    );
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    loadVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    chewieController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        children: [
          Expanded(child: Center(
            child: chewieController != null &&
                chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(controller: chewieController!)
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20.0,),
                Text('Loading')
              ],
            ),
          ))
        ],
      ),
    );
  }
}

