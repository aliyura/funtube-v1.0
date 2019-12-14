import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:funtube_v1/activities/video_list.dart';
import 'package:funtube_v1/config.dart';
import 'package:http/http.dart' as http;
import 'package:recase/recase.dart';

class CategoryList extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CategoryList> {

  dynamic dump=[];
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    _fetchChannels();
  }

  Future _fetchChannels() async{
    try{

     String availableChannels='$INITIALCHANNEL';
     CHANNELS.map((channel) {
       availableChannels=availableChannels+',$channel';
     }).toList();
    
      String uri='$YOUTUBE_DATA_URL/channels/?part=snippet,contentDetails,statistics&id=$availableChannels&key=$DEVELOPER_KEY';
      var response= await http.get(Uri.encodeFull(uri));
      if(response.statusCode==200){
        setState(() {
          dump=jsonDecode(response.body)['items'];
          setState(() {
            isLoading=false; 
          });

        });
      }
    }
    catch(ex){
       throw Exception(ex); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118.0,
      decoration: BoxDecoration(
        border: Border(
         bottom:BorderSide(
           width: 1.0,
           color: Colors.grey
         )
        )
      ),
      child: 
         isLoading ? Center(child: SpinKitWave(
          color: Colors.amber,
          size: 20.0,
        )):
        Container(
        child:  ListView.builder(
             scrollDirection: Axis.horizontal,
             itemCount: dump.length,
             itemBuilder: (context,index)=>_renderChannels(context,dump[index]),
        ),
      ),
    );
  }
}

Widget _renderChannels(BuildContext context, channel){

   var id= channel['id'],
       title=channel['snippet']['title'],
       thumbnails=channel['snippet']['thumbnails']['default']['url'];
       thumbnails=Uri.encodeFull(thumbnails);

      ReCase rc = new ReCase(title);
      title=rc.titleCase;


   return Padding(
     padding: EdgeInsets.all(10.0),
     child:
      Category(id: id,title: title,thumbnails: thumbnails,channel: channel),
   );
}
class Category extends StatelessWidget {

    final channel;
    final thumbnails;
    final title;
    final id;
    Category({this.channel,this.id,this.thumbnails, this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: (){
      Navigator.push(context,MaterialPageRoute(
        builder: (context)=>VideoList(id:id,title: title,channel: channel)
      ));
    },
      child:
     Container(
      alignment: Alignment.center,
      width: 100.0,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 8.0,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(thumbnails),
            radius: 25,
            backgroundColor: Color(0xfff1f3f5),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              title,
              style: TextStyle(
                  inherit: true,
                  fontSize: 12.0,
                  color: Colors.black),
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
     ),
    );
  }
}

