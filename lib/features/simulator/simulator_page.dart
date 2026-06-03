import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  int _selectedEmailIndex = -1;
  String _selectedFolder = 'Inbox';

  final List<Map<String, String>> emails = [
    {
      'sender': 'John Doe',
      'subject': 'Project Update - Q3 Goals',
      'preview': 'Hi, I wanted to follow up on the project timeline and discuss the upcoming milestones...',
      'date': 'Today',
      'body': 'Hi,\n\nI wanted to follow up on the project timeline and discuss the upcoming milestones. As we approach the end of Q2, it\'s important we align on priorities for Q3.\n\nBest regards,\nJohn Doe',
    },
    {
      'sender': 'Sarah Smith',
      'subject': 'Meeting Invitation - Design Review',
      'preview': 'You\'re invited to our weekly design review meeting on Thursday at 2 PM...',
      'date': 'Yesterday',
      'body': 'Hi,\n\nYou\'re invited to our weekly design review meeting on Thursday at 2 PM. We\'ll be discussing the new UI components.\n\nBest regards,\nSarah Smith',
    },
    {
      'sender': 'Michael Johnson',
      'subject': 'Re: Budget Proposal',
      'preview': 'Thanks for sending over the budget proposal. I\'ve reviewed it and have a few questions...',
      'date': '2 days ago',
      'body': 'Thanks for sending over the budget proposal. I\'ve reviewed it and have a few questions about the allocation for Q3.\n\nBest regards,\nMichael Johnson',
    },
    {
      'sender': 'Emily Brown',
      'subject': 'Your Flight Confirmation - Trip to NYC',
      'preview': 'Your flight confirmation for your trip to New York is ready. Your booking reference is...',
      'date': '3 days ago',
      'body': 'Your flight confirmation for your trip to New York is ready. Your booking reference is ABC123456. Please find your itinerary attached.\n\nHappy travels!',
    },
    {
      'sender': 'Tech Support',
      'subject': 'Account Security Alert',
      'preview': 'We detected an unusual login attempt to your account. If this wasn\'t you, please...',
      'date': '1 week ago',
      'body': 'We detected an unusual login attempt to your account from a new location. If this wasn\'t you, please secure your account immediately.\n\nSecurity Team',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          SizedBox(
            width: 250,
            child: Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Compose new email')),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Compose'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                        ),
                      ),
                    ),
                    const Divider(),
                    _buildFolderItem('Inbox', Icons.inbox, 0),
                    _buildFolderItem('Starred', Icons.star, 0),
                    _buildFolderItem('Sent', Icons.send, 0),
                    _buildFolderItem('Drafts', Icons.drafts, 0),
                    _buildFolderItem('All Mail', Icons.mail, 5),
                    _buildFolderItem('Trash', Icons.delete, 0),
                    _buildFolderItem('Spam', Icons.warning, 2),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Labels',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    _buildLabelItem('Work', Colors.blue),
                    _buildLabelItem('Personal', Colors.green),
                    _buildLabelItem('Urgent', Colors.red),
                    _buildLabelItem('Follow Up', Colors.orange),
                  ],
                ),
              ),
            ),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Bar with Search
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search mail...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Refreshing emails...')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Opening settings...')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Email List or Detail View
                Expanded(
                  child: _selectedEmailIndex == -1
                      ? _buildEmailList()
                      : _buildEmailDetail(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderItem(String name, IconData icon, int count) {
    bool isSelected = _selectedFolder == name;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.grey[600],
      ),
      title: Text(
        name,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: count > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: () {
        setState(() {
          _selectedFolder = name;
          _selectedEmailIndex = -1;
        });
      },
    );
  }

  Widget _buildLabelItem(String label, Color color) {
    return ListTile(
      leading: Icon(
        Icons.label,
        color: color,
      ),
      title: Text(label),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opened label: $label')),
        );
      },
    );
  }

  Widget _buildEmailList() {
    return ListView.builder(
      itemCount: emails.length,
      itemBuilder: (context, index) {
        final email = emails[index];
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                email['sender']![0].toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              email['sender']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email['subject']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  email['preview']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: Text(
              email['date']!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            onTap: () {
              setState(() {
                _selectedEmailIndex = index;
              });
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailDetail() {
    final email = emails[_selectedEmailIndex];
    return Column(
      children: [
        // Email Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedEmailIndex = -1;
                  });
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      email['subject']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.archive),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email archived')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email deleted')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.star_border),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email starred')),
                  );
                },
              ),
            ],
          ),
        ),
        // Email Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      child: Text(
                        email['sender']![0].toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            email['sender']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            email['sender']!.toLowerCase().replaceAll(' ', '.') +
                                '@example.com',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      email['date']!,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  email['body']!,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Reply Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply compose window opened')),
                  );
                },
                icon: const Icon(Icons.reply),
                label: const Text('Reply'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply all compose window opened')),
                  );
                },
                icon: const Icon(Icons.reply_all),
                label: const Text('Reply All'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Forward compose window opened')),
                  );
                },
                icon: const Icon(Icons.forward),
                label: const Text('Forward'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
