import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();

    // Provide the video URL directly here
    _videoPlayerController = VideoPlayerController.asset(
        'assets/videos/your_video.mp4'); // Replace 'your_video.mp4' with your actual video file
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
    _videoPlayerController.play();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/backgroundimage.png'),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      width: 280,
                      height: 375,
                      decoration: BoxDecoration(
                        color: const Color(0xFF312434),
                        borderRadius: BorderRadius.circular(38),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3FFFFFFF),
                            blurRadius: 28.30,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(38),
                        child: _videoPlayerController.value.isInitialized
                            ? AspectRatio(
                          aspectRatio:
                          _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        )
                            : Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'START YOUR JOURNEY WITH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'WildLife Conservation in AI 🚀',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/welcomepage');
                            },
                            icon: Image.asset('assets/images/nextbutton.png'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
