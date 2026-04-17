/// A custom error class for Audiopc-related errors.
class AudiopcError extends Error {

  /// A descriptive message about the error.
  final String message;

  /// Constructs an [AudiopcError] with the given message.
  AudiopcError(this.message);

  @override
  String toString() => 'AudiopcError: $message';
}