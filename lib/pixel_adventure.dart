import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/component/level.dart';
import 'package:pixel_adventure/component/player.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() {
    return const Color(0xFF211f30);
  }

  Player player = Player();
  late JoystickComponent joystickComponent;

  late final CameraComponent cameraComponent;
  late HudButtonComponent jumpButton;
  bool isPaused = false;

  bool showJoystick = true;
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
    if (showJoystick) {
      _addJoystick();
      _addJumpButton();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      _updateJoystick();
      _updateJumpButton(dt);
    }
    super.update(dt);
  }

  void _addJoystick() {
    joystickComponent = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystickComponent);
  }

  void _updateJoystick() {
    switch (joystickComponent.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;

      default:
        player.horizontalMovement = 0;
    }
  }

  void _addJumpButton() {
    jumpButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/joystick.png')),
      ),
      margin: const EdgeInsets.only(right: 32, bottom: 32),
      position: Vector2(1, 1),
      onPressed: () {
        isPaused = true;
      },
    );
    add(jumpButton);
  }

  void _updateJumpButton(double dt) {
    if (isPaused && player.isOnGround) {
      player.playerJump(dt);
      isPaused = false;
    }
  }
}
