import 'package:pixel_adventure/component/collision_blocks.dart';
import 'package:pixel_adventure/component/player.dart';

bool checkCollision(Player player, CollisionBlocks block) {
  final hitBox = player.playerHitBox;
  final playerX = player.position.x + hitBox.x;
  final playerY = player.position.y + hitBox.y;
  final playerWidth = hitBox.width;
  final playerHeight = hitBox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX =
      player.scale.x > 0 ? playerX : playerX - (hitBox.x * 2) - playerWidth;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;
  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
