import 'dart:async';
import 'dart:typed_data';

import 'package:audiopc_interface/src/backend_info.dart';
import 'package:audiopc_interface/src/meta_data.dart';


/// Defines the common interface for both native and web implementations of the audio player.
abstract class AudiopcInterface {
  /// Retrieves information about the audio backend, including the default output sample rate,
  /// number of channels, and available output devices.
  AudioBackendInfo getAudioBackendInfo();

  /// Emits playback position updates in milliseconds.
  /// The stream emits updates at a regular interval while audio is playing, and may emit 0 when idle.
  Stream<int> get positionStream;

  /// Sets a local file path as the active source.
  bool setFileSource(String path);

  /// Sets a direct URL as the active source.
  bool setUrlSource(String url);

  /// Sets an in-memory byte buffer as the active source.
  bool setMemorySource(List<int> data);

  /// Seeks to a playback position in milliseconds.
  void seek(int positionMillis);

  /// Starts or resumes playback.
  bool play();

  /// Pauses active playback.
  bool pause();

  /// Stops playback and resets to the idle state.
  bool stop();

  /// Sets output gain where 1.0 is the nominal level.
  bool setVolume(double value);

  /// Sets low-pass cutoff in Hz. Use 0 to disable filtering.
  bool setLowPassHz(double hz);

  /// Number of decoded samples waiting in the native buffer.
  int get bufferedSamples;

  /// Current playback position in milliseconds.
  int get positionMillis;

  /// Total media duration in milliseconds, or a negative value if unknown.
  int get durationMillis;

  /// Number of visualizer samples ready to be copied.
  int get visualizerAvailableSamples;

  /// Visualizer sample rate reported by the backend.
  int get visualizerSampleRate;

  /// Visualizer channel count reported by the backend.
  int get visualizerChannels;

  /// Copies normalized time-domain visualizer samples.
  List<double> getVisualizerSamples(int maxSamples);

  /// Copies normalized frequency-domain bars for a spectrum view.
  List<double> getVisualizerSpectrum(int maxBars);

  /// Retrieves the current metadata snapshot from the native backend.
  MetaData getMetadata(String url);

  /// Retrieves the thumbnail image data from the native backend.
  /// Returns a byte array representing the image, or an empty array if no thumbnail is available.
  Uint8List? getThumbnail(String url);

  /// Stops playback and releases timers and stream controllers.
  void dispose();
}
