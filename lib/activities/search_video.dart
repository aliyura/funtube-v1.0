import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:funtube_v1/activities/preview.dart';
import 'package:http/http.dart' as http;
import 'package:recase/recase.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:funtube_v1/config.dart';

class SearchVideo extends StatefulWidget {

  final search;
  SearchVideo({this.search});

  @override
  _State createState() => _State();
}

class _State extends State<SearchVideo> {

  dynamic nextPageToken='';
  bool isLoading = true;
  bool isFailure = true;

  String uri='';
  String title='';
  List<dynamic> _dump; 
  ScrollController _scrollController;
  Widget appBarTitle;
  Icon actionIcon;
  ReCase rc;
  



  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
  
      rc= ReCase(widget.search);
      title=rc.titleCase;

     appBarTitle= Text(title);
     actionIcon=Icon(
        Icons.search,
        color: Colors.white,
      );
   
   _dump=new List();
   _scrollController =new ScrollController();
   _fetchVideos();

   super.initState();
  }

  Future _fetchVideos() async {

    var client = new http.Client();
    try {
      // get starting videos
      dynamic question=widget.search;
      uri='$YOUTUBE_DATA_URL/search?q=$question&type=video&maxResults=50&part=snippet,id&key=$DEVELOPER_KEY';
 
      var response = await client.get(Uri.encodeFull(uri));
      if (response.statusCode == 200) {
       
        setState(() {
          dynamic data =jsonDecode(response.body)['items'];
          nextPageToken = jsonDecode(response.body)['nextPageToken'];
          _dump=data;
    
          isFailure = false;
          isLoading = false;
        });
      }
      client.close();
    }
     catch (ex) {
      setState(() {
         isFailure = true;
         isLoading = false;
      });
        throw Exception(ex); 
    }
    
  }
  
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
                  this.appBarTitle = Text(title);
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        child: isLoading ? Center(child: SpinKitRing(
          color: Colors.amber,
          size: 40.0,
        )):
         isFailure ? Center(
            child: Padding(
            padding: EdgeInsets.only(top:50),
          child:
            Column(
             children: <Widget>[
               Icon(Icons.warning,color: Colors.amber,size: 50),
               Text(FAILURE),
             ],
        ))):
         ListView.builder(
           controller: _scrollController,
            itemCount: _dump.length,
            itemBuilder: (context, index) => video(context,_dump[index])),
      ),
    );
  }
}

Widget video(BuildContext context, video) {

  var title = video['snippet']['title'],
      videoId=video['id']['videoId'],
      description = video['snippet']['description'],
      channelId = video['snippet']['channelId'],
      thumbnail = video['snippet']['thumbnails']['medium']['url'],
      date = video['snippet']['publishedAt'];

      var timeAgo = DateTime.parse(date);
      date=timeago.format(timeAgo);


  return GestureDetector(
    onTap: (){
       Navigator.push(context,MaterialPageRoute(
          builder: (context)=>Preview(isChannelId:true,channel:channelId,title: title,thumbnail: thumbnail,description: description,videoId:videoId)
       ));
    },
    child:  Card(
      color: Colors.white,
      margin: EdgeInsets.all(10.0),
      borderOnForeground: true,
      child: Row(
        children: <Widget>[
          Expanded(
            child:
            Container(
              width:  MediaQuery.of(context).size.height / 2.2,
              padding: const EdgeInsets.all(8.0),
              height: 100,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: new Image.network(
                      thumbnail,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Center(
                    child: Icon(Icons.play_circle_outline,color: Colors.amber,size: 40.0,),
                  ),
                  
                ],
              ),
            )
          ),
          Expanded(
            child:
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(date,style: TextStyle(color: Colors.black.withOpacity(0.5))), 
                    ),
                    Container(
                      width: MediaQuery.of(context).size.height / 2.2,
                      height: 70,
                      child: Row(
                      children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                title,
                                style: TextStyle(
                                    inherit: true,
                                    fontSize: 14.0,
                                    color: Colors.black),
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      )),
                    
                  ],
                ),
              ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start
      ),
    ),
  );
}