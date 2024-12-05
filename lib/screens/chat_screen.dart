import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _textController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image picked");
      }
    });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image picked");
      }
    });
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      setState(() {
        // Add user's message
        messages.add({
          'type': 'user',
          'text': _textController.text.trim(),
        });

        // Add chatbot's response (dummy response for now)
        messages.add({
          'type': 'bot',
          'text': 'Hello! How can I assist you?',
        });
      });
      _textController.clear();
    }
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUser = message['type'] == 'user';
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          const CircleAvatar(
            radius: 16,
            child: Icon(Icons.android),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message['text']!,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            child: Icon(Icons.person),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with MekaBot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border:
                  const Border(top: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Column(
              children: [
                _image != null
                    ? Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.file(
                            _image!.absolute,
                            fit: BoxFit.contain,
                          )),
                    )
                    : Container(),
                Row(
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
                      icon: const Icon(Icons.camera, color: Colors.blue),
                      onPressed: getImageCamera,
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
