import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/component/collision_blocks.dart';
import 'package:pixel_adventure/component/player.dart';

class Level extends World {
  late TiledComponent _tiledComponent;

  final String levelName;

  final Player player;
  List<CollisionBlocks> collisionBlocks = [];

  Level({
    super.children,
    super.priority,
    required this.levelName,
    required this.player,
  });

  @override
  FutureOr<void> onLoad() async {
    _tiledComponent =
        await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(_tiledComponent);
    final spawnPointsPlayer =
        _tiledComponent.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    final collisionPoints =
        _tiledComponent.tileMap.getLayer<ObjectGroup>('Collision');
    if (spawnPointsPlayer != null) {
      for (var spawnPoint in spawnPointsPlayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);

            break;
          default:
        }
      }
    }

    if (collisionPoints != null) {
      for (var collisionPoint in collisionPoints.objects) {
        switch (collisionPoint.class_) {
          case 'Platform':
            final platform = CollisionBlocks(
              position: Vector2(collisionPoint.x, collisionPoint.y),
              size: Vector2(collisionPoint.width, collisionPoint.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlocks(
              position: Vector2(collisionPoint.x, collisionPoint.y),
              size: Vector2(collisionPoint.width, collisionPoint.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
      player.collisionBlocks = collisionBlocks;
    }

    return super.onLoad();
  }
}
