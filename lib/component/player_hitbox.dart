class PlayerHitBox {
  double x;
  double y;
  double width;
  double height;

  PlayerHitBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  bool isColliding(PlayerHitBox other) {
    return (x < other.x + other.width &&
        x + width > other.x &&
        y < other.y + other.height &&
        y + height > other.y);
  }
}
