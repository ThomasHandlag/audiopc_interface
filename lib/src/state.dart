import 'dart:async';

/// PlayerState represents the current state of the audio player.
enum PlayerState {
  /// The player is idle and not doing anything.
  idle,

  /// The player is currently playing audio.
  playing,

  /// The player is paused.
  paused,

  /// The player encountered an error.
  stopped,
}

/// StateMixin provides a mixin for managing the player state and notifying listeners of state changes.
/// This mixin can be used in any class that needs to track the state of the audio player and provide a stream of state updates.
mixin class PlayerStateMixin {
  /// The default state of the audio player.
  PlayerState state = PlayerState.idle;

  /// setState updates the current state and notifies listeners through the state stream.
  void setState(PlayerState newState) {
    state = newState;
    playerStateController.add(state);
  }

  /// stateStreamController is a broadcast stream controller that allows multiple listeners to subscribe to state updates.
  final StreamController<PlayerState> playerStateController =
      StreamController.broadcast();

  final StreamController<int> positionController = StreamController.broadcast();

  /// Provides a stream of PlayerState updates that listeners can subscribe to in order to react to changes in the player's state.
  Stream<PlayerState> get stateStream => playerStateController.stream;

  /// Provides a stream of playback position updates in milliseconds.
  Stream<int> get positionStream => positionController.stream;
}
