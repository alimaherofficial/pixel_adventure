import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/component/collision_blocks.dart';
import 'package:pixel_adventure/component/player_hitbox.dart';
import 'package:pixel_adventure/component/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running, jumping, falling }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  Player({position, this.character = 'Ninja Frog'}) : super(position: position);
  final String character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  final double stepTime = 0.05;

  double moveSpeed = 100;
  double horizontalMovement = 0.0;
  final double _gravity = 9.8;
  final double _jumpForce = 460;
  final double _terminalVelocity = 300;

  Vector2 velocity = Vector2.zero();

  bool isOnGround = false;

  bool isJumping = false;

  bool isFacingRight = true;

  List<CollisionBlocks> collisionBlocks = [];

  PlayerHitBox playerHitBox = PlayerHitBox(
    x: 10,
    y: 4,
    width: 14,
    height: 28,
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    // debugMode = true;
    add(RectangleHitbox(
      position: Vector2(playerHitBox.x, playerHitBox.y),
      size: Vector2(playerHitBox.width, playerHitBox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollision();
    _applyGravity(dt);
    _checkVerticalCollision();

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    isJumping = keysPressed.contains(LogicalKeyboardKey.space); // jump

    if (isLeftKeyPressed) {
      horizontalMovement = -1;
    } else if (isRightKeyPressed) {
      horizontalMovement = 1;
    } else {
      horizontalMovement = 0;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation(state: 'Idle', amount: 11);
    runningAnimation = _spriteAnimation(state: 'Run', amount: 12);
    jumpingAnimation = _spriteAnimation(state: 'Jump', amount: 1);
    fallingAnimation = _spriteAnimation(state: 'Fall', amount: 1);

    // list of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
    };
    // set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation({
    required String state,
    required int amount,
  }) {
    return SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x != 0) {
      playerState = PlayerState.running;
    }

    if (isJumping) {
      playerState = PlayerState.jumping;
    }

    if (!isOnGround && velocity.y > 0) {
      playerState = PlayerState.falling;
    }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (isJumping && isOnGround) {
      _playerJump(dt);
    }
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _checkHorizontalCollision() {
    for (var block in collisionBlocks) {
      // handle collision
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - playerHitBox.x - playerHitBox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x =
                block.x + block.width + playerHitBox.x + playerHitBox.width;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollision() {
    for (var block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - playerHitBox.height - playerHitBox.y;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - playerHitBox.height - playerHitBox.y;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - playerHitBox.y;

            break;
          }
        }
      }
    }
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
  }
}
