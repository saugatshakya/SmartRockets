import 'dart:math';

import 'package:get/get.dart';
import 'package:vector_math/vector_math.dart';

class RocketdATA extends GetxController {
  RocketdATA({this.genes, required this.lifeSpan});
  Vector2 previousPos = Vector2.zero();
  Vector2 currentPos = Vector2(Get.width / 2, Get.height * 0.9);
  Vector2 vel = Vector2.zero();
  Vector2 acc = Vector2.zero();
  List<Vector2>? genes;
  double fitness = 0;
  int? completedIn;
  bool failedByBorder = false;
  bool failedByObstacle = false;
  final int lifeSpan;
  Vector2 target = Vector2(Get.width / 2, 16);
  List<double> obstacleLength = [Get.width * 0.6, Get.width * 0.6];
  List<Vector2> obstaclePos = [
    Vector2(0, Get.height * 0.7),
    Vector2(Get.width * 0.4, Get.height * 0.2)
  ];

  createGenes() async {
    genes = [];
    for (int i = 0; i < lifeSpan; i++) {
      genes!.add(Vector2(
          (Random().nextInt(7) - 3) * 1.0, Random().nextInt(10) > 7 ? 0 : -1));
    }
  }

  applyForce(force) {
    acc.add(force);
    update();
  }

  updateFitness(val) {
    fitness = val * 1.0;
    update;
  }

  updateRocket(life) async {
    if (genes == null) {
      await createGenes();
    }
    double d = currentPos.distanceTo(target);

    applyForce(genes![life]);
    if (completedIn == null) {
      if (d < 20) {
        completedIn = life;
        currentPos = target.clone();
      }
      for (int i = 0; i < obstacleLength.length; i++) {
        if (currentPos.y - 30 <= obstaclePos[i].y &&
            currentPos.y + 32 >= obstaclePos[i].y &&
            currentPos.x >= obstaclePos[i].x &&
            currentPos.x <= obstaclePos[i].x + obstacleLength[i]) {
          failedByObstacle = true;
        }
      }
      if (currentPos.y + 32 > Get.height ||
          currentPos.y - 32 < 0 ||
          currentPos.x + 16 > Get.width ||
          currentPos.x - 16 < 0) {
        if (currentPos.y - 32 < 0) {
          failedByBorder = true;
        } else {
          failedByObstacle = true;
        }
      }
      if (!(failedByBorder || failedByObstacle)) {
        vel.add(acc);
        previousPos = currentPos.clone();
        currentPos.add(vel);
        acc.setZero();
      }
    }
    update();
  }

  crossover(RocketdATA roctet) {
    List<Vector2> newGenes = [];
    var midPoint = Random().nextInt(genes!.length);
    for (int i = 0; i < genes!.length; i++) {
      if (i > midPoint) {
        newGenes.add(genes![i]);
      } else {
        newGenes.add(roctet.genes![i]);
      }
    }
    return RocketdATA(genes: newGenes, lifeSpan: lifeSpan);
  }

  mutation() {
    for (int i = 0; i < genes!.length; i++) {
      if (Random().nextInt(100) == 0) {
        genes![i] = Vector2(
            (Random().nextInt(7) - 3) * 1.0, Random().nextInt(10) > 7 ? 0 : -1);
      }
    }
  }
}
