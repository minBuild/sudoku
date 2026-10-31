import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

// 콘솔 값으로 채운다. apiKey 는 공개값(README §Firebase). 'TODO' 이면 주간 기능을 숨긴다.
const firebaseConfigured = _androidApiKey != 'TODO' && _iosApiKey != 'TODO';

const _androidApiKey = 'TODO';
const _iosApiKey = 'TODO';

FirebaseOptions get currentFirebaseOptions =>
    defaultTargetPlatform == TargetPlatform.iOS ? _ios : _android;

@visibleForTesting
const androidFirebaseOptions = _android;

@visibleForTesting
const iosFirebaseOptions = _ios;

const _android = FirebaseOptions(
  apiKey: _androidApiKey,
  appId: 'TODO',
  messagingSenderId: 'TODO',
  projectId: 'TODO',
);

const _ios = FirebaseOptions(
  apiKey: _iosApiKey,
  appId: 'TODO',
  messagingSenderId: 'TODO',
  projectId: 'TODO',
  iosBundleId: 'io.minbuild.sudoku',
);
