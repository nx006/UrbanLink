import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urbanlink_project/models/posts.dart';
import 'package:urbanlink_project/services/auth.dart';

class PostDatabaseService {
  static final CollectionReference _postsCollection =
      FirebaseFirestore.instance.collection('posts');

  static Future<Post> createPost({
    required String postTitle,
    required String postContent,
    required String postAuthorId,
    required String communityId,
    required DateTime postCreatedTime,
    required DateTime postLastModified,
    required String locationId,
    required String authorName,
  }) async {
    final docPost = _postsCollection.doc();

    final json = {
      'postId': docPost.id,
      'postTitle': postTitle,
      'postContent': postContent,
      'postAuthorId': postAuthorId,
      'communityId': communityId,
      'postCreatedTime': postCreatedTime.toString(),
      'postLastModified': postLastModified.toString(),
      'locationId': locationId,
      'authorName': authorName,
      'postLikeCount': 0,
      'postDislikeCount': 0,
    };

    // create document and write data to Firebase
    await docPost.set(json);
    await docPost.collection('comments').doc().set({});

    // return Post object with generated postId
    return Post(
      postId: docPost.id,
      postTitle: postTitle,
      postContent: postContent,
      postAuthorId: postAuthorId,
      communityId: communityId,
      postCreatedTime: postCreatedTime,
      postLastModified: postLastModified,
      locationId: locationId,
      authorName: authorName,
    );
  }

  static Stream<List<Post>> getPosts() {
    try {
      return _postsCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => Post.fromSnapshot(doc))
            .toList(growable: false);
      });
    } catch (e) {
      logger.e('Error: $e');
      return const Stream.empty();
    }
  }

  static Stream<List<Post>> getPostsByCommunityId(String communityId) {
    try {
      return _postsCollection
          .where('communityId', isEqualTo: communityId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Post.fromSnapshot(doc))
            .toList(growable: false);
      });
    } catch (e) {
      logger.e('Error: $e');
      return const Stream.empty();
    }
  }

  static Stream<List<Post>> getPostsByUserId(String userId) {
    try {
      return _postsCollection
          .where('postAuthorId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Post.fromSnapshot(doc))
            .toList(growable: false);
      });
    } catch (e) {
      logger.e('Error: $e');
      return const Stream.empty();
    }
  }

  static Stream<List<Post>> getPostsByPostId(String postId) {
    try {
      return _postsCollection
          .where('postId', isEqualTo: postId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Post.fromSnapshot(doc))
            .toList(growable: false);
      });
    } catch (e) {
      logger.e('Error: $e');
      return const Stream.empty();
    }
  }

  static Stream<List<Post>> getPostsByPostTitle(String postTitle) {
    try {
      return _postsCollection
          .where('postTitle', isEqualTo: postTitle)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Post.fromSnapshot(doc))
            .toList(growable: false);
      });
    } catch (e) {
      logger.e('Error: $e');
      return const Stream.empty();
    }
  }

  static Future<void> updatePost(
      {required String postId,
      required String field,
      required dynamic value}) async {
    if (field == 'postAuthorId' || field == 'postId') {
      logger.e('Cannot update postAuthorId or postId');
      return;
    }
    final docPost = _postsCollection.doc(postId);
    final postModifiedTime = DateTime.now();

    final json = {
      'postId': docPost.id,
      field: value,
      'postLastModified': postModifiedTime.toString(),
    };

    // create document and write data to Firebase
    await docPost.update(json).then((value) => logger.i('Post updated'),
        onError: (error) => logger.e('Failed to update post: $error'));
  }

  static Future<void> updatePostContent(
      {required String postId, required String postContent}) async {
    final docPost = _postsCollection.doc(postId);
    final postModifiedTime = DateTime.now();

    final json = {
      'postId': docPost.id,
      'postContent': postContent,
      'postLastModified': postModifiedTime.toString(),
    };

    // create document and write data to Firebase
    await docPost.update(json).then((value) => logger.i('Post Content updated'),
        onError: (error) => logger.e('Failed to update post: $error'));
  }

  static Future<void> updatePostTitle(
      {required String postId, required String postTitle}) async {
    final docPost = _postsCollection.doc(postId);
    final postModifiedTime = DateTime.now();

    final json = {
      'postId': docPost.id,
      'postTitle': postTitle,
      'postLastModified': postModifiedTime.toString(),
    };

    // create document and write data to Firebase
    await docPost.update(json).then((value) => logger.i('Post Title updated'),
        onError: (error) => logger.e('Failed to update post: $error'));
  }

  static Future<void> updatePostLocationId(
      {required String postId, required String locationId}) async {
    final docPost = _postsCollection.doc(postId);
    final postModifiedTime = DateTime.now();

    final json = {
      'postId': docPost.id,
      'locationId': locationId,
      'postLastModified': postModifiedTime.toString(),
    };

    // create document and write data to Firebase
    await docPost.update(json).then(
        (value) => logger.i('Post Location updated'),
        onError: (error) => logger.e('Failed to update post: $error'));
  }

  static Future<void> updatePostLikeCount(
      {required String postId, required int postLikeCount}) async {
    final docPost = _postsCollection.doc(postId);

    final json = {
      'postId': docPost.id,
      'postLikeCount': postLikeCount,
    };

    // create document and write data to Firebase
    await docPost.update(json).then(
        (value) => logger.i('Post Like Count updated'),
        onError: (error) => logger.e('Failed to update post: $error'));
  }

  static Future<void> updatePostDislikeCount(
      {required String postId, required int postDislikeCount}) async {
    final docPost = _postsCollection.doc(postId);

    final json = {
      'postId': docPost.id,
      'postDislikeCount': postDislikeCount,
    };

    // create document and write data to Firebase
    await docPost.update(json).then(
        (value) => logger.i('Post Dislike Count updated'),
        onError: (error) => logger.e('Failed to update post: $error'));
  }

  static Future<void> deletePost({required String postId}) async {
    try {
      await _postsCollection
          .doc(postId)
          .collection('comments')
          .get()
          .then((value) {
        for (final doc in value.docs) {
          doc.reference.delete();
        }
      });
      await _postsCollection.doc(postId).delete();
    } catch (e) {
      logger.e('Error: $e');
    }
  }
}