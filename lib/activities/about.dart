import 'package:flutter/material.dart';
import 'package:funtube_v1/activities/search_video.dart';
import 'package:share/share.dart';
import 'package:funtube_v1/config.dart';
class About extends StatefulWidget {

  @override
  _State createState() => _State();
}

class _State extends State<About> {

  Widget appBarTitle = new Text("About");
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
                  this.appBarTitle = Text("About");
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
              Padding(
                padding: EdgeInsets.all(10),
                child:
               Image.asset('assets/icon/launcher.png',width: 100, height:100,)
              ),
              Text('FunTube V1.0', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  
              ),),
               Padding(
                padding: EdgeInsets.only(
                  top:10, right: 40,left: 40
                  ),
                child: Text('info@funtube.com'),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top:40, right: 60,left: 60
                  ),
                child: Text('There are more than 50 popular comedy channels with about more than 10k videos each channel. We are here to crack your ribs with daily hilarious jokes from diffrent comedians world wide.'),
              ),
             
            ],
          ),
        ),
       ),
    );   
  }
}
