import 'dart:async';
import 'dart:typed_data';

import 'package:audiopc_interface/src/backend_info.dart';
import 'package:audiopc_interface/src/meta_data.dart';
import 'package:audiopc_interface/src/state.dart';

/// Defines the common interface for both native and web implementations of the audio player.
abstract class AudiopcInterface with PlayerStateMixin {
  /// Retrieves information about the audio backend, including the default output sample rate,
  /// number of channels, and available output devices.
  AudioBackendInfo getAudioBackendInfo();

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
  ///
  /// A low-pass filter allows frequencies below the specified cutoff frequency to pass through while attenuating frequencies above it.
  bool setLowPassHz(double hz);

  /// Sets high-pass cutoff in Hz. Use 0 to disable filtering.
  ///
  /// A high-pass filter allows frequencies above the specified cutoff frequency to pass through while attenuating frequencies below it.
  bool setHighPassHz(double hz);

  /// Permits frequencies within a specific range while attenuating those outside of it.
  ///
  /// The `min` parameter specifies the lower cutoff frequency in Hz,
  /// while the `max` parameter specifies the upper cutoff frequency in Hz.
  bool setBandPassHz(double min, double max);

  /// Boosts or cuts frequencies around a center frequency in Hz,
  /// with a specified gain in dB and quality factor Q.
  ///
  /// The `centerHz` parameter specifies the center frequency of the peak filter in Hz,
  /// which determines the frequency around which the boost or cut is applied.
  /// The `gainDb` parameter controls the amount of boost or cut applied to frequencies around the center frequency,
  /// where a positive value results in a boost and a negative value results in a cut.
  ///
  /// The `q` parameter controls the quality factor of the filter,
  /// which affects the bandwidth of the boost or cut around the center frequency.
  /// A higher Q value results in a narrower bandwidth,
  /// while a lower Q value results in a wider bandwidth.
  bool setPeakFilter(double centerHz, double gainDb, double q);

  /// Sets a low shelving filter with a specified cutoff frequency in Hz,
  /// gain in dB, and quality factor Q.
  ///
  /// The `cutoffHz` parameter specifies the cutoff frequency of the low shelf filter in Hz,
  /// which determines the point at which the filter starts to boost or cut frequencies.
  ///
  /// The `gainDb` parameter controls the amount of boost or cut applied to frequencies below the cutoff frequency,
  /// where a positive value results in a boost and a negative value results in a cut.
  ///
  /// The `q` parameter controls the quality factor of the filter,
  /// which affects the slope of the boost or cut around the cutoff frequency.
  bool setLowShelfFilter(double cutoffHz, double gainDb, double q);

  /// Sets a high shelving filter with a specified cutoff frequency in Hz,
  /// gain in dB, and quality factor Q.
  ///
  /// The `cutoffHz` parameter specifies the cutoff frequency of the high shelf filter in Hz,
  /// which determines the point at which the filter starts to boost or cut frequencies.
  ///
  /// The `gainDb` parameter controls the amount of boost or cut applied to frequencies above the cutoff frequency,
  /// where a positive value results in a boost and a negative value results in a cut.
  ///
  /// The `q` parameter controls the quality factor of the filter,
  /// which affects the slope of the boost or cut around the cutoff frequency.
  /// A higher Q value results in a steeper slope, while a lower Q value results in a gentler slope.
  bool setHighShelfFilter(double cutoffHz, double gainDb, double q);

  /// Sets a comb filter with a specified delay in milliseconds, feedback level, and damping factor.
  ///
  /// The `delayMs` parameter specifies the delay time of the comb filter in milliseconds,
  /// which determines the spacing of the notches in the frequency response.
  ///
  /// The `feedback` parameter controls the amount of the delayed signal that is fed back into the input,
  /// where a value of 0 means no feedback and values closer to 1 result in a more pronounced comb filtering effect.
  ///
  /// The `damp` parameter controls the damping of the comb filter,
  /// which affects the decay of the notches in the frequency response.
  bool setCombFilter(double delayMs, double feedback, double damp);

  /// Sets a reverb effect with specified room size, damping, and wet/dry mix parameters.
  bool setReverb(
    double roomSize,
    double damping,
    double wetLevel,
    double dryLevel,
  );

  /// T-notch filter or band-rejection filter is a filter that passes most frequencies unaltered,
  /// but attenuates those in a specific range to very low levels.
  ///
  /// The `centerHz` parameter specifies the center frequency of the notch in Hz,
  /// while `bandwidthHz` defines the width of the notch in Hz.
  ///
  /// The `gainDb` parameter allows for adjusting the depth of the notch,
  /// where a more negative value results in a deeper notch.
  bool setNotchFilter(double centerHz, double bandwidthHz, double gainDb);

  /// Sets the playback rate where 1.0 is the nominal rate.
  bool setRate(double value);

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
  Future<MetaData?> getMetadata(String url);

  /// Retrieves the thumbnail image data from the native backend.
  /// Returns a byte array representing the image,
  /// or an empty array if no thumbnail is available.
  ///
  /// The `url` parameter specifies the source URL for which to retrieve the thumbnail.
  ///
  /// The `maxSize` parameter specifies the maximum image in bytes to return,
  /// allowing for efficient retrieval of thumbnails without overwhelming memory.
  /// Default `maxSize` is set to 20 MB.
  Future<Uint8List?> getThumbnail(String url, {int maxSize = 20 * 1024 * 1024});

  /// Stops playback and releases timers and stream controllers.
  void dispose();
}
