import 'package:atteventify/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

abstract class NetworkInfoI {
  Future<bool> isConnected();
  Future<Future<List<ConnectivityResult>>?> get connectivityResult;
  Stream<List<ConnectivityResult>>? get onConnectivityChanged;
}

class NetworkInfo implements NetworkInfoI {
  Connectivity? connectivity;

  static final NetworkInfo _networkInfo = NetworkInfo._internal(Connectivity());

  factory NetworkInfo() {
    return _networkInfo;
  }

  NetworkInfo._internal(this.connectivity) {
    connectivity = this.connectivity;
  }

  @override
  Future<bool> isConnected() async {
    final result = await connectivity?.checkConnectivity();
    if (result != ConnectivityResult.none) {
      return true;
    }
    return false;
  }

  @override
  Future<Future<List<ConnectivityResult>>?> get connectivityResult async {
    return connectivity?.checkConnectivity();
  }

  @override
  Stream<List<ConnectivityResult>>? get onConnectivityChanged =>
      connectivity?.onConnectivityChanged;
}

abstract class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class ServerException extends Failure {}

class CacheException extends Failure {}

class NetworkException extends Failure {}

class NoInternetException implements Exception {
  late String _message;

  NoInternetException([String message = 'NoInternetException occured']) {
    if (globalMessengerKey.currentState != null) {
      globalMessengerKey.currentState!
          .showSnackBar(SnackBar(content: Text(message)));
    }
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
