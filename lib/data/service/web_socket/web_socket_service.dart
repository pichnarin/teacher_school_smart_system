import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pat_asl_portal/data/endpoint_collection.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../model/class.dart';
import '../../model/dto/class_dto.dart';

enum WebSocketConnectionState { connecting, connected, disconnected, error }

class WebSocketService {
  io.Socket? _socket;
  final StreamController<List<Class>> _classesController =
      StreamController.broadcast();
  final StreamController<WebSocketConnectionState> _connectionStateController =
      StreamController.broadcast();

  List<Class> _lastClasses = [];
  bool _isConnected = false;
  Timer? _reconnectTimer;

  // Public getters
  Stream<List<Class>> get classesStream => _classesController.stream;
  Stream<WebSocketConnectionState> get connectionState =>
      _connectionStateController.stream;
  bool get isConnected => _isConnected;

  void initialize(String token) {
    debugPrint('Initializing WebSocket connection');
    _connectionStateController.add(WebSocketConnectionState.connecting);

    // Match your dev server IP and port with your backend
    var serverUrl = EndpointCollection.socketServerUrl;

    _socket = io.io(serverUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 10,
      'reconnectionDelay': 2000,
      'auth': {'token': token},
    });

    _setupSocketListeners();
    _socket?.connect();
  }

  void _setupSocketListeners() {
    _socket?.onConnect((_) {
      debugPrint('✅ WebSocket Connected successfully');
      _isConnected = true;
      _connectionStateController.add(WebSocketConnectionState.connected);

      // Cancel any reconnect timer if we successfully connected
      _reconnectTimer?.cancel();
      _reconnectTimer = null;

      _socket?.emit('subscribe-to-classes');
    });

    _socket?.on('classes-data', (data) {
      debugPrint('Classes data received: ${data is List ? data.length : data}');
      if (data is List && data.isNotEmpty) {
        _handleClassesData(data);
      } else {
        if (_lastClasses.isNotEmpty) {
          _classesController.add(_lastClasses);
        }
      }
    });

    _socket?.on('class-created', (data) {
      debugPrint('Class created event received');
      if (_lastClasses.isNotEmpty) {
        final currentClasses = List<Class>.from(_lastClasses);
        _classesController.add(currentClasses);
      }
      _socket?.emit('subscribe-to-classes');
    });

    _socket?.on('class-updated', (data) {
      debugPrint('Class updated event received');
      _socket?.emit('subscribe-to-classes');
    });

    _socket?.onDisconnect((_) {
      debugPrint('WebSocket disconnected');
      _isConnected = false;
      _connectionStateController.add(WebSocketConnectionState.disconnected);
      _scheduleReconnect();
    });

    _socket?.onConnectError((err) {
      debugPrint('WebSocket connection error: $err');
      _isConnected = false;
      _connectionStateController.add(WebSocketConnectionState.error);
      _scheduleReconnect();
    });

    _socket?.onError((err) {
      debugPrint('WebSocket error: $err');
      _connectionStateController.add(WebSocketConnectionState.error);
    });
  }

  void _scheduleReconnect() {
    // Don't schedule multiple reconnect timers
    if (_reconnectTimer != null && _reconnectTimer!.isActive) return;

    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      debugPrint('Attempting to reconnect WebSocket...');
      if (_socket != null && !_isConnected) {
        _socket!.connect();
      }
    });
  }

  void _handleClassesData(dynamic data) {
    if (data is List) {
      try {
        final classes =
            data.map((json) {
              return ClassDTO.fromJson(json).toClass();
            }).toList();

        _lastClasses = classes;
        _classesController.add(classes);
      } catch (e) {
        debugPrint('Failed to parse classes data: $e');
      }
    } else {
      debugPrint('Expected a list of classes, but got: $data');
    }
  }

  // Call this when app resumes from background
  void handleAppResume() {
    debugPrint('App resumed, checking WebSocket connection');
    if (!_isConnected && _socket != null) {
      debugPrint('Reconnecting WebSocket after app resume');
      _socket!.connect();
    } else if (_isConnected) {
      debugPrint('WebSocket already connected, refreshing data');
      _socket!.emit('subscribe-to-classes');
    }
  }

  // Call this when app goes to background
  void handleAppPause() {
    debugPrint('App paused');
    // Optionally disconnect when app goes to background
    // _socket?.disconnect();
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    if (_socket != null && _isConnected) {
      _socket!.disconnect();
      _socket = null;
    }
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _classesController.close();
    _connectionStateController.close();
  }
}
