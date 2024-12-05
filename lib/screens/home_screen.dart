import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'chat_screen.dart';

class MekaBot extends StatefulWidget {
  @override
  _MekaBotState createState() => _MekaBotState();
}

class _MekaBotState extends State<MekaBot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Start a timer to play the animation at regular intervals
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_controller.isAnimating) {
        _controller.reset();
        _controller.forward();
      }
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

  void _handleMenuItem(String menuItem) {
    Navigator.pop(context); // Close the drawer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $menuItem')),
    );
    // You can navigate to corresponding screens based on menu items here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MekaBot'),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat History'),
              onTap: () => _handleMenuItem('Chat History'),
            ),
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text('Call Workshop'),
              onTap: () => _handleMenuItem('Call Workshop'),
            ),
            ListTile(
              leading: const Icon(Icons.car_repair),
              title: const Text('Request Tow Truck'),
              onTap: () => _handleMenuItem('Request Tow Truck'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: const Border(top: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () => _navigateToChatScreen(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}