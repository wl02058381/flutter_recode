// ignore: uri_does_not_exist
import 'dart:core';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/*
 * getUserMedia sample
 */
class GetUserMediaSample extends StatefulWidget {
  static String tag = 'get_usermedia_sample';

  @override
  _GetUserMediaSampleState createState() => _GetUserMediaSampleState();
}
//取得個人影音數據流
class _GetUserMediaSampleState extends State<GetUserMediaSample> {
  MediaStream? _localStream;
  final _localRenderer = RTCVideoRenderer(); //RTC視頻渲染器
  bool _inCalling = false; //預設是沒有calling
  MediaRecorder? _mediaRecorder;

  List<MediaDeviceInfo>? _cameras;

  bool get _isRec => _mediaRecorder != null;
  List<dynamic>? cameras;

  @override
  void initState() {
    super.initState();
    initRenderers();

    navigator.mediaDevices.enumerateDevices().then((md) {
      setState(() {
        cameras = md.where((d) => d.kind == 'videoinput').toList();
      });
    });
  }

  @override
  void deactivate() { //停用
    super.deactivate();
    if (_inCalling) {
      _stop(); //
    }
    _localRenderer.dispose();//釋放WebRTC渲染器的記憶體
  }

  void initRenderers() async {
    await _localRenderer.initialize(); //初始化
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _makeCall() async {
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '1280', // Provide your own width, height and frame rate here
          'minHeight': '720',
          'minFrameRate': '30',
        },
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _cameras = await Helper.cameras;
      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;

    setState(() {
      _inCalling = true;
    });
  }

  Future<void> _stop() async {
    try {
      await _localStream?.dispose(); //釋放串流記憶體
      _localStream = null;
      _localRenderer.srcObject = null; //渲染
    } catch (e) {
      print(e.toString());
    }
  }
  //關閉攝像頭按鈕的方法
  void _hangUp() async {
    await _stop();
    setState(() {
      _inCalling = false;
    });
  }
  //開始錄影
  void _startRecording() async {
    if (_localStream == null) throw Exception('Can\'t record without a stream');
    _mediaRecorder = MediaRecorder();
    setState(() {});
    _mediaRecorder?.startWeb(_localStream!);
  }
  //停止錄影
  void _stopRecording() async {
    final objectUrl = await _mediaRecorder?.stop();
    setState(() {
      _mediaRecorder = null;
    });
    print(objectUrl); //錄影完的物件
    // ignore: unsafe_html
    html.window.open(objectUrl, '_blank'); //用個新視窗開啟來
  }

  void _captureFrame() async {
    if (_localStream == null) throw Exception('Can\'t record without a stream');
    final videoTrack = _localStream!
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    final frame = await videoTrack.captureFrame();
    //show截圖的Alert
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content:
                  //截圖
                  Image.memory(frame.asUint8List(), height: 720, width: 1280),
              actions: <Widget>[
                //關掉截圖的Alert
                TextButton(
                  onPressed: Navigator.of(context, rootNavigator: true).pop,
                  child: Text('OK'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetUserMedia API Test'),
        actions: _inCalling
            ? <Widget>[
                //截圖按鈕
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: _captureFrame,
                ),
                //右上角的開始錄影按鈕跟結束錄影按鈕
                IconButton(
                  icon: Icon(_isRec ? Icons.stop : Icons.fiber_manual_record),
                  onPressed: _isRec ? _stopRecording : _startRecording,
                ),
                //顯示能使用的攝影機裝置
                PopupMenuButton<String>(
                  onSelected: _switchCamera, 
                  itemBuilder: (BuildContext context) {
                    if (_cameras != null) {
                      return _cameras!.map((device) {
                        return PopupMenuItem<String>(
                          value: device.deviceId,
                          child: Text(device.label),
                        );
                      }).toList();
                    } else {
                      return [];
                    }
                  },
                ),
                // IconButton(
                //   icon: Icon(Icons.settings),
                //   onPressed: _switchCamera,
                // )
              ]
            : null,
      ),
      //有時候App會因應行動裝置擺放的方向不同而有相對應的介面，用Flutter提供的OrientationBuilder widget來實現這項功能。
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.black54),
              child: RTCVideoView(_localRenderer, mirror: true),
            ),
          );
        },
      ),
      //右下角的電話按鈕，用來開啟畫面
      floatingActionButton: FloatingActionButton(
        onPressed: _inCalling ? _hangUp : _makeCall, //開關攝像頭
        tooltip: _inCalling ? 'Hangup' : 'Call',
        child: Icon(_inCalling ? Icons.call_end : Icons.phone),//變化電話的ｉcon
      ),
    );
  }
  //開關攝像頭
  void _switchCamera(String deviceId) async {
    if (_localStream == null) return;
    /// getVideoTracks()返回一个列表[MediaStreamTrack]对象，代表这个流中的视频轨道。
    /// 该列表代表了这个流的轨道集中所有[MediaStreamTrack]对象的快照，这些对象的种类等于 "视频"。
    await Helper.switchCamera(
        _localStream!.getVideoTracks()[0], deviceId, _localStream);
    setState(() {});//更新狀態
  }
}
