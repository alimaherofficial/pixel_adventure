import 'package:flame/components.dart';

class CollisionBlocks extends PositionComponent {
  bool isPlatform;
  CollisionBlocks({
    position,
    size,
    this.isPlatform = false,
  }) : super(position: position, size: size) {
    // debugMode = true;
  }
}
