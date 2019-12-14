import 'package:flutter/material.dart';
import 'package:funtube_v1/activities/search_video.dart';
import 'package:share/share.dart';
import 'package:funtube_v1/config.dart';
class Settings extends StatefulWidget {

  @override
  _State createState() => _State();
}

class _State extends State<Settings> {

  Widget appBarTitle = new Text("Settings");
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

 void _searchRequest(String request){
   Navigator.push(context,MaterialPageRoute(
     builder: (context)=>SearchVideo(search: request)
   )); 
 }
 void _shareApp(){
        Share.share('Hi Dear, Download funTube v1.0 to enjoy daily hilarious funny videos from diffrent comedians around the world. $PLAYSTORE_LINK');
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              setState(() {
                if(this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    style: new TextStyle(
                      color: Colors.white,                    
                    ),
                    textInputAction: TextInputAction.search,
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "Search Video here...",
                        hintStyle: new TextStyle(color: Colors.white)),
                        onSubmitted: _searchRequest,
                        
                  );
                }else{
                  this.actionIcon = Icon(Icons.search, color: Colors.white);
                  this.appBarTitle = Text("Settings");
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Comming soon...')
            ],
          ),
        ),
       ),
    );   
  }
}
