import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbanlink_project/components/menu_drawer_widget.dart';
import 'package:urbanlink_project/components/post_list_component.dart';
import 'package:urbanlink_project/models/user.dart';
import 'package:urbanlink_project/repositories/post_database_service.dart';
import 'package:urbanlink_project/repositories/user_database_service.dart';
import 'package:urbanlink_project/services/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  MyUser? _myUser;
  Future<void> _setUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        _myUser = await UserDatabaseService.getUserById(
          currentUser.uid,
        );
      } on Exception catch (e) {
        logger.e(e);
      } catch (e) {
        logger.e(e);
      }
    }
  }

  Container profileBox(
      TextStyle textProfileUserStyle, TextStyle textProfileDescriptionStyle) {
    const double profileHeight = 200;
    const double profileRound = 40;
    return Container(
        height: profileHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(profileRound),
            topRight: Radius.circular(profileRound),
            bottomLeft: Radius.circular(profileRound),
            bottomRight: Radius.circular(profileRound),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircleAvatar(
                  minRadius: 60.0,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        AssetImage('assets/images/profileImage.jpeg'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(_myUser?.userName ?? 'Unknown',
                          style: textProfileUserStyle),
                      Text(_myUser?.userExplanation ?? '',
                          style: textProfileDescriptionStyle),
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    const textProfileUserStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    var textProfileDescriptionStyle = const TextStyle(fontSize: 20);
    final postListComponent = PostListComponent();
    return FutureBuilder<void>(
      future: _setUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            endDrawer: MenuDrawer(
              myUser: _myUser,
            ),
            body: Column(
              children: <Widget>[
                profileBox(textProfileUserStyle, textProfileDescriptionStyle),
                const Text('Post List', style: textProfileUserStyle),
                Expanded(
                  child: postListComponent.postStreamBuilder(
                    PostDatabaseService.getPostsByUserId(
                        _myUser?.userId ?? 'Unknown'),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
