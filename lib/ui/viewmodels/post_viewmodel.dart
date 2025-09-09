import 'package:flutter/material.dart';
import '/models/post.dart';
import '../service/post_service.dart';

class PostViewModel extends ChangeNotifier {
  final FirebasePostService _service = FirebasePostService();
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    _posts = await _service.getAll();
    notifyListeners();
  }

  Future<void> addPost(String title, String content) async {
    await _service.create(Post(id: '', title: title, content: content));
    await fetchPosts();
  }

  Future<void> deletePost(String id) async {
    await _service.delete(id);
    await fetchPosts();
  }

  Future<void> updatePost(String id, String title, String content) async {
    await _service.update(Post(id: id, title: title, content: content));
    await fetchPosts();
  }
}
