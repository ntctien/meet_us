import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required final int userId,
    required final String content,
    required final String name,
    required final String? representedColorCode,
  }) = _Message;

  factory Message.fromJson(Map<String, Object?> json) {
    return Message(
      userId: json['uid'] as int,
      content: '${json['message'] ?? ''}',
      name: '${json['username'] ?? 'N/A'}',
      representedColorCode: json['color'] == null ? null : '${json['color']}',
    );
  }
}
