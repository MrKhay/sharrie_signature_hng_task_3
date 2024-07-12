// ignore_for_file: public_member_api_docs, sort_constructors_first

/// Nullable Data [T]
///
/// Nullable Error [String]
class CustomResponse<T> {
  /// data
  T? value;

  /// error
  String? error;

  CustomResponse({
    this.value,
    this.error,
  });

  @override
  String toString() => 'Responce(value: $value, error: $error)';
}
