import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/post.dart';

class FirebasePostService {
  final CollectionReference _postCollection = FirebaseFirestore.instance
      .collection('posts');

  Future<List<Post>> getAll() async {
    final snapshot =
        await _postCollection.orderBy('created_at', descending: true).get();
    return snapshot.docs
        .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> create(Post post) async {
    await _postCollection.add({
      'title': post.title,
      'content': post.content,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String id) async {
    await _postCollection.doc(id).delete();
  }

  Future<void> update(Post post) async {
    await _postCollection.doc(post.id).update({
      'title': post.title,
      'content': post.content,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
