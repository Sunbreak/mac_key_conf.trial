// ignore_for_file: avoid_web_libraries_in_flutter

@JS()
library web_hid;

import 'dart:html' show EventTarget;
import 'dart:js_util' show promiseToFuture;

import 'package:js/js.dart';

import 'js_facade.dart';

@JS('navigator.hid')
external EventTarget? get _hid;

bool canUse() => _hid != null;

Hid? _instance;
Hid get hid {
  if (_hid != null) {
    return _instance ??= Hid._(_hid);
  }
  throw 'navigator.hid unavailable';
}

class Hid extends Delegate<Object> {
  Hid._(delegate) : super(delegate);

  Future<List<HidDevice>> requestDevice([RequestOptions? options]) {
    var promise = callMethod('requestDevice', [options ?? RequestOptions(filters: [])]);
    return promiseToFuture(promise).then((value) {
      return (value as List).map((e) => HidDevice._(e)).toList();
    });
  }

  Future<List<HidDevice>> getDevices() {
    var promise = callMethod('getDevices');
    return promiseToFuture(promise).then((value) {
      return (value as List).map((e) => HidDevice._(e)).toList();
    });
  }
}

@JS()
@anonymous
class RequestOptions {
  external factory RequestOptions({
    required List<dynamic> filters,
  });
}

@JS()
@anonymous
class RequestOptionsFilter {
  external factory RequestOptionsFilter({
    int vendorId,
    int productId,
    int usage,
    int usagePage,
  });
}

class HidDevice extends Delegate<EventTarget> {
  HidDevice._(EventTarget delegate) : super(delegate);

  Future<void> open() {
    var promise = callMethod('open');
    return promiseToFuture(promise);
  }

  Future<void> close() {
    var promise = callMethod('close');
    return promiseToFuture(promise);
  }

  Future<void> sendFeatureReport(int requestId, Object bytes) {
    var promise = callMethod('sendFeatureReport', [requestId, bytes]);
    return promiseToFuture(promise);
  }
}