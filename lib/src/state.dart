import 'dart:async';

/// PlayerState represents the current state of the audio player.
enum PlayerState {
  /// The player is idle and not doing anything.
  idle,

  /// The player is loading audio data.
  loading,

  /// The player is currently playing audio.
  playing,

  /// The player is paused.
  paused,

  /// The player encountered an error.
  error,
}

/// StateMixin provides a mixin for managing the player state and notifying listeners of state changes.
/// This mixin can be used in any class that needs to track the state of the audio player and provide a stream of state updates.
mixin class StateMixin {
  /// The default state of the audio player.
  PlayerState state = PlayerState.idle;

  /// setState updates the current state and notifies listeners through the state stream.
  void setState(PlayerState newState) {
    state = newState;
    stateStreamController.add(state);
  }

  /// stateStreamController is a broadcast stream controller that allows multiple listeners to subscribe to state updates.
  final StreamController<PlayerState> stateStreamController =
      StreamController.broadcast();

  /// stateStream provides a stream of PlayerState updates that listeners can subscribe to in order to react to changes in the player's state.
  Stream<PlayerState> get stateStream => stateStreamController.stream;
}
