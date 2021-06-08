# 進度回報


| 日期 | 進度 | 
| -------- | -------- | 
| 2021/06/03 | 找到錄影的code了，目前錄影檔案會存在sdk中，為：“mnt/sdacard/Android/data/<package name>/file/.."。這類檔案隨app刪除而刪除。在嘗試把錄影檔存進相簿| 
| 2021/06/05 | 安裝好Xcode，準備進行IOS的build和錄製測試| 
| 2021/06/06 | 今日無進度，build IOS前要先將Podfile的ios版本改為11|
| 2021/06/07 | 已使用IOS實機測試，按下錄影功能會顯示(錯誤碼:1)的錯誤，無法開啟錄影功能。根據https://github.com/flutter-webrtc/flutter-webrtc的功能顯示以及Functionality only available on Android這行錯誤說明，研判錄影功能在此套件尚未實現。|
| 2021/06/08 | 今日無進度|
---
![](https://i.imgur.com/jXF4ZtX.png)
(錯誤碼:1)IOS報錯:<br>
[VERBOSE-2:ui_dart_state.cc(199)] Unhandled Exception: Unsupported operation: Functionality only available on Android
#0      MethodChannelPathProvider.getExternalStoragePath (package:path_provider_platform_interface/src/method_channel_path_provider.dart:55:7)
#1      getExternalStorageDirectory (package:path_provider/path_provider.dart:155:40)
#2      _GetUserMediaSampleState._startRecording (package:recode/src/get_user_media_sample.dart:100:31)
#3      _InkResponseState._handleTap (package:flutter/src/material/ink_well.dart:989:21)
#4      GestureRecognizer.invokeCallback (package:flutter/src/gestures/recognizer.dart:182:24)
#5      TapGestureRecognizer.handleTapUp (package:flutter/src/gestures/tap.dart:607:11)
#6      BaseTapGestureRecognizer._checkUp (package:flutter/src/gestures/tap.dart:296:5)
#7      BaseTapGestureRecognizer.handlePrimaryPointer (package:flutter/src/gestures/tap.dart:230:7)
#8      PrimaryPointerGestureRecognizer.handleEvent (package:flutter/src/gestures/recognizer.dart:475:9)
#9      PointerRouter._dispatch (package:flutter/src/gestures/pointer_router.dart:93:12)
#10     PointerRouter._dispatchEventToRoutes.<anonymous closure> (package:flutter/src/gestures/pointer_router.dart:138:9)
#11     _LinkedHashMapMixin.forEach (dart:collection-patch/compact_hash.dart:397:8)
#12     PointerRouter._dispatchEventToRoutes (package:flutter/src/gestures/pointer_router.dart:136:18)
#13     PointerRouter.route (package:flutter/src/gestures/pointer_router.dart:122:7)
#14     GestureBinding.handleEvent (package:flutter/src/gestures/binding.dart:439:19)
#15     GestureBinding.dispatchEvent (package:flutter/src/gestures/binding.dart:419:22)
#16     RendererBinding.dispatchEvent (package:flutter/src/rendering/binding.dart:287:11)
#17     GestureBinding._handlePointerEventImmediately (package:flutter/src/gestures/binding.dart:374:7)
#18     GestureBinding.handlePointerEvent (package:flutter/src/gestures/binding.dart:338:5)
#19     GestureBinding._flushPointerEventQueue (package:flutter/src/gestures/binding.dart:296:7)
#20     GestureBinding._handlePointerDataPacket (package:flutter/src/gestures/binding.dart:279:7)
#21     _rootRunUnary (dart:async/zone.dart:1370:13)
#22     _CustomZone.runUnary (dart:async/zone.dart:1265:19)
#23     _CustomZone.runUnaryGuarded (dart:async/zone.dart:1170:7)
#24     _invoke1 (dart:ui/hooks.dart:182:10)
#25     PlatformDispatcher._dispatchPointerDataPacket (dart:ui/platform_dispatcher.dart:282:7)
#26     _dispatchPointerDataPacket (dart:ui/hooks.dart:96:31)
---
參考
https://github.com/flutter-webrtc/flutter-webrtc 裡面的example
https://pub.dev/packages/flutter_webrtc/install

目的是錄影攝像頭
原路徑：在Android裡面的data裡面的com.example.recode裡面的files裡面的webrtc_sample裡

錄影存放路徑教學：
https://blog.csdn.net/nugongahou110/article/details/48154859

影片檔路徑：
https://blog.csdn.net/beyondforme/article/details/103736503
https://pub.dev/documentation/path_provider_platform_interface/latest/path_provider_platform_interface/StorageDirectory-class.html

how-to-display-video-from-path-provider-in-flutter:
https://stackoverflow.com/questions/59046107/how-to-display-video-from-path-provider-in-flutter

