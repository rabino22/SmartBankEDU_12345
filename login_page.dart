import 'package:flutter/material.dart';
import 'local_login_page.dart';
import 'login_page.dart';

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

  bool examGenerated = false;
  bool hasSelection = false;

  void toggleSelection(String subject, String type) {
    setState(() {
      if (selectedExams[subject]!.contains(type)) {
        selectedExams[subject]!.remove(type);
      } else {
        selectedExams[subject]!.add(type);
      }
    });
  }

  void generateExam() {
    bool hasAny = selectedExams.values.any((types) => types.isNotEmpty);
    setState(() {
      hasSelection = hasAny;
      examGenerated = true;
    });
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
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
              role: 'contributor',
            ),
          ),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening settings...')),
        );
        break;
      case 'logout':
        _confirmLogout(context);
        break;
    }
  }

  Widget buildSubjectTile(String subject) {
    IconData icon;
    Color color;

    switch (subject) {
      case 'English':
        icon = Icons.menu_book;
        color = Colors.deepPurple.shade100;
        break;
      case 'Math':
        icon = Icons.calculate;
        color = Colors.teal.shade100;
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
          return CheckboxListTile(
            activeColor: Colors.indigo,
            checkboxShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text(type),
            value: selectedExams[subject]!.contains(type),
            onChanged: (_) => toggleSelection(subject, type),
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
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.account_circle, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('View Profile'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
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
              const PopupMenuItem<String>(
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  hasSelection ? "Combined_Exam.pdf" : "No exam selected",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Profile Page (inline version)
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 8),
                Chip(label: Text(role.toUpperCase())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
