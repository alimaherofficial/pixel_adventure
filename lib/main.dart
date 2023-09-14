import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  PixelAdventure game = PixelAdventure();

  runApp(
    GameWidget(
      game: kDebugMode ? PixelAdventure() : game,
    ),
  );
}
// flutter command to build exe 
// flutter build windows --release --no-sound-null-safety