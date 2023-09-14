import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/component/player.dart';

class Level extends World {
  late TiledComponent _tiledComponent;

  final String levelName;

  final Player player;

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

    for (var spawnPoint in spawnPointsPlayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);

          break;
        default:
      }
    }

    return super.onLoad();
  }
}
