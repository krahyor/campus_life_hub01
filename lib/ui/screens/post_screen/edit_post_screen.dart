import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // เพิ่ม import นี้
import '../../viewmodels/post_viewmodel.dart'; // นำเข้า ViewModel ของคุณ

class EditPostPage extends StatefulWidget {
  final String docId;
  final String title;
  final String content;

  const EditPostPage({
    super.key,
    required this.docId,
    required this.title,
    required this.content,
  });

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  bool _isLoading = false; // สำหรับสถานะโหลด

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  Future<void> _updatePost() async {
    setState(() => _isLoading = true);

    try {
      // เรียกใช้ ViewModel แก้ไขโพสต์
      await Provider.of<PostViewModel>(context, listen: false).updatePost(
        widget.docId,
        _titleController.text,
        _contentController.text,
      );

      Navigator.pop(context); // กลับหน้าก่อนหน้าเมื่อเสร็จ
    } catch (e) {
      // แสดง error dialog
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('แก้ไขโพสต์ไม่สำเร็จ: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("แก้ไขโพสต์")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "หัวข้อ"),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: "เนื้อหา"),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _updatePost,
                  child: const Text("บันทึก"),
                ),
          ],
        ),
      ),
    );
  }
}
