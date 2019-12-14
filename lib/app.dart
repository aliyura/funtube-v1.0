import 'package:flutter/material.dart';
import 'package:funtube_v1/activities/about.dart';
import 'package:funtube_v1/activities/channel_list.dart';
import 'package:funtube_v1/activities/search_video.dart';
import 'package:funtube_v1/activities/settings.dart';
import 'package:funtube_v1/components/category.dart';
import 'package:funtube_v1/components/slider.dart';
import 'package:funtube_v1/components/top_videos.dart';
import 'package:share/share.dart';
import 'config.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}
class _MainState extends State<Main> {
  Widget appBarTitle = new Text("funTube");
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  void _searchRequest(String request) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchVideo(search: request)));
  }

  void _shareApp(){
        Share.share('Hi Dear, Download funTube v1.0 to enjoy daily hilarious funny videos from diffrent comedians around the world. $PLAYSTORE_LINK');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.amber,
          title: appBarTitle,
          actions: <Widget>[
             IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {
                _shareApp();
              },
            ),
            IconButton(
              icon: actionIcon,
              onPressed: () {
                if (mounted) {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = new Icon(Icons.close);
                      this.appBarTitle = new TextField(
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                        textInputAction: TextInputAction.search,
                        decoration: new InputDecoration(
                            prefixIcon:
                                new Icon(Icons.search, color: Colors.white),
                            hintText: "Search Video here...",
                            hintStyle: new TextStyle(color: Colors.white)),
                        onSubmitted: _searchRequest,
                      );
                    } else {
                      this.actionIcon = Icon(Icons.search, color: Colors.white);
                      this.appBarTitle = Text("funTube");
                    }
                  });
                }
              },
            ),
           
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: UserAccountsDrawerHeader(
                  accountName: Text('funTube V1.0'),
                  accountEmail: Text('info@funtube.com'),
                  currentAccountPicture: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(color: Colors.amber),
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Text('Home'),
                    leading: Icon(Icons.home),
                  )),
              // InkWell(
              //     onTap: () {},
              //     child: ListTile(
              //       title: Text('My Account'),
              //       leading: Icon(Icons.person),
              //     )),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                  child: ListTile(
                    title: Text('Settings'),
                    leading: Icon(Icons.settings),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => About()));
                  },
                  child: ListTile(
                    title: Text('About'),
                    leading: Icon(Icons.help),
                  )),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
            SliderCarousel(),
            Container(
              color: Colors.amber,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text('Top Channels',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.white))),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChannelList()));
                          },
                          child: Text('View All',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white70,
              child: CategoryList(),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text('Top Videos',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
            ),
            Container(
              child: TopVideos(),
            ),
          ],
        ),
    );
  }
}
