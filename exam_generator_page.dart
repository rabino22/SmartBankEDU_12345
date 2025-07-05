import 'package:flutter/material.dart';
import 'local_login_page.dart';
import "login_page.dart";

void main() {
  runApp(const SmartBankEduApp());
}

class SmartBankEduApp extends StatelessWidget {
  const SmartBankEduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartBankEdu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0074B7),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0074B7)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ExamGeneratorPage(),
    );
  }
}

class ExamGeneratorPage extends StatefulWidget {
  const ExamGeneratorPage({super.key});

  @override
  State<ExamGeneratorPage> createState() => _ExamGeneratorPageState();
}

class _ExamGeneratorPageState extends State<ExamGeneratorPage> {
  final Map<String, List<String>> examTypes = {
    'English': ['Multiple Choice', 'True or False', 'Essay'],
    'Math': ['Multiple Choice', 'Problem Solving', 'True or False'],
    'Science': ['Essay', 'True or False', 'Multiple Choice'],
  };

  final Map<String, Set<String>> selectedExams = {
    'English': {},
    'Math': {},
    'Science': {},
  };

  final Map<String, Map<String, int>> examItemCounts = {
    'English': {},
    'Math': {},
    'Science': {},
  };

  bool examGenerated = false;
  bool hasSelection = false;
  int selectedCount = 0;

  void toggleSelection(String subject, String type) {
    setState(() {
      if (selectedExams[subject]!.contains(type)) {
        selectedExams[subject]!.remove(type);
        examItemCounts[subject]!.remove(type);
      } else {
        selectedExams[subject]!.add(type);
        examItemCounts[subject]![type] = 1;
      }
    });
  }

  void generateExam() {
    bool hasAny = selectedExams.values.any((types) => types.isNotEmpty);
    int totalItems = 0;

    for (var subject in selectedExams.keys) {
      for (var type in selectedExams[subject]!) {
        totalItems += examItemCounts[subject]?[type] ?? 0;
      }
    }

    setState(() {
      hasSelection = hasAny;
      examGenerated = true;
      selectedCount = totalItems;
    });
  }

  void _handleProfileAction(String value) {
    switch (value) {
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfilePage(
              name: 'Juan Dela Cruz',
              email: 'juan@example.com',
              role: 'Contributor',
            ),
          ),
        );
        break;
      case 'settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
        break;
      case 'logout':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
        break;
    }
  }

  Widget buildSubjectTile(String subject) {
    IconData icon;
    Color color;

    switch (subject) {
      case 'English':
        icon = Icons.menu_book;
        color = Colors.indigo.shade100;
        break;
      case 'Math':
        icon = Icons.calculate;
        color = Colors.lightGreen.shade100;
        break;
      case 'Science':
        icon = Icons.science;
        color = Colors.orange.shade100;
        break;
      default:
        icon = Icons.book;
        color = Colors.grey.shade300;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: color,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.black87),
        ),
        title: Text(
          subject,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: examTypes[subject]!.map((type) {
          final isSelected = selectedExams[subject]!.contains(type);
          return Column(
            children: [
              CheckboxListTile(
                activeColor: Colors.indigo,
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                title: Text(type),
                value: isSelected,
                onChanged: (_) => toggleSelection(subject, type),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 72,
                    right: 20,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      const Text("No. of items:"),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final intCount = int.tryParse(value) ?? 1;
                            setState(() {
                              examItemCounts[subject]![type] = intCount;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "e.g. 5",
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Generate Exam"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.person),
            onSelected: _handleProfileAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.account_circle, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('View Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Select Exam Types",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: examTypes.keys.map(buildSubjectTile).toList(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: generateExam,
              icon: const Icon(Icons.upload_file),
              label: const Text("Generate Exam"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0074B7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (examGenerated)
              ListTile(
                leading: Icon(
                  hasSelection ? Icons.check_circle : Icons.cancel,
                  color: hasSelection ? Colors.green : Colors.red,
                ),
                title: Text(
                  hasSelection
                      ? "Combined_Exam.pdf ($selectedCount items)"
                      : "No exam selected",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;
  final String role;

  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Chip(
                  label: Text(role.toUpperCase()),
                  backgroundColor: Colors.indigo.shade100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: darkMode,
            onChanged: (val) {
              setState(() => darkMode = val);
            },
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: Text(selectedLanguage),
            onTap: () {
              setState(() {
                selectedLanguage = selectedLanguage == 'English'
                    ? 'Filipino'
                    : 'English';
              });
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Privacy"),
            subtitle: const Text("Manage permissions"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About App"),
            subtitle: const Text("SmartBankEdu v1.0"),
          ),
        ],
      ),
    );
  }
}
