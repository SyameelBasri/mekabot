import 'dart:convert';

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'service_status_screen.dart';
import 'package:chatbot_app/model/Service.dart';
import 'package:lottie/lottie.dart';
import 'package:chatbot_app/utils/scroll_physics.dart';

const apiUrl = "https://k2pat.net/mekabot";
const imagePrefix = "data:image/jpeg;base64,";



class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = []; // Updated to support buttons
  final List<Uint8List> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isNewChat = true;
  Service? _service;
  String? session;
  bool _showCTA = false;

  //UI Stuffs - Faris Start
  Timer? _timer;
  final TextEditingController _textController = TextEditingController();
  bool _isTextFieldEmpty = true;
  bool _isTextVisible = false;

  @override
  void initState() {
    super.initState();

    // Start a timer to play the animation at regular intervals

    _controller.addListener(() {
      setState(() {
        _isTextFieldEmpty = _controller.text.isEmpty;
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

  //UI Stuffs - Faris End

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty && _images.isEmpty) return;

    setState(() {
      _messages.add({
        'user': {'text': message, 'images': _images.toList()}
      });
      _isLoading = true;
    });

    try {
      // Convert images to base64
      List<Map<String, dynamic>> base64Images = _images.map((imageBytes) {
        final base64Image = base64Encode(imageBytes);
        return {
          'type': 'image_url',
          'image_url': {'url': imagePrefix + base64Image}
        };
      }).toList();

      // Prepare content
      List<Map<String, dynamic>> content = [
        if (message.isNotEmpty) {'type': 'text', 'text': message},
        ...base64Images,
      ];

      // Replace with your server endpoint
      const url = apiUrl;
      // final client = http.Client() as BrowserClient;
      // client.withCredentials = true;
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'content': content, 'new': _isNewChat, 'session': session}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isNewChat = false;
        });
        final Map<String, dynamic> responseObj = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> botResponses = responseObj['content'];
        session = responseObj['session'];

        for (var botResponse in botResponses) {
          if (botResponse['type'] == 'text' && botResponse['text'] != null) {
            setState(() {
              _messages.add({
                'bot': {'text': botResponse['text']}
              });
            });
          } else if (botResponse['type'] == 'button' &&
              botResponse['button'] != null) {
            final button = botResponse['button'];
            setState(() {
              _showCTA = true;
              _messages.add({
                'bot': {
                  'text': null,
                  'buttons': [
                    {'label': button['label'], 'action': button['action']}
                  ]
                }
              });
            });
          } else if (botResponse['type'] == 'service' &&
              botResponse['service'] != null) {
            final service = botResponse['service'];
            setState(() {
              _service = Service(service['service_type'],
                  service['description'], service['icon_url']);
            });
          }
        }
      } else {
        setState(() {
          _messages.add({
            'bot': {'text': 'Error: Unable to fetch response.'}
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'bot': {'text': 'Error: ${e.toString()}'}
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
        _images.clear();
      });
    }
    _controller.clear();
  }

  Future<void> _pickImage() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      for (var pickedFile in pickedFiles) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _images.add(imageBytes);
        });
      }
    }
  }

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _images.add(imageBytes);
      });
    }
  }

  void _handleButtonTap(String action) {
    // Send the action as a message and hide the buttons
    _sendMessage(action);

    setState(() {
      _showCTA = false;
    });
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFECF9FF), // Change Scaffold background color
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            kToolbarHeight + 20), // Add 20px to the default AppBar height
        child: Column(
          children: [
            const SizedBox(height: 20), // Add 20px space at the top
            AppBar(
              title: const Text(
                'MekaBot',
                style: TextStyle(color: Colors.black), // Change title color
              ),
              centerTitle: true, // Center the title
              backgroundColor:
                  Colors.transparent, // Make AppBar background transparent
              elevation: 0, // Remove shadow
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const PositionRetainedScrollPhysics(),
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.containsKey('user');
                final messageData =
                    isUserMessage ? message['user'] : message['bot'];

                return Container(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: isUserMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      // Display images
                      if (messageData['images'] != null &&
                          messageData['images'].isNotEmpty)
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: (messageData['images'] as List<Uint8List>)
                              .map((imageBytes) {
                            return Image.memory(
                              imageBytes,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                        ),
                      // Display text
                      if (messageData['text'] != null && messageData['text']!.isNotEmpty)
                        isUserMessage
                            ? Container(
                                margin: const EdgeInsets.all(5.0), // Existing margin
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3), // Shadow position
                                    ),
                                  ],
                                ),
                                child: Text(
                                  messageData['text'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                            : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('icons/bot-icon.png'),
                                const SizedBox(width: 10), // Spacing between icon and container
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(5.0), // Existing margin
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: const Color(0xFF00B3FE),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          messageData['text'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF393939),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      // Display buttons
                      if (messageData['buttons'] != null &&
                          messageData['buttons']!.isNotEmpty)
                        Visibility(
                          visible: _showCTA,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Wrap(
                              spacing: 10,
                              children: (messageData['buttons']
                                      as List<Map<String, dynamic>>)
                                  .map((button) {
                                return ElevatedButton(
                                  onPressed: () =>
                                      _handleButtonTap(button['action'] ?? ''),
                                  child: Text(button['label'] ?? 'Unknown'),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_service != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 325,
                // margin: const EdgeInsets.all(5.0), // Adds margin around the button
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ServiceStatusScreen(service: _service!)
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: Colors.black, // Te// Padding inside the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // Rounded corners
                      side: const BorderSide(
                        color: Colors.cyan, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    elevation: 5, // Shadow elevation
                    shadowColor: Colors.grey.withOpacity(0.5), // Shadow color
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: Image.network(_service!.iconUrl),
                      title: Text(
                        "View service status",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (_images.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Stack(
                      children: [
                        Image.memory(
                          _images[index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 45,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Color(0xFF666666)),
                            onPressed: () {
                              setState(() {
                                _images.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (_isLoading)
            LinearProgressIndicator(),
          Padding(
            padding:
                const EdgeInsets.only(top: 15.0), // Add 60px space from the top
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
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the Row contents
                  children: [
                    Container(
                      width: 325, // Set the desired width here
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .background, // Use theme background color
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
                        enabled: !_isLoading,
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Message",
                          prefixIcon: IconButton(icon: const Icon(Icons.camera_alt), 
                          onPressed: _pickImage),
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
                                _sendMessage(_controller.text);
                              }
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.cyan,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 9.0),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium, // Apply theme text style
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium, // Apply theme text style
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
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       IconButton(
          //         icon: const Icon(Icons.photo),
          //         onPressed: _pickImage,
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.camera_alt),
          //         onPressed: _captureImage,
          //       ),
          //       Expanded(
          //         child: TextField(
          //           controller: _controller,
          //           decoration: const InputDecoration(
          //             hintText: 'Message',
          //             border: OutlineInputBorder(),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       ElevatedButton(
          //         onPressed: () => _sendMessage(_controller.text),
          //         child: const Text('Send'),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
