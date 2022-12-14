// ignore_for_file: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/constants/app_styles.dart';
import 'package:news_app/provider/user_management.dart';
import 'package:news_app/screens/bookmark/bookmark.dart';
import 'package:news_app/screens/home/widget/render_category.dart';
import 'package:news_app/screens/home/widget/render_news.dart';
import 'package:news_app/screens/login/widgets/alertLogin.dart';
import 'package:provider/provider.dart';

import '../../provider/model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentCategory = 0;
  void ChangeCurrentCatagory(index) {
    if (context.read<Model>().category[index] == "All") {
      context.read<Model>().setAllNews();
    } else {
      context
          .read<Model>()
          .getNewsFollowCategory(context.read<Model>().category[index]);
    }
    setState(() {
      currentCategory = index;
    });
  }

  @override
  void initState() {
    super.initState();
    setUpData();
  }

  void setUpData() async {
    context.read<Model>().getCategory();
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<UserManagement>().user.name;
    final login = context.watch<UserManagement>().checkLogin();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.only(left: 24),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Wellcome, ${userName}",
                            style: AppStyles.regular
                                .copyWith(color: Colors.black, fontSize: 16)),
                      ],
                    ))),
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                if (context.read<UserManagement>().loginSuccess){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Bookmark()));
                }else{
                  alertLogin(context);
                }
              },
              color: Colors.blue,
            )
          ],
        ),
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 24,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: context.watch<Model>().category.length,
                    itemBuilder: (context, index) => RenderCateGory(
                        index == currentCategory ? true : false,
                        context.watch<Model>().category[index],
                        index,
                        ChangeCurrentCatagory)),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: context.watch<Model>().newsFollowCategory.length,
                    itemBuilder: (context, index) => RenderNews(
                        context.watch<Model>().newsFollowCategory[index],
                        context)),
              ),
            ],
          )),
    );
  }
}
