import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:funtube_v1/activities/search_video.dart';
import 'package:recase/recase.dart';
import 'dart:convert';
import 'package:funtube_v1/activities/video_list.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:funtube_v1/config.dart';

class ChannelList extends StatefulWidget {
  @override
  _ChannelListState createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  bool isLoading=true;
  dynamic dump = [];

  @override
  void initState() {
    super.initState();
    fetchChannels();
  }

  Future fetchChannels() async {
    var client = new http.Client();

    try {

      String availableChannels='$INITIALCHANNEL';
      CHANNELS.map((channel) {
        availableChannels=availableChannels+',$channel';
      }).toList();
      
      String uri='$YOUTUBE_DATA_URL/channels/?part=snippet,contentDetails,statistics&id=$availableChannels&key=$DEVELOPER_KEY';
      var response = await client.get(Uri.encodeFull(uri));
      if (response.statusCode == 200) {
        setState(() {
          dump = jsonDecode(response.body)['items'];
        });
      } else {
        dump = [];
      }
    } 
    catch (ex) {
      dump = [];
    }
    finally{
        isLoading=false; 
        client.close();
    }
  }

  
  Widget appBarTitle = new Text("Channels");
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.amber,
        title:appBarTitle,
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
                  this.appBarTitle = Text("Channels");
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
           GridView.builder(
              itemCount: dump.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, int index) =>
                  _renderChannels(context, dump[index]))),
    );
  }
}

Widget _renderChannels(BuildContext context, channel) {
  var id = channel['id'],
      title = channel['snippet']['title'],
      thumbnails = channel['snippet']['thumbnails']['medium']['url'],
      publishedAt = channel['snippet']['publishedAt'];

  var timeAgo = DateTime.parse(publishedAt);
  publishedAt = timeago.format(timeAgo);

  thumbnails = Uri.encodeFull(thumbnails);
  ReCase rc = new ReCase(title);
  title = rc.titleCase;

  return Padding(
    padding: EdgeInsets.all(10.0),
    child: Channel(
        id: id,
        title: title,
        publishedAt: publishedAt,
        thumbnails: thumbnails,
        channel: channel),
  );
}

class Channel extends StatelessWidget {
  final title;
  final thumbnails;
  final description;
  final channel;
  final publishedAt;
  final id;

  Channel(
      {this.id,
      this.title,
      this.thumbnails,
      this.publishedAt,
      this.description,
      this.channel});

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(
          builder: (context)=>VideoList(id:id,title: title,channel: channel)
        ));
      },
      child:
    Container(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Stack(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Center(
                        child: new Image.network(
                          thumbnails,
                          height: 150.0,
                          width: 160.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: 160.0,
                    height: 50.0,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black, Colors.black12])),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                        Row(
                          children: <Widget>[
                            Text(publishedAt,
                                style: TextStyle(
                                    fontSize: 9.0, color: Colors.grey[300])),
                            SizedBox(width: 30.0),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  color: Colors.white.withOpacity(0.95),
                                ),
                                child: Text(
                                  "Sponsured",
                                  style: TextStyle(
                                      fontSize: 8.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}