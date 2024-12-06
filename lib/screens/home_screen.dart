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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
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
              leading: Builder(
                builder: (context) => Container(
                  width: kToolbarHeight, // Ensure the icon area has a fixed width
                  alignment: Alignment.centerLeft, // Align the icon to the left
                  margin: const EdgeInsets.only(left: 18.0), // Add margin to the left
                  child: IconButton(
                    icon: Image.asset('icons/history.png'), // Use the custom icon
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
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
          AnimatedOpacity(
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
          Padding(
            padding: const EdgeInsets.only(top: 60.0), // Add 60px space from the top
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              // decoration: BoxDecoration(
              //   color: Theme.of(context).colorScheme.surface,
              //   border: Border(
              //     top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
              //   ),
              // ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the Row contents
                  children: [
                    Container(
                      width: 325, // Set the desired width here
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background, // Use theme background color
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: "Message",
                          prefixIcon: Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.primary), // Add camera icon
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isTextFieldEmpty ? Icons.mic : Icons.send,
                              color: Theme.of(context).colorScheme.primary,
                            ), // Change icon based on text field content
                            onPressed: () {
                              if (_isTextFieldEmpty) {
                                // Handle microphone button press
                              } else {
                                // Handle send button press
                                _navigateToChatScreen(context);
                              }
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Color(0xFF00B3FE),
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.0),
                          hintStyle: Theme.of(context).textTheme.bodyMedium, // Apply theme text style
                        ),
                        style: Theme.of(context).textTheme.bodyMedium, // Apply theme text style
                      ),
                    ),
                  // IconButton(
                  //   icon: Icon(Icons.mic, color: Theme.of(context).colorScheme.primary), // Change icon to microphone
                  //   onPressed: () => _navigateToChatScreen(context),
                  // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}