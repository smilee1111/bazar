class NotificationApiResponse<T> {
  final bool success;
  final T data;
  final String message;

  const NotificationApiResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory NotificationApiResponse.fromJson(
    Map<String, dynamic> json, {
    required T Function(dynamic data) dataParser,
  }) {
    return NotificationApiResponse<T>(
      success: json['success'] == true,
      data: dataParser(json['data']),
      message: (json['message'] ?? '').toString(),
    );
  }
}
