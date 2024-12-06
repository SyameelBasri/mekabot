import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'chat_screen.dart';

class MekaBot extends StatefulWidget {
  const MekaBot({Key? key}) : super(key: key);

  @override
  _MekaBotState createState() => _MekaBotState();
}

class _MekaBotState extends State<MekaBot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  final TextEditingController _textController = TextEditingController();
  bool _isTextFieldEmpty = true;
  bool _isTextVisible = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Start a timer to play the animation at regular intervals
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_controller.isAnimating) {
        _controller.reset();
        _controller.forward();
      }
    });
    
    _textController.addListener(() {
      setState(() {
        _isTextFieldEmpty = _textController.text.isEmpty;
      });
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isTextVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _navigateToChatScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF9FF), // Change Scaffold background color
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20), // Add 20px to the default AppBar height
        child: Column(
          children: [
            const SizedBox(height: 20), // Add 20px space at the top
            AppBar(
              title: const Text(
                'MekaBot',
                style: TextStyle(color: Colors.black), // Change title color
              ),
              centerTitle: true, // Center the title
              backgroundColor: Colors.transparent, // Make AppBar background transparent
              elevation: 0, // Remove shadow
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Align(
              alignment: const Alignment(0, -0.5), // Reposition animation
              child: GestureDetector(
                onTap: () {
                  if (!_controller.isAnimating) {
                    _controller.reset();
                    _controller.forward();
                  }
                },
                child: Lottie.asset(
                  'assets/robot.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: AnimatedOpacity(
              opacity: _isTextVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: AnimatedSlide(
                offset: _isTextVisible ? Offset(0, 0) : Offset(0, 0.5),
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontFamily: 'SansSerif', // Ensure this font is available in your project
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      width: 300, // Set the desired width here
                      child: const Text(
                        'Let us know if you have car related issues!',
                        style: TextStyle(
                          fontFamily: 'SansSerif', // Ensure this font is available in your project
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF393939),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 100, // Set the desired width here
                height: 100, // Set the desired height here
                child: ElevatedButton(
                  onPressed: () => _navigateToChatScreen(context),
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.cyan, // Button color
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}