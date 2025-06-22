import 'dart:async';
import 'package:pat_asl_portal/data/endpoint_collection.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../model/class.dart';
import '../../model/dto/class_dto.dart';

class WebSocketService {
  late io.Socket socket;
  final StreamController<List<Class>> _classesController =
      StreamController.broadcast();

  List<Class> _lastClasses = [];

  Stream<List<Class>> get classesStream => _classesController.stream;
  bool _isConnected = false;

  void initialize(String token) {
    print('Initializing WebSocket connection to 192.168.1.6:3000');

    // Match your dev server IP and port with your backend
    var serverUrl = EndpointCollection.socketServerUrl;

    socket = io.io(serverUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 10,
      'reconnectionDelay': 2000,
      'auth': {'token': token},
    });

    _setupSocketListeners();
    socket.connect(); // Explicitly connect
  }

  bool get isConnected => _isConnected;

  void _setupSocketListeners() {
    socket.onConnect((_) {
      print('✅ WebSocket Connected successfully to 192.168.1.6:3000');
      _isConnected = true;
      socket.emit('subscribe-to-classes');
    });

    socket.on('classes-data', (data) {
      print('Classes data received: ${data is List ? data.length : data}');
      if (data is List && data.isNotEmpty) {
        _handleClassesData(data);
      } else {
        if (_lastClasses.isNotEmpty) {
          _classesController.add(_lastClasses);
        }
      }
    });

    socket.on('class-created', (data) {
      if (_lastClasses.isNotEmpty) {
        final currentClasses = List<Class>.from(_lastClasses);
        _classesController.add(currentClasses);
      }
      socket.emit('subscribe-to-classes');
    });

    socket.on('class-updated', (data) {
      socket.emit('subscribe-to-classes');
    });

    socket.onDisconnect((_) {
      throw Exception('WebSocket Disconnected');
      _isConnected = false;
    });

    socket.onConnectError((err) {
      throw Exception('WebSocket Connection Error: $err');
    });

    socket.onError((err) {
      throw Exception('WebSocket Error: $err');
    });
  }

  void _handleClassesData(dynamic data) {
    if (data is List) {
      try {
        final classes = data.map((json) {
          return ClassDTO.fromJson(json).toClass();
        }).toList();

        _lastClasses = classes;
        _classesController.add(classes);
      } catch (e) {
        throw Exception('Failed to parse classes data: $e');
      }
    } else {
      throw Exception('Expected a list of classes, but got: $data');
    }
  }



  void disconnect() {
    if (_isConnected) {
      socket.disconnect();
    }
    _classesController.close();
  }
}
