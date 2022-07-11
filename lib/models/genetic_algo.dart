import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:smart_rockets/models/rocket.dart';

class GeneticAlgo extends GetxController {
  List<RocketdATA> rockets = [];
  List matingPool = [];
  int lifeSpan = 100;
  int life = 0;
  int generation = 0;
  bool pause = false;
  Duration speed = const Duration(milliseconds: 100);
  start() {
    runSimulation();
  }

  runSimulation() async {
    await makepopulation();
    while (life < lifeSpan) {
      if (pause) {
        return;
      }
      for (int i = 0; i < rockets.length; i++) {
        rockets[i].updateRocket(life);
      }
      await Future.delayed(speed);

      life++;
      update();
      if (life >= lifeSpan) {
        generation++;
        life = 0;
        await naturalSelection();
        // await makepopulation();
      }
    }
  }

  resumeSimulation() async {
    pause = false;
    while (life < lifeSpan) {
      if (pause) {
        return;
      }
      for (int i = 0; i < rockets.length; i++) {
        rockets[i].updateRocket(life);
      }
      await Future.delayed(speed);
      life++;
      update();
      if (life >= lifeSpan) {
        await Future.delayed(const Duration(milliseconds: 100));
        generation++;
        life = 0;
        await naturalSelection();
        // await makepopulation();
      }
    }
  }

  makepopulation() {
    int size = 10;
    for (int i = 0; i < size; i++) {
      RocketdATA rocket = RocketdATA(
        lifeSpan: lifeSpan,
      );
      rockets.add(rocket);
    }
    update();
  }

  calculateFitness() async {
    int totalCompletion = 0;
    int? fastestCompletion;
    double maxFitness = 0;
    for (int i = 0; i < rockets.length; i++) {
      double d = rockets[i].currentPos.distanceTo(rockets[i].target);
      if (rockets[i].completedIn != null) {
        totalCompletion++;
        if (fastestCompletion == null) {
          fastestCompletion = rockets[i].completedIn!;
        } else if (rockets[i].completedIn! < fastestCompletion) {
          fastestCompletion = rockets[i].completedIn;
        }
        int supe = (lifeSpan - rockets[i].completedIn!) + 1;
        rockets[i].updateFitness((1 * supe) / (d + 1));
        if ((1 * supe) / (d + 1) > maxFitness) {
          maxFitness = (1 * supe) / (d + 1);
        }
      } else if (rockets[i].failedByObstacle) {
        rockets[i].updateFitness(1 / (5 * d + 5));
        if ((1 / (5 * d + 5)) > maxFitness) {
          maxFitness = 1 / (5 * d + 5);
        }
      } else if (rockets[i].failedByBorder) {
        rockets[i].updateFitness(2 / (d + 1));
        if ((2 / (d + 1)) > maxFitness) {
          maxFitness = 2 / (d + 1);
        }
      } else {
        rockets[i].updateFitness(1 / (d + 1));
        if ((1 / (d + 1)) > maxFitness) {
          maxFitness = 1 / (d + 1);
        }
      }
    }
    if (totalCompletion >= rockets.length / 3) {
      lifeSpan = fastestCompletion!;
    }
    for (int i = 0; i < rockets.length; i++) {
      rockets[i].updateFitness(rockets[i].fitness / maxFitness);
    }
    update();
  }

  fillMatingPool() async {
    await calculateFitness();
    matingPool.clear();
    for (int i = 0; i < rockets.length; i++) {
      int n = (rockets[i].fitness * 100).truncate();
      for (int j = 0; j < n; j++) {
        matingPool.add(rockets[i]);
      }
    }
    update();
  }

  naturalSelection() async {
    await fillMatingPool();
    List<RocketdATA> newRockets = [];
    for (int i = 0; i < rockets.length; i++) {
      RocketdATA parentA = matingPool[Random().nextInt(matingPool.length)];
      RocketdATA parentB = matingPool[Random().nextInt(matingPool.length)];
      RocketdATA child = parentA.crossover(parentB);
      child.mutation();
      newRockets.add(child);
    }
    rockets = newRockets;
    update();
  }

  pauseANDplay() {
    pause = !pause;
    update();
  }

  reset() {
    life = 0;
    generation = 0;
    rockets.clear();
    runSimulation();
    update();
  }

  next() {}
  changeSpeed(Duration duration) {
    speed = duration;
    update();
  }
}

final GeneticAlgo geneticAlgo = Get.put(GeneticAlgo());
