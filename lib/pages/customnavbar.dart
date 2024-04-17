import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:wildsense/screens/dashboardpages/communitySection/community.dart';
import 'package:wildsense/screens/dashboardpages/homescreen/homescreen.dart';
import 'package:wildsense/screens/dashboardpages/profilescreen/profilescreen.dart';

import '../model/nav_item_mode.dart';

const Color bottomNavBgColor = Color(0xFF3A174C);

class BottomNavWithAnimations extends StatefulWidget {
  const BottomNavWithAnimations({super.key});

  @override
  State<BottomNavWithAnimations> createState() =>
      _BottomNavWithAnimationsState();
}

class _BottomNavWithAnimationsState extends State<BottomNavWithAnimations> {
  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> controllers=[];
  int selectedNavIndex = 0;
  List<Widget> pages=[HomeScreen(), CommunityHomePage(posts: [],), Center(child: Text("Bell")), ProfileScreen()];

  void animateTheIcon(int index) {
    setState(() {
      // Update the selectedNavIndex before animating the icon
      selectedNavIndex = index;
    });

    // Animate the icon based on the updated selectedNavIndex
    if (selectedNavIndex >= 0 && selectedNavIndex < riveIconInputs.length) {
      riveIconInputs[selectedNavIndex].change(true);
      Future.delayed(Duration(seconds: 1), () {
        riveIconInputs[selectedNavIndex].change(false);
      });
    }
  }

  void riveOnInIt(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);
    controllers.add(controller);

    riveIconInputs.add(controller.findInput<bool>('active') as SMIBool);
  }

  @override
  void dispose() {
    for(var controller in controllers){
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedNavIndex,
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: bottomNavBgColor,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: bottomNavBgColor.withOpacity(0.3),
                offset: Offset(0, 20),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(bottomNavItems.length, (index) {
              final riveIcon = bottomNavItems[index].rive;
              return GestureDetector(
                onTap: () {
                  animateTheIcon(index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBar(isActive: selectedNavIndex == index),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Opacity(
                        opacity: selectedNavIndex == index ? 1 : 0.5,
                        child: RiveAnimation.asset(
                          riveIcon.src,
                          artboard: riveIcon.artboard,
                          onInit: (artboard) {
                            riveOnInIt(artboard,
                                stateMachineName: riveIcon.stateMachine);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key, required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(microseconds: 100),
      margin: EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive? 20:0,
      decoration: BoxDecoration(
          color: Color(0xFF81B4FF),
          borderRadius: BorderRadius.all(Radius.circular(12))
      ),
    );
  }
}
