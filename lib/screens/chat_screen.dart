import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'service_status_screen.dart';
import 'package:chatbot_app/model/Service.dart';

const apiUrl = "https://k2pat.net/mekabot";
const imagePrefix = "data:image/jpeg;base64,";



class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // Updated to support buttons
  final List<Uint8List> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isNewChat = true;
  Service? _service;

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
        return {'type': 'image_url', 'image_url': {'url': imagePrefix + base64Image}};
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
        body: json.encode({'content': content, 'new': _isNewChat}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isNewChat = false;
        });
        final List<dynamic> botResponses = json.decode(utf8.decode(response.bodyBytes));

        for (var botResponse in botResponses) {
          if (botResponse['type'] == 'text' && botResponse['text'] != null) {
            setState(() {
              _messages.add({'bot': {'text': botResponse['text']}});
            });
          } else if (botResponse['type'] == 'button' && botResponse['button'] != null) {
            final button = botResponse['button'];
            setState(() {
              _messages.add({
                'bot': {
                  'text': null,
                  'buttons': [
                    {'label': button['label'], 'action': button['action']}
                  ]
                }
              });
            });
          } else if (botResponse['type'] == 'service' && botResponse['service'] != null) {
            final service = botResponse['service'];
            setState(() {
              _service = Service(service['service_type'], service['description'], service['icon_url']);
            });
          }
        }
      } else {
        setState(() {
          _messages.add({'bot': {'text': 'Error: Unable to fetch response.'}});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'bot': {'text': 'Error: ${e.toString()}'}});
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.containsKey('user');
                final messageData = isUserMessage ? message['user'] : message['bot'];

                return Container(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      // Display images
                      if (messageData['images'] != null && messageData['images'].isNotEmpty)
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: (messageData['images'] as List<Uint8List>).map((imageBytes) {
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
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUserMessage ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            messageData['text'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      // Display buttons
                      if (messageData['buttons'] != null && messageData['buttons']!.isNotEmpty)
                        Wrap(
                          spacing: 10,
                          children: (messageData['buttons'] as List<Map<String, dynamic>>).map((button) {
                            return ElevatedButton(
                              onPressed: () => _handleButtonTap(button['action'] ?? ''),
                              child: Text(button['label'] ?? 'Unknown'),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_service != null)
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ServiceStatusScreen(service: _service!)
                ));
              },
              child: const Text('View status'),
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
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _captureImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _sendMessage(_controller.text),
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
