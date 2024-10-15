import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:brr/design_materials/design_materials.dart';
import '../../constants/url.dart';
import 'package:get/get.dart'; 

class ChatingPageView extends StatefulWidget {
  final int taxiId;
  const ChatingPageView({super.key, required this.taxiId});

  @override
  _ChatingPageViewState createState() => _ChatingPageViewState();
}

class _ChatingPageViewState extends State<ChatingPageView> {
  late WebSocketChannel channel; 
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];  
  final String myNickname = "나"; 

  @override
  void initState() {
    super.initState();
    int taxiId = widget.taxiId;

  
    channel = WebSocketChannel.connect(
      Uri.parse('ws://${Urls.wsUrl}chat/$taxiId/ws'), 
    );
    
  
    channel.stream.listen((message) {
   
      var receivedMessage = parseMessage(message); 

      setState(() {
        _messages.add({
          'nickname': receivedMessage['nickname'],  
          'text': receivedMessage['text'],  
          'isMe': receivedMessage['nickname'] == myNickname,  
        });
      });
    });
  }

  Map<String, dynamic> parseMessage(String message) {
    return {
      'nickname': '상대방', 
      'text': message
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Stack(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  '택시 팟이 완성되었어요!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  '함께하는 사람들과 필요한 대화를 나누어보세요',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 12),
                Divider(
                  color: Color(0xFFDBDBDB),
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
            Positioned(
              top: 30,
              left: 20,
              child: gobackButton(),  
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const Text("채팅창", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    text: _messages[index]['text'],
                    isMe: _messages[index]['isMe'],
                    nickname: _messages[index]['nickname'],
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFD3E5FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.near_me_outlined, color: Colors.black, size: 30),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      var message = _controller.text;
      
      setState(() {
        _messages.add({
          'nickname': myNickname,  
          'text': message,
          'isMe': true, 
        });
      });

      channel.sink.add(message);

      _controller.clear();
    }
  }

  @override
  void dispose() {
    channel.sink.close();  
    _controller.dispose();
    super.dispose();
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String nickname;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Column(
              children: [
                chatProfile(),
                Text(
                  nickname,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          if (!isMe) const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
          if (isMe) const SizedBox(width: 8),
          if (isMe) chatProfile(),
        ],
      ),
    );
  }

  Widget chatProfile() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: const Center(
        child: Icon(Icons.person_outline, size: 20, color: Colors.black),
      ),
    );
  }
}