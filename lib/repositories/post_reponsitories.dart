import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app/model/comment.dart';
import 'package:social_app/model/nofiticol.dart';
import 'package:social_app/model/post.dart';
import 'package:social_app/model/user.dart';
import 'package:social_app/values/positisionname.dart';
import 'package:uuid/uuid.dart';

class PostReponsitoris {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  PostReponsitoris(
      {FirebaseStorage? firebaseStorage, FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  void createPost({required PostModel postModel, required String id}) async {
    final uploadPost = await _firebaseFirestore
        .collection("posts")
        .add(postModel.toDocuments());
  }

  Future deletePost({required String equa}) async {
    final query = await _firebaseFirestore
        .collection("posts")
        .where("imageUrl", isEqualTo: "${equa}")
        .get();

    _firebaseFirestore.collection("posts").doc(query.docs.first.id).delete();
  }

  Future<void> createComent(
      {required PostModel postModel,
      required CommentModel commentModel}) async {
    final commentCollection = FirebaseConstants.comments;
    final postCommentCollection = FirebaseConstants.postComments;
    final comentresul = _firebaseFirestore
        .collection(commentCollection)
        .doc(postModel.id)
        .collection(postCommentCollection)
        .add(commentModel.toDocuments());

    if (postModel.author.id != commentModel.author.id) {
      final notification = NotificationModel(
        id: commentModel.id,
        notificationType: NotificationType.comment,
        fromUser: commentModel.author,
        postModel: postModel,
        dateTime: DateTime.now(),
      );

      //  adding in firebase firestore notifications collection
      //  whose post is this and we put their uid in notifications collection
      final notificationsCol = FirebaseConstants.notifications;
      final userNotificationsCol = FirebaseConstants.userNotifications;
      _firebaseFirestore
          .collection(notificationsCol)
          .doc(postModel.author.id)
          .collection(userNotificationsCol)
          .add(
            notification.toDocument(),
          );
    }
  }

  Stream<List<Future<PostModel?>>> getPostAll({required String id}) {
    final authorRef = _firebaseFirestore.collection('users').doc(id);
    print(authorRef);
    return _firebaseFirestore
        .collection('posts')
        .where('author', isEqualTo: authorRef)
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map((querySnap) => querySnap.docs
            .map(
              (queryDocSnap) => PostModel.fromDocument(queryDocSnap),
            )
            .toList());
  }

  Stream<List<Future<CommentModel?>>> getCommentPost({required String id}) {
    final commentCollection = FirebaseConstants.comments;
    final postCommentsSubCollection = FirebaseConstants.postComments;

    return _firebaseFirestore
        .collection(commentCollection)
        .doc(id)
        .collection(postCommentsSubCollection)
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map(
          (querySnap) => querySnap.docs
              .map(
                (queryDoc) => CommentModel.fromDocument(
                  queryDoc,
                ),
              )
              .toList(),
        );
  }

  Future<List<PostModel?>?> getUserFeed(
      {required String userId, String? lastPostId}) async {
    final feeds = FirebaseConstants.feeds;
    final userFeed = FirebaseConstants.userFeed;
    //paginating logic
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(feeds)
          .doc(userId)
          .collection(userFeed)
          .orderBy("dateTime", descending: true)
          .limit(100)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(feeds)
          .doc(userId)
          .collection(userFeed)
          .doc(lastPostId)
          .get();
      if (!lastPostDoc.exists) {
        return [];
      }
      postsSnap = await _firebaseFirestore
          .collection(feeds)
          .doc(userId)
          .collection(userFeed)
          .orderBy("dateTime", descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(100)
          .get();
    }

    final futurePostList = Future.wait(
        postsSnap.docs.map((post) => PostModel.fromDocument(post)).toList());
    return futurePostList;
  }

  Future<String> _uploadImageAndReturnURl(
      {required File image, required String ref}) async {
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  Future<String> uploadPostImageAndGiveUrl({required File image}) async {
    final imageId = Uuid().v4();
    final ref = 'images/posts/post_$imageId.jpg';
    final downloadUrl = await _uploadImageAndReturnURl(image: image, ref: ref);
    return downloadUrl;
  }

  UploadTask uploadFile(File image, String fileName) {
    final imageId = Uuid().v4();
    Reference reference =
        _firebaseStorage.ref("image/post/${imageId}").child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  @override
  void createLike(
      {required PostModel postModel, required String userId}) async {
    final likes = FirebaseConstants.likes;
    final postLikes = FirebaseConstants.postLikes;
    final posts = FirebaseConstants.posts;
    //  updating the post doc with likes
    //we use here field value because if we use ("likes" : postModel.likes +1 ) it cannot handle concurrent like case
    _firebaseFirestore
        .collection(posts)
        .doc(postModel.id)
        .update({"likes": FieldValue.increment(1)});
    //keeping the userId in postLikes Sub collection of like collection with post id
    _firebaseFirestore
        .collection(likes)
        .doc(postModel.id)
        .collection(postLikes)
        .doc(userId)
        .set({});

    if (postModel.author.id != userId) {
      final notification = NotificationModel(
        notificationType: NotificationType.like,
        fromUser: MyUser.empty.copyWith(id: userId),
        postModel: postModel,
        dateTime: DateTime.now(),
        id: postModel.id,
      );

      //  adding in firebase firestore notifications collection
      //  whose post is this and we put their uid in notifications collection
      final notificationsCol = FirebaseConstants.notifications;
      final userNotificationsCol = FirebaseConstants.userNotifications;
      _firebaseFirestore
          .collection(notificationsCol)
          .doc(postModel.author.id)
          .collection(userNotificationsCol)
          .add(
            notification.toDocument(),
          );
    }
  }

  @override
  void deleteLike({required String postId, required String userId}) {
    final likes = FirebaseConstants.likes;
    final postLikes = FirebaseConstants.postLikes;
    final posts = FirebaseConstants.posts;
    //decrementing the likes from post document
    _firebaseFirestore
        .collection(posts)
        .doc(postId)
        .update({"likes": FieldValue.increment(-1)});
    //deleting userId from postLikes collection
    _firebaseFirestore
        .collection(likes)
        .doc(postId)
        .collection(postLikes)
        .doc(userId)
        .delete();
  }

  @override
  Future<Set<String>> getLikedPostIds(
      {required String userId, required List<PostModel?>? postModel}) async {
    //getting all ids of posts which  the user liked
    final likesCollection = FirebaseConstants.likes;
    final postLikesCollection = FirebaseConstants.postLikes;
    final postIds = <String>{};
    for (final post in postModel!) {
      final likedDoc = await _firebaseFirestore
          .collection(likesCollection)
          .doc(post!.id)
          .collection(postLikesCollection)
          .doc(userId)
          .get();
      //getting if userId exists in postLikesCollection if so added that is on postIds SET
      if (likedDoc.exists) {
        postIds.add(post.id!);
      }
    }
    return postIds;
  }
}
