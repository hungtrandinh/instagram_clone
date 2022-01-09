const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const userFollowersDocPath = "/followers/{userId}/userFollowers/{followerId}";
// userId is followed id by followerId => increment userId's doc followers key by 1;
// followerId is id who is following userId, i.e app current user  => increment follower's following key by 1;

exports.onFollowUser = functions.firestore
  .document(userFollowersDocPath)
  // this means when documents added in  userFollowers Collection this cloud function will automatically triggered
  .onCreate(async (_, context) => {
    //   we take variable data as {} in url path so we can access them by context.param. as below
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // increment followed user's followers count.
    const followedUserRef = admin.firestore().collection("users").doc(userId);
    const followedUserDoc = await followedUserRef.get();
    const followerCount = followedUserDoc.get("followers");
    if (followerCount !== undefined) {
      followedUserRef.update({ followers: followerCount + 1 });
    } else {
      // if no one is following first time follower come so 1
      followedUserRef.update({ followers: 1 });
    }

    // increment following user's following count. current app user
    const userRef = admin.firestore().collection("users").doc(followerId);
    const userDoc = await userRef.get();
    const followingCount = userDoc.get("following");
    if (followingCount !== undefined) {
      userRef.update({ following: followingCount + 1 });
    } else {
      userRef.update({ following: 1 });
    }

    // Feed logic
    // Add followed user's posts to user's postFeed subCollection of feed collection

    // this is the postRef of user we following
    const followedUserPostsRef = admin
      .firestore()
      .collection("posts")
      // author is collectionRef in firebase firestore
      .where("author", "==", followedUserRef);
    //   this is the userFeef ref of our i.e followers
    const userFeedRef = admin
      .firestore()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed");

    //   this gives all post of user we following i.e List<PostModel>
    const followedUserPostsSnapshots = await followedUserPostsRef.get();

    followedUserPostsSnapshots.forEach((postDoc) => {
      // if following user posts exists we add those post in our userFeedRefCollection with post id
      if (postDoc.exists) {
        userFeedRef.doc(postDoc.id).set(postDoc.data());
      }
    });
  });

//   we are listening for document to delete and this function fires up. we have creating and deleting functionality on app.

exports.onUnfollowUser = functions.firestore
  .document(userFollowersDocPath)
  .onDelete(async (_, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    //   decrement unfollowed user's followers count
    const followedUserRef = admin.firestore().collection("users").doc(userId);
    const followedUserDoc = await followedUserRef.get();
    const followerCount = followedUserDoc.get("followers");
    if (followerCount !== undefined) {
      followedUserRef.update({
        followers: followerCount - 1,
      });
    } else {
      followedUserRef.update({ followers: 0 });
    }

    //   decrement user's following count
    const userRef = admin.firestore().collection("users").doc(followerId);
    const userDoc = await userRef.get();
    const followingCount = userDoc.get("following");
    if (followerCount !== undefined) {
      userRef.update({ following: followingCount - 1 });
    } else {
      userRef.update({ following: 0 });
    }

    //   remove unfollowed user's all posts from user's postFeed collection
    //   userFeedRef who unfollow other user, i.e auth/current user
    //   followerId is auth/current user who is following other
    //   userId is Id of user who is being followed by auth/current user
    const userFeedRef = admin
      .firestore()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed")
      .where("author", "==", followedUserRef);

    //   all post of unfollowed user
    const userPostSnapshot = await userFeedRef.get();

    userPostSnapshot.forEach((postDoc) => {
      if (postDoc.exists) {
        postDoc.ref.delete();
      }
    });
  });

// for new post and adding those post to all user's usersFeed who follow that author

const postDocumentPath = "/posts/{postId}";
exports.onCreatePost = functions.firestore
  .document(postDocumentPath)
  // snapshots are the documents of post collection
  .onCreate(async (snapshot, context) => {
    // getting post id which is auto generated when creating post
    const postId = context.params.postId;
    // getting author id - (we have author filed of collection Refrence type in post field)
    const authorRef = snapshot.get("author");
    // we have author id as : users/authorId in author field of post collection doc
    const authorId = authorRef.path.split("/")[1];

    // add newly created post of author to feeds collection of all followers
    const userFollowerRef = admin
      .firestore()
      .collection("followers")
      .doc(authorId)
      .collection("userFollowers");

    // list of all followers of author
    const userFollowerSnapshot = await userFollowerRef.get();

    userFollowerSnapshot.forEach((followerDoc) => {
      if (followerDoc.exists) {
        // this copied new posts to followers userFeed collection
        //snapshot.data() contain data of posts collection with post id which author create
        admin
          .firestore()
          .collection("feeds")
          .doc(followerDoc.id)
          .collection("userFeed")
          .doc(postId)
          .set(snapshot.data());
      }
    });
  });

// for updating the post in userFeed of all followers when post update i.e like count increment or decrement
exports.onUpdatePost = functions.firestore
  .document(postDocumentPath)
  .onUpdate(async (snapshot, context) => {
    const postId = context.params.postId;

    // getting author id
    const authorRef = snapshot.after.get("author");
    const authorId = authorRef.path.split("/")[1];

    // update post data in each follower's feeds

    const userFollowerRef = admin
      .firestore()
      .collection("followers")
      .doc(authorId)
      .collection("userFollowers");

    const userFollowerSnapshot = await userFollowerRef.get();

    // updated data snapshot of post
    const updatedPostData = snapshot.after.data();

    userFollowerSnapshot.forEach(async (followerDoc) => {
      if (followerDoc.exists) {
        const postRef = admin
          .firestore()
          .collection("feeds")
          .doc(followerDoc.id)
          .collection("userFeed");

        const postDoc = await postRef.doc(postId).get();
        if (postDoc.exists) {
          postDoc.ref.update(updatedPostData);
        }
      }
    });
  });
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
