import 'package:flutter/material.dart';
import 'add_post_screen.dart';
import 'edit_post_screen.dart';
import '../../viewmodels/post_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:campusapp/core/routes.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โพสต์ทั้งหมด'),
        backgroundColor: const Color(0xFF113F67),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.home);
          },
        ),
      ),
      body: Consumer<PostViewModel>(
        builder: (context, viewModel, child) {
          return RefreshIndicator(
            onRefresh: viewModel.fetchPosts,
            child: ListView.builder(
              itemCount: viewModel.posts.length,
              itemBuilder: (context, index) {
                final post = viewModel.posts[index];

                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.content),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => EditPostPage(
                                  docId: post.id,
                                  title: post.title,
                                  content: post.content,
                                ),
                          ),
                        );
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text("ยืนยันการลบ"),
                                content: const Text(
                                  "คุณแน่ใจหรือไม่ว่าต้องการลบโพสต์นี้?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text("ยกเลิก"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text("ลบ"),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          await viewModel.deletePost(post.id);
                        }
                      }
                    },
                    itemBuilder:
                        (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('แก้ไข')),
                          PopupMenuItem(value: 'delete', child: Text('ลบ')),
                        ],
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPostPage()),
          );
        },
      ),
    );
  }
}
