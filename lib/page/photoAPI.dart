import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/api_image_blocs/api_image_bloc.dart';
import 'package:social_app/blocs/api_image_blocs/api_image_state.dart';
import 'package:social_app/page/seach_page.dart';
import 'package:social_app/values/app_assets_colors.dart';
import 'package:social_app/widgets/photoview/photoview.dart';

class GetImageApi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorConstants.backgroucolor,
          appBar: AppBar(
            backgroundColor: ColorConstants.backgroucolor,
            elevation: 0,
            title: SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: "Seach Users",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Center(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: nameButton.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white),
                                  onPressed: () {
                                    context.read<CubitImage>().seachImage(
                                        query: "${nameButton[index]}");
                                  },
                                  child: Text("${nameButton[index]}",
                                      style: TextStyle(
                                          color: ColorConstants.buttoncolor))),
                            );
                          }),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: BlocBuilder<CubitImage, StateImage>(
                      builder: (context, state) {
                    return state.statusApp == ImageStatusApp.intisial
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            padding: EdgeInsets.all(10),
                            itemCount: state.raw!.imageApi.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PhotoviewMy(
                                                url: state.raw!.imageApi[index]
                                                    .urls.row)));
                                  },
                                  child: Stack(children: [
                                    CachedNetworkImage(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        imageUrl:
                                            state.raw!.imageApi[index].urls.row,
                                        fit: BoxFit.fill),
                                    Positioned(
                                        top: 10,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.transparent),
                                          child: Icon(Icons.download),
                                          onPressed: () async {
                                            await context
                                                .read<CubitImage>()
                                                .dowloadImage(
                                                    url: state
                                                        .raw!
                                                        .imageApi[index]
                                                        .urls
                                                        .row);
                                            BotToast.showNotification(
                                                leading: (cancel) =>
                                                    SizedBox.fromSize(
                                                        size:
                                                            const Size(40, 40),
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.download,
                                                              color: Colors
                                                                  .redAccent),
                                                          onPressed: cancel,
                                                        )),
                                                title: (_) => Text(
                                                    'Dowload Thành Công !'),
                                                trailing: (cancel) =>
                                                    IconButton(
                                                      icon: Icon(Icons.cancel),
                                                      onPressed: cancel,
                                                    ));
                                          },
                                        )),
                                  ]),
                                ),
                              );
                            });
                  }),
                ),
              ],
            ),
          )),
    );
  }
}

const List<String> nameButton = [
  "London",
  "VietNam",
  "DuBai",
  "Singapo",
  "China",
  "Japan",
  "Koreo",
  "architecture",
  "miss",
  "League of Legends",
  "hawai",
];
