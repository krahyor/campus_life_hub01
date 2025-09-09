import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/post_viewmodel.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitPost() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกหัวข้อและเนื้อหา')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<PostViewModel>(
        context,
        listen: false,
      ).addPost(title, content);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มโพสต์')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'หัวข้อ'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'เนื้อหา'),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _submitPost,
                  child: const Text('โพสต์เลย'),
                ),
          ],
        ),
      ),
    );
  }
}
