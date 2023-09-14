import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() {
    return const Color(0xFF211f30);
  }

  Player player = Player();
  late JoystickComponent joystickComponent;

  late final CameraComponent cameraComponent;
  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    final level = Level(
      levelName: 'level_1',
      player: player,
    );
    cameraComponent = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: level);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([
      cameraComponent,
      level,
    ]);
    _addJoystick();
    return super.onLoad();
  }

  void _addJoystick() {
    joystickComponent = JoystickComponent();
  }
}
