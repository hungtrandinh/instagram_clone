import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_blocs.dart';
import 'package:social_app/blocs/comment_blocs/comment_blocs.dart';
import 'package:social_app/blocs/comment_blocs/comment_event.dart';
import 'package:social_app/blocs/comment_blocs/comment_state.dart';
import 'package:social_app/model/post.dart';
import 'package:social_app/repositories/post_reponsitories.dart';
import 'package:social_app/values/app_assets_colors.dart';
import 'package:social_app/values/app_assets_icons.dart';
import 'package:social_app/values/app_textstyle.dart';

class Comments extends StatelessWidget {
  final PostModel list;

  const Comments({Key? key, required this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentBloc>(
        create: (context) {
          return CommentBloc(
              postReponsitoris: context.read<PostReponsitoris>(),
              appBloc: context.read<AppBloc>())
            ..add(FetchCommentEvent(postModel: list));
        },
        child: SatateComments());
  }
}

class SatateComments extends StatefulWidget {
  @override
  State<SatateComments> createState() => _SatateCommentsState();
}

class _SatateCommentsState extends State<SatateComments> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state.statusCommemt == StatusCommemt.error) {}
      },
      builder: (context, state) {
        return MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorConstants.backgroucolor,
            appBar: AppBar(
              backgroundColor: ColorConstants.backgroucolor,
              title: const Text(
                'Comments',
                style: AppTextStyle.LoginStyle2,
              ),
              centerTitle: true,
            ),
            bottomSheet: Container(
              color: Color(0xff20242F),
              height: 80,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (state.statusCommemt == StatusCommemt.submitting)
                      const LinearProgressIndicator(),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled:
                                state.statusCommemt != StatusCommemt.submitting,
                            style: TextStyle(color: Colors.white),
                            controller: _commentController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration.collapsed(
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: "Write a comment ...."),
                          ),
                        ),
                        IconButton(
                          onPressed: state.statusCommemt ==
                                  StatusCommemt.submitting
                              ? null
                              : () {
                                  final commentText =
                                      _commentController.text.trim();

                                  context.read<CommentBloc>().add(
                                        PostCommentsEvent(content: commentText),
                                      );

                                  _commentController.clear();
                                },
                          icon: Icon(
                            Icons.send,
                            color:
                                state.statusCommemt == StatusCommemt.submitting
                                    ? Colors.grey
                                    : ColorConstants.seencolor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: state.statusCommemt == StatusCommemt.loading
                ? Center(child: const CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 60),
                    itemCount: state.listcomment.length,
                    itemBuilder: (context, index) {
                      final comment = state.listcomment[index];
                      return ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          child: ClipOval(
                            child: state.listcomment[index]!.author
                                        .profilePictureURL !=
                                    null
                                ? CachedNetworkImage(
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fill,
                                    imageUrl: state.listcomment[index]!.author
                                        .profilePictureURL!)
                                : SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(AppIcon.avata,
                                        fit: BoxFit.fill)),
                          ),
                          radius: 25,
                        ),
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: comment!.author.name,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffF54B64)),
                              ),
                              const TextSpan(text: " "),
                              TextSpan(
                                  text: comment.content,
                                  style: AppTextStyle.caption),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          DateFormat.yMd()
                              .add_jm()
                              .format(state.listcomment[index]!.dateTime),
                          style: AppTextStyle.datimepost,
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
