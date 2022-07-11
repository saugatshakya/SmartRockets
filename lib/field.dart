import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_rockets/models/genetic_algo.dart';
import 'package:vector_math/vector_math.dart';

class Field extends StatefulWidget {
  const Field({Key? key}) : super(key: key);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  @override
  void initState() {
    super.initState();
    geneticAlgo.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GeneticAlgo>(
          init: geneticAlgo,
          builder: (state) {
            return Center(
              child: Container(
                width: Get.width,
                height: Get.height,
                color: const Color(0xff000000),
                child: Stack(
                  children: [
                    Positioned(
                        top: 16,
                        left: Get.width / 2 - 8,
                        child: Container(
                          width: 16,
                          height: 16,
                          color: const Color(0xffffffff),
                        )),
                    for (int i = 0; i < state.rockets.length; i++)
                      Positioned(
                          top: state.rockets[i].currentPos.y - 32,
                          left: state.rockets[i].currentPos.x - 16,
                          child: Transform.rotate(
                              angle:
                                  state.rockets[i].previousPos == Vector2.zero()
                                      ? 0
                                      : -atan2(
                                          state.rockets[i].previousPos.x -
                                              state.rockets[i].currentPos.x,
                                          state.rockets[i].previousPos.y -
                                              state.rockets[i].currentPos.y,
                                        ),
                              child: Opacity(
                                opacity: 0.4,
                                child: Container(
                                  width: 32,
                                  height: 64,
                                  alignment: Alignment.bottomCenter,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assets/rocket.png"),
                                          fit: BoxFit.cover)),
                                ),
                              ))),
                    Text(
                      "Generation: ${state.generation}      Total LifeSpan: ${state.lifeSpan}/${state.life}",
                      style: const TextStyle(color: Color(0xffffffff)),
                    ),
                    Positioned(
                      top: Get.height * 0.7,
                      left: 0,
                      child: Container(
                        width: Get.width * 0.6,
                        height: 2,
                        color: const Color(0xffffffff),
                      ),
                    ),
                    Positioned(
                      top: Get.height * 0.2,
                      left: Get.width * 0.4,
                      child: Container(
                        width: Get.width * 0.6,
                        height: 2,
                        color: const Color(0xffffffff),
                      ),
                    ),
                    Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(children: [
                          const Text(
                            "Speed",
                            style: TextStyle(color: Color(0xffffffff)),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (state.speed !=
                                  const Duration(milliseconds: 100)) {
                                state.changeSpeed(
                                    const Duration(milliseconds: 100));
                              }
                            },
                            child: Container(
                              width: 64,
                              height: 32,
                              color: state.speed ==
                                      const Duration(milliseconds: 100)
                                  ? const Color(0xff123456)
                                  : const Color(0xffffffff),
                              child: Center(
                                  child: Text(
                                "x1",
                                style: TextStyle(
                                    color: state.speed ==
                                            const Duration(milliseconds: 100)
                                        ? const Color(0xffffffff)
                                        : const Color(0xff000000)),
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (state.speed !=
                                  const Duration(milliseconds: 10)) {
                                state.changeSpeed(
                                    const Duration(milliseconds: 10));
                              }
                            },
                            child: Container(
                              width: 64,
                              height: 32,
                              color: state.speed ==
                                      const Duration(milliseconds: 10)
                                  ? const Color(0xff123456)
                                  : const Color(0xffffffff),
                              child: Center(
                                  child: Text(
                                "x10",
                                style: TextStyle(
                                    color: state.speed ==
                                            const Duration(milliseconds: 10)
                                        ? const Color(0xffffffff)
                                        : const Color(0xff000000)),
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (state.speed !=
                                  const Duration(milliseconds: 1)) {
                                state.changeSpeed(
                                    const Duration(milliseconds: 1));
                              }
                            },
                            child: Container(
                              width: 64,
                              height: 32,
                              color:
                                  state.speed == const Duration(milliseconds: 1)
                                      ? const Color(0xff123456)
                                      : const Color(0xffffffff),
                              child: Center(
                                  child: Text(
                                "x100",
                                style: TextStyle(
                                    color: state.speed ==
                                            const Duration(milliseconds: 1)
                                        ? const Color(0xffffffff)
                                        : const Color(0xff000000)),
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (state.speed !=
                                  const Duration(microseconds: 100)) {
                                state.changeSpeed(
                                    const Duration(microseconds: 100));
                              }
                            },
                            child: Container(
                              width: 64,
                              height: 32,
                              color: state.speed ==
                                      const Duration(microseconds: 100)
                                  ? const Color(0xff123456)
                                  : const Color(0xffffffff),
                              child: Center(
                                  child: Text(
                                "x1000",
                                style: TextStyle(
                                    color: state.speed ==
                                            const Duration(microseconds: 100)
                                        ? const Color(0xffffffff)
                                        : const Color(0xff000000)),
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (geneticAlgo.pause) {
                                geneticAlgo.resumeSimulation();
                              } else {
                                geneticAlgo.pauseANDplay();
                              }
                              print(geneticAlgo.pause);
                            },
                            child: Container(
                              width: 64,
                              height: 32,
                              color: const Color(0xffffffff),
                              child: Center(
                                  child: Text(
                                state.pause ? "Start" : "Pause",
                                style: const TextStyle(
                                    color: const Color(0xff000000)),
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              geneticAlgo.reset();
                            },
                            child: Container(
                              width: 64,
                              height: 32,
                              color: const Color(0xffffffff),
                              child: const Center(
                                  child: Text(
                                "Reset",
                                style:
                                    TextStyle(color: const Color(0xff000000)),
                              )),
                            ),
                          )
                        ])),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
