import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class LoginAssets extends StatefulWidget {
  const LoginAssets({super.key});

  @override
  State<LoginAssets> createState() => _LoginAssetsState();
}

class _LoginAssetsState extends State<LoginAssets>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _controller.addListener(() {
      if (mounted && context.mounted) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 188, 143, 244),
                        Colors.white,
                      ]),
                  shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: const Color.fromARGB(146, 98, 0, 246),
                      shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                        image: const DecorationImage(
                          image: AssetImage(
                            "assets/images/logo.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedRotation(
          turns: 1 - _animation.value,
          duration: const Duration(milliseconds: 0),
          child: DottedBorder(
            borderType: BorderType.Circle,
            radius: const Radius.circular(30),
            color: Colors.pink.shade100,
            strokeWidth: 3,
            dashPattern: const [20, 10],
            child: Container(
              height: 320,
              width: 320,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 55,
                    right: 0,
                    left: 0,
                    child: RotationTransition(
                      turns: _animation,
                      child: Container(
                        height: 50,
                        width: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/bt1.jpg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 170,
                    right: 0,
                    left: 230,
                    child: RotationTransition(
                      turns: _animation,
                      child: Container(
                        height: 50,
                        width: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/bt2.jpg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 70,
                    right: 280,
                    left: 0,
                    child: RotationTransition(
                      turns: _animation,
                      child: Container(
                        height: 60,
                        width: 60,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/bt3.jpg"),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 0,
                    left: 100,
                    child: RotationTransition(
                      turns: _animation,
                      child: Container(
                        height: 40,
                        width: 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/bt4.jpg"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
