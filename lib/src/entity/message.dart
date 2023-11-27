import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required final String content,
    required final String name,
    required final String? representedColorCode,
  }) = _Message;

  factory Message.fromJson(Map<String, Object?> json) {
    return Message(
      content: '${json['message'] ?? ''}',
      name: '${json['user'] ?? 'N/A'}',
      representedColorCode: json['color'] == null ? null : '${json['color']}',
    );
  }
}
