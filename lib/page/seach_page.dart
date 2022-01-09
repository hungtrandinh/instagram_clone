import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/seach_cubit/seach_cubit.dart';
import 'package:social_app/blocs/seach_cubit/seach_state.dart';
import 'package:social_app/model/user.dart';
import 'package:social_app/page/photoAPI.dart';
import 'package:social_app/page/profile.dart';
import 'package:social_app/repositories/profile_reponsitories.dart';
import 'package:social_app/values/app_assets_colors.dart';
import 'package:social_app/widgets/profile/userProfileImage.dart';
import 'package:social_app/widgets/seach_user.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.backgroucolor,
        appBar: AppBar(
          backgroundColor: ColorConstants.backgroucolor,
          title: Center(
            child: SizedBox(
              height: 50,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search User',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        context.read<SearchCubit>().clearSeach();
                        _searchController.clear();
                      },
                      icon: const Icon(Icons.clear)),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.search,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {
                  context.read<SearchCubit>().getUserSeach(name: value);
                },
              ),
            ),
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, searchState) {
            return searchState.status == SearchStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : searchState.userList.isNotEmpty
                    ? Column(
                        children: [
                          Container(
                            height: 300,
                            child: ListView.builder(
                              itemCount: searchState.userList.length,
                              itemBuilder: (context, index) {
                                final user = searchState.userList[index];
                                return ListTile(
                                    leading: UserProfileImage(
                                      radius: 22,
                                      imageUrl: user.profilePictureURL ?? 'xxx',
                                      size: 50,
                                      name: "hùng",
                                    ),
                                    title: Text(user.name!,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Profile(uid: user.id!)));
                                    });
                              },
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: _buildShowFirebaseUsers(),
                          ),
                        ],
                      );
          },
        ),
      ),
    );
  }

  Widget _buildShowFirebaseUsers() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      // color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Danh Sách Gợi Ý',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => GetImageApi()));
                },
                child: Text(
                  'See All',
                  style: const TextStyle(fontSize: 15, color: Colors.blue),
                ),
              )
            ],
          ),
          StreamBuilder<List<MyUser>>(
              stream: SettingProvider().getAllFirebaseUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userList = snapshot.data;
                  return Container(
                    height: 160,
                    child: ListView.builder(
                      padding: EdgeInsets.only(right: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: userList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final user = userList[index];
                        return SuggestionTile(user: user);
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}

class CenteredText extends StatelessWidget {
  final String text;

  CenteredText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
