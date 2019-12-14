import 'dart:convert';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funtube_v1/activities/search_video.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:youtube_player/youtube_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:funtube_v1/config.dart';

class Preview extends StatefulWidget {
  final title;
  final thumbnail;
  final description;
  final videoId;
  final channel;
  final isChannelId;

  Preview(
      {this.isChannelId,
      this.channel,
      this.title,
      this.thumbnail,
      this.description,
      this.videoId});

  @override
  _State createState() => _State();
}

class _State extends State<Preview> {
  double _volume = 1.0;
  VideoPlayerController _videoController;

  dynamic views = 0;
  dynamic subscribers = 0;
  bool isLoading = true;
  bool isFailure = true;
  bool isGetting = true;
  String uri = '';
  List<dynamic> _dump;
  ScrollController _scrollController;
  Widget appBarTitle;
  Icon actionIcon;

  static var title = '';
  var nextPageToken = '',
      channelTitle = '',
      channelId = '',
      channelThumbnails = '',
      publishedAt = '',
      likeCount = '',
      viewCount = '',
      commentCount = '',
      favoriteCount = '',
      dislikeCount = '',
      payload = [],
      channelDump = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    appBarTitle = Text(widget.title);
    actionIcon = Icon(
      Icons.search,
      color: Colors.white,
    );

    setState(() {
      title = widget.title;
    });

    if (widget.isChannelId == true) {
      _getCurrentChannel(widget.channel);
    } else {
      setState(() {
        channelId = widget.channel['id'];
        channelTitle = widget.channel['snippet']['title'];
        channelThumbnails =
            widget.channel['snippet']['thumbnails']['medium']['url'];
        publishedAt = widget.channel['snippet']['publishedAt'];
        views = widget.channel['statistics']['viewCount'];
        subscribers = widget.channel['statistics']['subscriberCount'];
        uri =
            '$YOUTUBE_DATA_URL/search?channelId=$channelId&order=date&part=snippet,id&type=video&maxResults=$MAX&pageToken=$nextPageToken&key=$DEVELOPER_KEY';
      });

      _fetchStatistics(widget.videoId);
      _fetchVideos('_INIT');
    }

