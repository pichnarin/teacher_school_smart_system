import '../room.dart';

class RoomDTO {
  final String roomId;
  final String roomName;

  const RoomDTO({
    required this.roomId,
    required this.roomName,
  });

  factory RoomDTO.fromJson(Map<String, dynamic> json) {
    return RoomDTO(
      roomId: json['id'] ?? '',
      roomName: json['room_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
    };
  }

  Room toRoom() {
    return Room(
      roomId: roomId,
      roomName: roomName,
    );
  }

  static RoomDTO fromRoom(Room room) {
    return RoomDTO(
      roomId: room.roomId,
      roomName: room.roomName,
    );
  }
}