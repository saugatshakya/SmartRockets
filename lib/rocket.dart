import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class Rocket extends StatefulWidget {
  final List<Vector2>? genes;
  const Rocket({
    Key? key,
    this.genes,
  }) : super(key: key);

  @override
  State<Rocket> createState() => _RocketState();
}

class _RocketState extends State<Rocket> {
  Vector2 previousPos = Vector2.zero();
  Vector2 currentPos = Vector2(300, 584);
  Vector2 vel = Vector2.zero();
  Vector2 acc = Vector2.zero();
  List<Vector2> genes = [];
  late Timer timer;
  final int lifeSpan = 200;
  int life = 0;
  Vector2 target = Vector2(300, 10);

  applyForce(force) {
    acc.add(force);
    setState(() {});
  }

  update() {
    applyForce(genes[life]);
    vel.add(acc);
    previousPos = currentPos.clone();
    currentPos.add(vel);
    acc.setZero();
    setState(() {});
    if (life >= lifeSpan) {
      life = 0;
    }
  }

  createGenes() {
    for (int i = 0; i < lifeSpan; i++) {
      genes.add(Vector2(
          (Random().nextInt(10) - 5) * 1.0, Random().nextInt(4) * -1.0));
    }
  }

  @override
  void initState() {
    if (widget.genes == null) {
      createGenes();
    } else {
      genes = widget.genes!;
    }
    update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: currentPos.y - 32,
        left: currentPos.x - 16,
        child: Transform.rotate(
            angle: -atan2(
              previousPos.x - currentPos.x,
              previousPos.y - currentPos.y,
            ),
            child: Container(
              width: 32,
              height: 64,
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/rocket.png"),
                      fit: BoxFit.cover)),
              // child: Text(
              //   life.toString(),
              //   style: const TextStyle(color: Color(0xffffffff)),
              // ),
            )));
  }
}