    _dump = new List();
    _scrollController = new ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchVideos('_MORE');
      }
    });
    super.initState();
  }

  Future _fetchVideos(String key) async {
    var client = new http.Client();

    print('Fetch vudeo Called');

    try {
      // get starting videos
      var response = await client.get(Uri.encodeFull(uri));
      if (response.statusCode == 200) {
        setState(() {
          dynamic data = jsonDecode(response.body)['items'];
          nextPageToken = jsonDecode(response.body)['nextPageToken'];
          if (key == '_MORE') {
            for (dynamic each in data) {
              _dump.add(each);
            }
          } else {
            _dump = data;
          }
          isFailure = false;
          isLoading = false;
          isGetting = false;
        });
      }
    } catch (ex) {
      _onError(ex);
      print('hello $ex');
      setState(() {
        isLoading = false;
        isGetting = false;
        isFailure = true;
      });
    } finally {
      client.close();
    }
  }

  Future _fetchStatistics(String id) async {
    var client = new http.Client();
    try {
      // get video statistics
      dynamic uri =
          '$YOUTUBE_DATA_URL/videos?part=statistics&id=$id&key=$DEVELOPER_KEY';
      var response = await client.get(Uri.encodeFull(uri));
      if (response.statusCode == 200) {
        setState(() {
          dynamic statistics = jsonDecode(response.body)['items'][0];
          likeCount = statistics['statistics']['likeCount'];
          viewCount = statistics['statistics']['viewCount'];
          commentCount = statistics['statistics']['commentCount'];
          favoriteCount = statistics['statistics']['favoriteCount'];
          dislikeCount = statistics['statistics']['dislikeCount'];
        });
      }
    } finally {
      client.close();
    }
  }

  Future _getCurrentChannel(dynamic id) async {
    // get current channel
    var client = new http.Client();
    try {
      uri =
          '$YOUTUBE_DATA_URL/channels/?part=snippet,contentDetails,statistics&id=$id&key=$DEVELOPER_KEY';
      var response = await client.get(Uri.encodeFull(uri));
      if (response.statusCode == 200) {
        setState(() {
          channelDump = jsonDecode(response.body)['items'];
          dynamic _channel = channelDump[0];
          channelId = _channel['id'];
          channelTitle = _channel['snippet']['title'];
          channelThumbnails =
              _channel['snippet']['thumbnails']['medium']['url'];
          publishedAt = _channel['snippet']['publishedAt'];
          views = _channel['statistics']['viewCount'];
          subscribers = _channel['statistics']['subscriberCount'];
          isGetting = false;
          uri =
              '$YOUTUBE_DATA_URL/search?channelId=$channelId&order=date&part=snippet,id&type=video&maxResults=$MAX&pageToken=$nextPageToken&key=$DEVELOPER_KEY';

          _fetchStatistics(widget.videoId);
          _fetchVideos('_INIT');
        });
      }
    } finally {
      client.close();
    }
  }

  void _onError(error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.title),
          content: Text(error),
        );
      },
    );
  }

  void _stopVideo() {
    _videoController.pause();
  }

  void _shareApp() {
    Share.share(
        'Hi Dear, Download funTube v1.0 to enjoy daily hilarious funny videos from diffrent comedians around the world. $PLAYSTORE_LINK');
  }

  void _searchRequest(String request) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchVideo(search: request)));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double compatableHeight = height / 2.5;

    if (height <= 2800) {
      compatableHeight = height / 2.5;
    } else if (height < 800) {
      compatableHeight = height / 3;
    } else if (height < 432) {
      compatableHeight = height / 3.5;
    }

    subscribers = getFormated('$subscribers');
    viewCount = getFormated('$viewCount');
    dislikeCount = getFormated('$dislikeCount');
    likeCount = getFormated('$likeCount');
    favoriteCount = getFormated('$favoriteCount');

    int _currVal = 1;
    String _currText = '';

    List<GroupModel> _group = [
      GroupModel(
        text: "Low",
        index: 1,
      ),
      GroupModel(
        text: "Medium",
        index: 2,
      ),
      GroupModel(
        text: "High",
        index: 3,
      ),
    ];

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
                if (this.actionIcon.icon == Icons.search) {
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
                } else {
                  this.actionIcon = Icon(Icons.search, color: Colors.white);
                  this.appBarTitle = Text(title);
                }
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(0),
            width: double.infinity,
            height: 240.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                child: YoutubePlayer(
                  context: context,
                  source: widget.videoId,
                  quality: YoutubeQuality.MEDIUM,
                  aspectRatio: 16 / 9,
                  autoPlay: false,
                  loop: false,
                  reactToOrientationChange: true,
                  startFullScreen: false,
                  controlsActiveBackgroundOverlay: false,
                  controlsTimeOut: Duration(seconds: 4),
                  playerMode: YoutubePlayerMode.DEFAULT,
                  callbackController: (controller) {
                    _videoController = controller;
                  },
                  onError: (error) {
                    _onError(error);
                  },
                ),
              ),
            ),
          ),
          Container(
            height: 60.0,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _onError(
                            'Sorry, like feature will be in in the next version.');
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.thumb_up, color: Colors.grey, size: 18),
                          Text(
                            likeCount,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _onError(
                            'Sorry, dislike feature will be in in the next version.');
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.thumb_down, color: Colors.grey, size: 18),
                          Text(
                            dislikeCount,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Video Qty'),
                                content: Container(
                                  height: 200,
                                  child: ListView(
                                      children: _group
                                          .map((t) => RadioListTile(
                                                title: Text("${t.text}"),
                                                groupValue: _currVal,
                                                value: t.index,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _currVal = t.index;
                                                    _currText = t.text;
                                                  });
                                                },
                                              ))
                                          .toList()),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                      },
                      child: Row(
                        children: <Widget>[
                          Text('Quality', style: TextStyle(color: Colors.grey)),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              dynamic title = widget.title,
                                  descriiption = widget.description,
                                  videoid = widget.videoId;
                              Share.share(
                                  'Hi Dear, Watch this video on funTube, $title https://www.youtube.com/watch?v=$videoid $descriiption');
                            },
                            child: Icon(Icons.share)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                           
                          },
                          child: GestureDetector(
                              onTap: () {
                                dynamic videoid = widget.videoId;
                                ClipboardManager.copyToClipBoard(
                                        "https://www.youtube.com/watch?v=$videoid")
                                    .then((result) {
                                  Toast.show(
                                    'Copied',
                                    context,
                                    duration: 2,
                                    gravity: Toast.BOTTOM,
                                  );
                                });
                              },
                              child: Icon(Icons.content_copy)),
                        ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: Column(
                  //     children: <Widget>[
                  //       GestureDetector(
                  //         onTap: (){
                  //           Navigator.push(context, MaterialPageRoute(
                  //             builder: (context)=>DownloadVideo(title: widget.title,id: widget.videoId),
                  //           ));
                  //         },
                  //         child:Icon(Icons.save_alt)
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Divider(),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: isGetting
                      ? Center(
                          child: SpinKitWave(
                          color: Colors.amber,
                          size: 30.0,
                        ))
                      : Row(
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(channelThumbnails),
                                  radius: 25,
                                  backgroundColor: Color(0xfff1f3f5),
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            channelTitle,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text('$subscribers Subscribers',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                          ],
                        ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            height: compatableHeight,
            child: isLoading
                ? Center(
                    child: SpinKitRing(
                    color: Colors.amber,
                    size: 40.0,
                  ))
                : isFailure
                    ? Center(
                        child: Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.warning,
                                    color: Colors.amber, size: 50),
                                Text(FAILURE),
                              ],
                            )))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _dump.length,
                        itemBuilder: (context, index) => video(
                            context,
                            _dump[index],
                            widget.channel,
                            widget.description,
                            _stopVideo),
                      ),
          ),
        ],
      ),
    );
  }
}

Widget video(BuildContext context, video, channel, description, _stopVideo) {
  var title = video['snippet']['title'],
      videoId = video['id']['videoId'],
      thumbnail = video['snippet']['thumbnails']['medium']['url'],
      date = video['snippet']['publishedAt'];

  var timeAgo = DateTime.parse(date);
  date = timeago.format(timeAgo);

  return GestureDetector(
    onTap: () {
      _stopVideo();
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

class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
}
