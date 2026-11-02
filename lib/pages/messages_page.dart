import 'package:flutter/material.dart';
import 'package:my_web_project/responsive_layout.dart';
import 'package:my_web_project/theme.dart';

// Mock data for chat conversations
class ChatConversation {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;
  final List<ChatMessage> messages;

  ChatConversation({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.unreadCount = 0,
    required this.messages,
  });
}

class ChatMessage {
  final String text;
  final bool isSentByMe;
  final String timestamp;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
  });
}

final List<ChatConversation> mockConversations = [
  ChatConversation(
    name: 'Kavya',
    lastMessage: 'See you then!',
    time: '3:45 PM',
    avatarUrl: 'assets/avatar/woman1.jpg',
    unreadCount: 2,
    messages: [
      ChatMessage(text: 'Hi there!', isSentByMe: false, timestamp: '3:40 PM'),
      ChatMessage(
        text: 'Hello! How are you?',
        isSentByMe: true,
        timestamp: '3:41 PM',
      ),
      ChatMessage(
        text: 'I am good, thanks! What about you?',
        isSentByMe: false,
        timestamp: '3:42 PM',
      ),
      ChatMessage(
        text: 'Doing great. Are we still on for tomorrow?',
        isSentByMe: true,
        timestamp: '3:43 PM',
      ),
      ChatMessage(
        text: 'Yes, absolutely!',
        isSentByMe: false,
        timestamp: '3:44 PM',
      ),
      ChatMessage(
        text: 'See you then!',
        isSentByMe: false,
        timestamp: '3:45 PM',
      ),
    ],
  ),
  ChatConversation(
    name: 'Arjun',
    lastMessage: 'Okay, sounds good.',
    time: '1:30 PM',
    avatarUrl: 'assets/avatar/man1.jpg',
    messages: [
      ChatMessage(
        text: 'I think I will be there by 6.',
        isSentByMe: false,
        timestamp: '1:29 PM',
      ),
      ChatMessage(
        text: 'Okay, sounds good.',
        isSentByMe: true,
        timestamp: '1:30 PM',
      ),
    ],
  ),
  // ... add more conversations
];

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  ChatConversation? _selectedConversation;

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveLayout.isMobile(context);

    if (isMobile) {
      return _selectedConversation == null
          ? ChatListScreen(
              conversations: mockConversations,
              onConversationTap: (conversation) {
                setState(() {
                  _selectedConversation = conversation;
                });
              },
            )
          : ChatDetailScreen(
              conversation: _selectedConversation!,
              onBack: () {
                setState(() {
                  _selectedConversation = null;
                });
              },
            );
    }

    return Row(
      children: [
        SizedBox(
          width: 320,
          child: ChatListScreen(
            conversations: mockConversations,
            onConversationTap: (conversation) {
              setState(() {
                _selectedConversation = conversation;
              });
            },
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          child: _selectedConversation != null
              ? ChatDetailScreen(conversation: _selectedConversation!)
              : const Center(
                  child: Text('Select a conversation to start chatting'),
                ),
        ),
      ],
    );
  }
}

class ChatListScreen extends StatelessWidget {
  final List<ChatConversation> conversations;
  final ValueChanged<ChatConversation> onConversationTap;

  const ChatListScreen({
    super.key,
    required this.conversations,
    required this.onConversationTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(conversation.avatarUrl),
          ),
          title: Text(
            conversation.name,
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            conversation.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(conversation.time, style: AppTextStyles.footerText),
              if (conversation.unreadCount > 0) ...[
                const SizedBox(height: 4),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.primary500,
                  child: Text(
                    conversation.unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
          onTap: () => onConversationTap(conversation),
        );
      },
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback? onBack;

  const ChatDetailScreen({super.key, required this.conversation, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onBack != null)
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
            title: Text(conversation.name),
            elevation: 1,
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            reverse: true,
            itemCount: conversation.messages.length,
            itemBuilder: (context, index) {
              final message = conversation.messages.reversed.toList()[index];
              return Align(
                alignment: message.isSentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: message.isSentByMe
                        ? AppColors.primary500
                        : AppColors.secondary200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isSentByMe
                          ? Colors.white
                          : AppColors.textColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        _buildMessageComposer(),
      ],
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.secondary100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary500),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
