/// Reports output-device details discovered from the native backend.
class AudioBackendInfo {
  /// Default sample rate in Hz for the selected output device.
  final int defaultOutputSampleRate;

  /// Number of output channels exposed by the selected output device.
  final int defaultOutputChannels;

  /// Number of output devices visible to the native backend.
  final int outputDeviceCount;

  /// Creates an immutable backend info snapshot.
  const AudioBackendInfo({
    required this.defaultOutputSampleRate,
    required this.defaultOutputChannels,
    required this.outputDeviceCount,
  });

  /// Whether the backend reports usable output capabilities.
  bool get isAvailable =>
      defaultOutputSampleRate > 0 &&
      defaultOutputChannels > 0 &&
      outputDeviceCount >= 0;
}