extension StringExtension on String {
  /// Format String
  ///
  /// Example
  /// jimmy -> Jimmy
  String toUpperFirstLetter() {
    var letters = split('');
    var firstLetter = letters.first.toUpperCase();
    return [firstLetter, ...letters.getRange(1, letters.length)].join();
  }
}
