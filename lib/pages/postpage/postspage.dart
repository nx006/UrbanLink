import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanlink_project/models/posts.dart';
import 'package:urbanlink_project/pages/postpage/postedpage.dart';
import 'package:urbanlink_project/pages/postpage/postingpage.dart';
import 'package:urbanlink_project/repositories/post_database_service.dart';
import 'package:urbanlink_project/services/auth.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildPost(Post post) {
    return ListTile(
      title: Text(post.postTitle),
      subtitle: Text(post.postContent),
      onTap: () {
        Get.to(() => const PostedPage(), arguments: post);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: StreamBuilder<List<Post>>(
        stream: PostDatabaseService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            logger.e(snapshot.error ?? 'Unknown error');
            return Center(
              child: Text('Error: ${snapshot.error ?? 'Unknown error'}'),
            );
          } else if (snapshot.hasData) {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return buildPost(posts[index]);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNavigation(context);
        },
        child: const Icon(Icons.post_add),
      ),
    );
  }

  void _addNavigation(BuildContext context) async {
    final result = await Get.to(
      () => const PostingPage(),
      arguments: '글쓰기',
    );
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$result'),
        ),
      );
    }
  }
}