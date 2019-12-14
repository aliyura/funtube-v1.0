import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:funtube_v1/activities/preview.dart';
import 'package:funtube_v1/config.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class TopVideos extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<TopVideos> {

  dynamic _channelDump = [];
  dynamic nextPageToken = '';
  dynamic payload;
  bool isLoading = true;
  bool isFailure = true;


  String uri = '';
  List<dynamic> _dump; 
  ScrollController _scrollController;

   @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dump=new List();
   _scrollController =new ScrollController();

  _fetchVideos('_INIT');
  _getCurrentChannel();

  _scrollController.addListener((){
     if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        _fetchVideos('_MORE');
     }
   });
  }

  Future _fetchVideos(String key) async {
    try {
      // get starting videos
      uri ='$YOUTUBE_DATA_URL/search?channelId=$INITIALCHANNEL&order=date&part=snippet,id&type=video&maxResults=$MAX&pageToken=$nextPageToken&key=$DEVELOPER_KEY';
      var response = await http.get(Uri.encodeFull(uri));
      if (response.statusCode == 200) {
       
        setState(() {
          dynamic data =jsonDecode(response.body)['items'];
          nextPageToken = jsonDecode(response.body)['nextPageToken'];
          payload=jsonDecode(response.body);
          if(key=='_MORE'){
               for (dynamic each in data){
                 _dump.add(each);
               }
          }
          else{
            _dump=data;
          }
        });
      }
    } catch (ex) {
      setState(() {
         isFailure = true;
         isLoading = false;
      });
       throw Exception(ex); 
    }
  }

  Future _getCurrentChannel() async{
      // get current channel
    try {
     uri ='$YOUTUBE_DATA_URL/channels/?part=snippet,contentDetails,statistics&id=$INITIALCHANNEL&key=$DEVELOPER_KEY';
      var response = await http.get(Uri.encodeFull(uri));
      if (response.statusCode == 200) {
        setState(() {
          setState(() {
            _channelDump=jsonDecode(response.body)['items'];
              isFailure = false;
              isLoading = false;
          });
        });
      }
      
    } catch (ex) {
        throw Exception(ex); 
    }
  }
  @override
  Widget build(BuildContext context) {

   
    double height = MediaQuery.of(context).size.height;
    double compatableHeight=height/2.5;
    
    if(height<=2800){
      compatableHeight=height/2.5;  
    }
    else if(height<800){
      compatableHeight=height/3; 
    }
    else  if(height<432){
      compatableHeight=height/3.5; 
    }

    return Container(
      height:compatableHeight,
      padding: EdgeInsets.all(1.0),
      child:
         isLoading ? Center(child: SpinKitRing(
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
          itemBuilder: (context, index) => video(context, _dump[index],_channelDump[0])),
    );
  }
}

Widget video(BuildContext context, video, channel) {


   dynamic videoObject=video,
      title = videoObject['snippet']['title'],
      videoId = videoObject['id']['videoId'],
      description = videoObject['snippet']['description'],
      thumbnail = videoObject['snippet']['thumbnails']['medium']['url'],
      date = videoObject['snippet']['publishedAt'];

      var timeAgo = DateTime.parse(date);
      date = timeago.format(timeAgo);

  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Preview(
                  channel: channel,
                  title: title,
                  thumbnail: thumbnail,
                  description: description,
                  videoId: videoId)));
    },
    child: Card(
      color: Colors.white,
      margin: EdgeInsets.all(10.0),
      borderOnForeground: true,
      child: Row(children: <Widget>[
        Expanded(
            child: Container(
          width: MediaQuery.of(context).size.height / 2.2,
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
                child: Icon(
                  Icons.play_circle_outline,
                  color: Colors.amber,
                  size: 40.0,
                ),
              ),
            ],
          ),
        )),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(date,
                      style: TextStyle(color: Colors.black.withOpacity(0.5))),
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
      ], crossAxisAlignment: CrossAxisAlignment.start),
    ),
  );
}

// class Video extends StatelessWidget {
//   final title;
//   final picture;
//   final description;

//   Video({
//     this.title,
//     this.picture,
//     this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 150,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           children: <Widget>[
//             ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(10.0)),
//               child: Stack(
//                 children: <Widget>[
//                    Stack(
//                     children: <Widget>[
//                       Center(
//                         child: new Image.asset(
//                           picture,
//                            height: 150.0,
//                            width: 160.0,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                       Center(
//                         child: Padding(
//                           padding: EdgeInsets.only(top:40.0),
//                           child:
//                           Icon(
//                              Icons.play_circle_outline,
//                               color: Colors.amber,
//                               size: 40.0,),
//                           ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     left: 0.0,
//                     bottom: 0.0,
//                     width: 160.0,
//                     height: 50.0,
//                     child: Container(
//                       decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                               begin: Alignment.bottomCenter,
//                               end: Alignment.topCenter,
//                               colors: [Colors.black, Colors.black12])),
//                     ),
//                   ),
//                   Positioned(
//                     left: 10.0,
//                     bottom: 10.0,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'name',
//                           style: TextStyle(
//                               fontSize: 18.0, fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                           children: <Widget>[
//                             Text('12 days ago',
//                                 style: TextStyle(
//                                     fontSize: 14.0, color: Colors.grey[300])),
//                             SizedBox(width: 30.0),
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 4.0, horizontal: 8.0),
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20.0)),
//                                 color: Colors.white.withOpacity(0.95),
//                               ),
//                               child: Text(
//                                 "Sponsured",
//                                 style: TextStyle(
//                                     fontSize: 8.0,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
