import 'package:flutter/material.dart';

import 'package:ico_open/config/config.dart';
import 'package:ico_open/customer_evaluate/knowledge_test.dart';
import 'package:ico_open/misc/misc.dart' as misc;
import 'package:ico_open/model/model.dart' as model;
import 'package:ico_open/customer_evaluate/agreement.dart';
import 'package:ico_open/customer_evaluate/evaluate.dart';
import 'package:ico_open/customer_evaluate/evaluate_result.dart';
import 'package:ico_open/customer_evaluate/fatca.dart';
import 'package:ico_open/customer_evaluate/bottom.dart';
import 'package:ico_open/model/sute_test.dart';
import 'package:ico_open/questions/fatca_information.dart';
import 'package:ico_open/questions/knowledge_test.dart';
import 'package:ico_open/questions/sute_test.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

// enum CurrentAddress { registered, others }

// const double displayWidth = 0.6;

class CustomerEvaluate extends StatefulWidget {
  final String id;
  const CustomerEvaluate({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _CustomerEvaluateState();
}

enum AnswerEnum { first, second, third, forth }

enum KnowledgeTestEnum { yes, no }

class _CustomerEvaluateState extends State<CustomerEvaluate> {
  double suitableSumPoints = 0;

  bool isFatca_1 = false,
      isFatca_2 = false,
      isFatca_3 = false,
      isFatca_4 = false,
      isFatca_5 = false,
      isFatca_6 = false,
      isFatca_7 = false,
      isFatca_8 = false,
      usPerson = false,
      nonUSPerson = false,
      is4_1checked = false,
      is4_2checked = false,
      is4_3checked = false,
      is4_4checked = false;

  List<String> customerRiskItems = <String>[
    'เสี่ยงต่ำ',
    'เสี่ยงปานกลางค่อนข้างต่ำ',
    'เสี่ยงปานกลางค่อนข้างสูง',
    'เสี่ยงสูง',
    'เสี่ยงสูงมาก',
  ];

  String? riskLevelValue;
  bool riskLevelErrorTestCondition = false;

  AnswerEnum? _firstQuestion;
  AnswerEnum? _secondQuestion;
  AnswerEnum? _thirdQuestion;
  AnswerEnum? _forthQuestion;
  AnswerEnum? _fifthQuestion;
  AnswerEnum? _sixthQuestion;
  AnswerEnum? _seventhQuestion;
  AnswerEnum? _eigthQuestion;
  AnswerEnum? _ninthQuestion;
  AnswerEnum? _tenthQuestion;

  KnowledgeTestEnum? knowledgeTestChoice;

  double convertAnserEnumToInt(AnswerEnum? enumPoint) {
    if (enumPoint != null) {
      if (enumPoint == AnswerEnum.first) {
        return 1;
      }
      if (enumPoint == AnswerEnum.second) {
        return 2;
      }
      if (enumPoint == AnswerEnum.third) {
        return 3;
      }
      if (enumPoint == AnswerEnum.forth) {
        return 4;
      }
    }
    return 0;
  }

  Widget editSuitableEvaluteTextButton() {
    // int questionNumber = 0;
    // final currentSuitQuestion = suiteQuestions[questionNumber];
    return ElevatedButton(
        onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(model.suitableDialogTitle),
                actionsAlignment: MainAxisAlignment.center,
                content: _questionsWidget(suiteQuestions),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        suitableSumPoints =
                            convertAnserEnumToInt(_firstQuestion) +
                                convertAnserEnumToInt(_secondQuestion) +
                                convertAnserEnumToInt(_thirdQuestion) +
                                convertAnserEnumToInt(_forthQuestion) +
                                convertAnserEnumToInt(_fifthQuestion) +
                                convertAnserEnumToInt(_sixthQuestion) +
                                convertAnserEnumToInt(_seventhQuestion) +
                                convertAnserEnumToInt(_eigthQuestion) +
                                convertAnserEnumToInt(_ninthQuestion) +
                                convertAnserEnumToInt(_tenthQuestion);
                      });
                      if (_firstQuestion == null ||
                          _secondQuestion == null ||
                          _thirdQuestion == null ||
                          _forthQuestion == null ||
                          _fifthQuestion == null ||
                          _sixthQuestion == null ||
                          _seventhQuestion == null ||
                          _eigthQuestion == null ||
                          _ninthQuestion == null ||
                          _tenthQuestion == null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text(
                                  'รบกวนทำให้ครบทุกข้อ',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            });
                      } else {
                        Navigator.pop(context, suitableSumPoints);
                      }
                    },
                    child: const Text(
                      'OK',
                    ),
                  ),
                ],
              ),
            ),
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.transparent),
            foregroundColor: MaterialStatePropertyAll(Colors.transparent),
            shadowColor: MaterialStatePropertyAll(Colors.transparent),
            surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
            iconColor: MaterialStatePropertyAll(Colors.transparent)),
        child: const Text(
          model.studyOrEditSuitableLevel,
          style: TextStyle(
              color: Colors.orange, decoration: TextDecoration.underline),
        ));
  }

  Widget _answerListTile(
      SuitQuestion currentQuestion,
      int index,
      AnswerEnum? selectedGroup,
      AnswerEnum selectedAnswer,
      Function(AnswerEnum?) func) {
    return ListTile(
      minLeadingWidth: 0,
      title: Text(
        currentQuestion.answers[index],
        style: const TextStyle(fontSize: 12),
      ),
      leading: Radio<AnswerEnum>(
          value: selectedAnswer, groupValue: selectedGroup, onChanged: func),
    );
  }

  Widget _answerCheckBox(
    bool ischeck,
    Function(bool?) func,
    SuitQuestion currentQuestion,
    int index,
  ) {
    return CheckboxListTile(
      title: Text(currentQuestion.answers[index]),
      value: ischeck,
      onChanged: func,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _knowledgeListTile(String title, KnowledgeTestEnum? selectedGroup,
      KnowledgeTestEnum selectedAnswer, Function(KnowledgeTestEnum?) func) {
    return SizedBox(
        width: 130,
        child: ListTile(
            minLeadingWidth: 0,
            title: Text(title, style: const TextStyle(fontSize: 12)),
            leading: Radio<KnowledgeTestEnum>(
                value: selectedAnswer,
                groupValue: selectedGroup,
                onChanged: func)));
  }

 Widget knowledgeTestExam() {
      if (knowledgeTestChoice == KnowledgeTestEnum.yes) {
        return Column(
          children: [
          Row(children: [Text(knowledgeQuestions[0].text)],),
          Row(children: [
            Text(knowledgeQuestions[0].answers[0]),
            Text(knowledgeQuestions[0].answers[1]),
          ],),
          ]
        );
      } else {
        return const Column();
      }
    }

  Widget _fatcaCheckBox(
    bool ischeck,
    Function(bool?) func,
    List<String> fatcaChoices,
    int index,
  ) {
    return SizedBox(
      height: 30,
      child: CheckboxListTile(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        contentPadding: EdgeInsets.zero,
        title: RichText(
            text: TextSpan(
                text: fatcaChoices[index],
                style: const TextStyle(
                  fontSize: 13,
                  decoration: TextDecoration.none,
                ))),
        // title: Text(
        //   fatcaChoices[index],
        //   style: const TextStyle(
        //     fontSize: 13,
        //     backgroundColor: Colors.transparent,
        //   ),

        // ),
        value: ischeck,
        onChanged: func,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget fatcaInformationChecklist() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(children: [
        // const SizedBox(height: 20,),
        _fatcaCheckBox(isFatca_1, (value) {
          setState(() {
            isFatca_1 = !isFatca_1;
          });
          if (isFatca_1) {
            usPerson = true;
          } else if (isFatca_2) {
            usPerson = true;
          } else if (isFatca_3) {
            usPerson = true;
          } else {
            usPerson = false;
          }
          print('usPerson: $usPerson, $isFatca_1');
        }, fatcaInformations, 0),
        _fatcaCheckBox(isFatca_2, (value) {
          setState(() {
            isFatca_2 = !isFatca_2;
          });
          if (isFatca_1) {
            usPerson = true;
          } else if (isFatca_2) {
            usPerson = true;
          } else if (isFatca_3) {
            usPerson = true;
          } else {
            usPerson = false;
          }
          print('usPerson: $usPerson, $isFatca_2');
        }, fatcaInformations, 1),
        _fatcaCheckBox(isFatca_3, (value) {
          setState(() {
            isFatca_3 = !isFatca_3;
          });
          if (isFatca_1) {
            usPerson = true;
          } else if (isFatca_2) {
            usPerson = true;
          } else if (isFatca_3) {
            usPerson = true;
          } else {
            usPerson = false;
          }
          print('usPerson: $usPerson, $isFatca_3');
        }, fatcaInformations, 2),
        _fatcaCheckBox(isFatca_4, (value) {
          if (!usPerson) {
            setState(() {
              nonUSPerson = true;
            });
          }
          setState(() {
            isFatca_4 = !isFatca_4;
          });
        }, fatcaInformations, 3),
        _fatcaCheckBox(isFatca_5, (value) {
          if (!usPerson) {
            setState(() {
              nonUSPerson = true;
            });
          }
          setState(() {
            isFatca_5 = !isFatca_5;
          });
        }, fatcaInformations, 4),
        _fatcaCheckBox(isFatca_6, (value) {
          if (!usPerson) {
            setState(() {
              nonUSPerson = true;
            });
          }
          setState(() {
            isFatca_6 = !isFatca_6;
          });
        }, fatcaInformations, 5),
        _fatcaCheckBox(isFatca_7, (value) {
          if (!usPerson) {
            setState(() {
              nonUSPerson = true;
            });
          }
          setState(() {
            isFatca_7 = !isFatca_7;
          });
        }, fatcaInformations, 6),
        _fatcaCheckBox(isFatca_8, (value) {
          if (!usPerson) {
            setState(() {
              nonUSPerson = true;
            });
          }
          setState(() {
            isFatca_8 = !isFatca_8;
          });
        }, fatcaInformations, 7),
        const SizedBox(
          height: 10,
        ),
        // Container(
        //     decoration: const BoxDecoration(
        //         borderRadius: BorderRadius.all(Radius.circular(5)),
        //         color: Colors.orange),
        //     child: TextButton(
        //         style: TextButton.styleFrom(
        //             foregroundColor: Colors.white,
        //             padding: const EdgeInsets.all(10)),
        //         onPressed: () {
        //           setState(() => internalWidget = const W9FormTable());
        //           // internalWidget = const W9FormTable();
        //           print('internalWidget: $internalWidget');
        //         },
        //         child: const Text('OK'))),
        // const SizedBox(
        //   height: 10,
        // ),
      ]);
    });
  }

  Widget? internalWidget;
  Widget fatcaInternalWidget() {
    if (internalWidget == null) {
      setState(() {
        internalWidget = fatcaInformationChecklist();
        // internalWidget = Column(
        //   children: [
        //     fatcaInformationChecklist(),
        //     Container(
        //         decoration: const BoxDecoration(
        //             borderRadius: BorderRadius.all(Radius.circular(5)),
        //             color: Colors.orange),
        //         child: TextButton(
        //             style: TextButton.styleFrom(
        //                 foregroundColor: Colors.white,
        //                 padding: const EdgeInsets.all(10)),
        //             onPressed: () {
        //               setState(() {
        //                 internalWidget = const W9FormTable();
        //               });
        //             },
        //             child: const Text('OK'))),
        //     const SizedBox(
        //       height: 10,
        //     ),
        //   ],
        // );
      });
    } else {
      setState(() {
        internalWidget = const W9FormTable();
      });
    }
    // return StatefulBuilder(
    //     builder: (BuildContext context, StateSetter setState) {
    return Column(
      children: [
        internalWidget!,
        Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.orange),
            child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(10)),
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        alignment: Alignment.center,
                        content: W9FormTable(),
                      );
                    }),
                child: const Text('OK'))),
        const SizedBox(
          height: 10,
        ),
      ],
    );
    // });
  }

  Widget _questionsWidget(List<SuitQuestion> suitQuestions) {
    final firstSuitQuestion = suiteQuestions[0];
    final secondSuitQuestion = suiteQuestions[1];
    final thirdSuitQuestion = suiteQuestions[2];
    final forthSuitQuestion = suiteQuestions[3];
    final fifthSuitQuestion = suiteQuestions[4];
    final sixthSuitQuestion = suiteQuestions[5];
    final seventhSuitQuestion = suiteQuestions[6];
    final eigthSuitQuestion = suiteQuestions[7];
    final ninthSuitQuestion = suiteQuestions[8];
    final tenthSuitQuestion = suiteQuestions[9];
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(firstSuitQuestion.text,
                  style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  _answerListTile(
                      firstSuitQuestion, 0, _firstQuestion, AnswerEnum.first,
                      (value) {
                    setState(() {
                      _firstQuestion = value;
                    });
                  }),
                  _answerListTile(
                      firstSuitQuestion, 1, _firstQuestion, AnswerEnum.second,
                      (value) {
                    setState(() {
                      _firstQuestion = value;
                    });
                  }),
                  _answerListTile(
                      firstSuitQuestion, 2, _firstQuestion, AnswerEnum.third,
                      (value) {
                    setState(() {
                      _firstQuestion = value;
                    });
                  }),
                  _answerListTile(
                      firstSuitQuestion, 3, _firstQuestion, AnswerEnum.forth,
                      (value) {
                    setState(() {
                      _firstQuestion = value;
                    });
                  }),
                ],
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(secondSuitQuestion.text,
                  style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  _answerListTile(
                      secondSuitQuestion, 0, _secondQuestion, AnswerEnum.first,
                      (value) {
                    setState(() {
                      _secondQuestion = value;
                    });
                  }),
                  _answerListTile(
                      secondSuitQuestion, 1, _secondQuestion, AnswerEnum.second,
                      (value) {
                    setState(() {
                      _secondQuestion = value;
                    });
                  }),
                  _answerListTile(
                      secondSuitQuestion, 2, _secondQuestion, AnswerEnum.third,
                      (value) {
                    setState(() {
                      _secondQuestion = value;
                    });
                  }),
                  _answerListTile(
                      secondSuitQuestion, 3, _secondQuestion, AnswerEnum.forth,
                      (value) {
                    setState(() {
                      _secondQuestion = value;
                    });
                  }),
                ],
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(thirdSuitQuestion.text,
                  style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  _answerListTile(
                      thirdSuitQuestion, 0, _thirdQuestion, AnswerEnum.first,
                      (value) {
                    setState(() {
                      _thirdQuestion = value;
                    });
                  }),
                  _answerListTile(
                      thirdSuitQuestion, 1, _thirdQuestion, AnswerEnum.second,
                      (value) {
                    setState(() {
                      _thirdQuestion = value;
                    });
                  }),
                  _answerListTile(
                      thirdSuitQuestion, 2, _thirdQuestion, AnswerEnum.third,
                      (value) {
                    setState(() {
                      _thirdQuestion = value;
                    });
                  }),
                  _answerListTile(
                      thirdSuitQuestion, 3, _thirdQuestion, AnswerEnum.forth,
                      (value) {
                    setState(() {
                      _thirdQuestion = value;
                    });
                  }),
                ],
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(forthSuitQuestion.text,
                  style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  _answerCheckBox(is4_1checked, (value) {
                    if (!(is4_2checked || is4_3checked || is4_4checked)) {
                      setState(() {
                        _forthQuestion = AnswerEnum.first;
                      });
                    }
                    setState(() {
                      is4_1checked = !is4_1checked;
                    });
                  }, forthSuitQuestion, 0),
                  _answerCheckBox(is4_2checked, (value) {
                    if (!(is4_3checked || is4_4checked)) {
                      setState(() {
                        _forthQuestion = AnswerEnum.second;
                      });
                    }
                    setState(() {
                      is4_2checked = !is4_2checked;
                    });
                  }, forthSuitQuestion, 0),
                  _answerCheckBox(is4_3checked, (value) {
                    if (!is4_4checked) {
                      setState(() {
                        _forthQuestion = AnswerEnum.third;
                      });
                    }
                    setState(() {
                      is4_3checked = !is4_3checked;
                    });
                  }, forthSuitQuestion, 0),
                  _answerCheckBox(is4_4checked, (value) {
                    setState(() {
                      _forthQuestion = AnswerEnum.forth;
                      is4_4checked = !is4_4checked;
                    });
                  }, forthSuitQuestion, 3),
                ],
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(fifthSuitQuestion.text,
                  style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  _answerListTile(
                      fifthSuitQuestion, 0, _fifthQuestion, AnswerEnum.first,
                      (value) {
                    setState(() {
                      _fifthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      fifthSuitQuestion, 1, _fifthQuestion, AnswerEnum.second,
                      (value) {
                    setState(() {
                      _fifthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      fifthSuitQuestion, 2, _fifthQuestion, AnswerEnum.third,
                      (value) {
                    setState(() {
                      _fifthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      fifthSuitQuestion, 3, _fifthQuestion, AnswerEnum.forth,
                      (value) {
                    setState(() {
                      _fifthQuestion = value;
                    });
                  }),
                ],
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(sixthSuitQuestion.text,
                  style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  _answerListTile(
                      sixthSuitQuestion, 0, _sixthQuestion, AnswerEnum.first,
                      (value) {
                    setState(() {
                      _sixthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      sixthSuitQuestion, 1, _sixthQuestion, AnswerEnum.second,
                      (value) {
                    setState(() {
                      _sixthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      sixthSuitQuestion, 2, _sixthQuestion, AnswerEnum.third,
                      (value) {
                    setState(() {
                      _sixthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      sixthSuitQuestion, 3, _sixthQuestion, AnswerEnum.forth,
                      (value) {
                    setState(() {
                      _sixthQuestion = value;
                    });
                  }),
                ],
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(seventhSuitQuestion.text,
                  style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  _answerListTile(seventhSuitQuestion, 0, _seventhQuestion,
                      AnswerEnum.first, (value) {
                    setState(() {
                      _seventhQuestion = value;
                    });
                  }),
                  _answerListTile(seventhSuitQuestion, 1, _seventhQuestion,
                      AnswerEnum.second, (value) {
                    setState(() {
                      _seventhQuestion = value;
                    });
                  }),
                  _answerListTile(seventhSuitQuestion, 2, _seventhQuestion,
                      AnswerEnum.third, (value) {
                    setState(() {
                      _seventhQuestion = value;
                    });
                  }),
                  _answerListTile(seventhSuitQuestion, 3, _seventhQuestion,
                      AnswerEnum.forth, (value) {
                    setState(() {
                      _seventhQuestion = value;
                    });
                  }),
                ],
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(eigthSuitQuestion.text,
                  style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  _answerListTile(
                      eigthSuitQuestion, 0, _eigthQuestion, AnswerEnum.first,
                      (value) {
                    setState(() {
                      _eigthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      eigthSuitQuestion, 1, _eigthQuestion, AnswerEnum.second,
                      (value) {
                    setState(() {
                      _eigthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      eigthSuitQuestion, 2, _eigthQuestion, AnswerEnum.third,
                      (value) {
                    setState(() {
                      _eigthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      eigthSuitQuestion, 3, _eigthQuestion, AnswerEnum.forth,
                      (value) {
                    setState(() {
                      _eigthQuestion = value;
                    });
                  }),
                ],
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(ninthSuitQuestion.text,
                  style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  _answerListTile(
                      ninthSuitQuestion, 0, _ninthQuestion, AnswerEnum.first,
                      (value) {
                    setState(() {
                      _ninthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      ninthSuitQuestion, 1, _ninthQuestion, AnswerEnum.second,
                      (value) {
                    setState(() {
                      _ninthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      ninthSuitQuestion, 2, _ninthQuestion, AnswerEnum.third,
                      (value) {
                    setState(() {
                      _ninthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      ninthSuitQuestion, 3, _ninthQuestion, AnswerEnum.forth,
                      (value) {
                    setState(() {
                      _ninthQuestion = value;
                    });
                  }),
                ],
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(tenthSuitQuestion.text,
                  style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  _answerListTile(
                      tenthSuitQuestion, 0, _tenthQuestion, AnswerEnum.first,
                      (value) {
                    setState(() {
                      _tenthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      tenthSuitQuestion, 1, _tenthQuestion, AnswerEnum.second,
                      (value) {
                    setState(() {
                      _tenthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      tenthSuitQuestion, 2, _tenthQuestion, AnswerEnum.third,
                      (value) {
                    setState(() {
                      _tenthQuestion = value;
                    });
                  }),
                  _answerListTile(
                      tenthSuitQuestion, 3, _tenthQuestion, AnswerEnum.forth,
                      (value) {
                    setState(() {
                      _tenthQuestion = value;
                    });
                  }),
                ],
              )),
        ]),
      );
    });
  }

  Widget sutableCircularProgressBar(double suitableSumPoints) {
    return SimpleCircularProgressBar(
      progressStrokeWidth: 10,
      progressColors: const [Colors.orange],
      backStrokeWidth: 10,
      backColor: Colors.grey,
      maxValue: 46,
      // valueNotifier: ValueNotifier(10),
      valueNotifier: ValueNotifier(suitableSumPoints),
      mergeMode: true,
      onGetText: (double value) {
        return Text(
          '${value.toInt()}',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // currentQuestion = suiteQuestions[0];
    final userid = widget.id;
    double height = 50;

    Widget doKnowledgeNow = _knowledgeListTile(
        'ทำตอนนี้', knowledgeTestChoice, KnowledgeTestEnum.yes, (value) {
      setState(() {
        knowledgeTestChoice = value;
      });
    });
    Widget doKnowledgeAfter = _knowledgeListTile(
        'ภายหลัง', knowledgeTestChoice, KnowledgeTestEnum.no, (value) {
      if (knowledgeTestChoice == KnowledgeTestEnum.yes || knowledgeTestChoice == null) {
        setState(() {
          knowledgeTestChoice = value;
        });
      }
    });

   

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              HighSpace(height: height),
              const CustomerEvaluateHeader(),
              HighSpace(height: height),
              misc.containerWidget(
                  misc.dropdownButtonBuilderFunction(
                      value: riskLevelValue,
                      itemHeight: 50,
                      label1: model.pleaseSelectedYourRiskLevel,
                      label2: '',
                      items: customerRiskItems,
                      condition: riskLevelErrorTestCondition,
                      onChanged: (value) {
                        if (value == customerRiskItems[0]) {
                          setState(() {
                            _firstQuestion = AnswerEnum.first;
                            _secondQuestion = AnswerEnum.first;
                            _thirdQuestion = AnswerEnum.first;
                            _forthQuestion = AnswerEnum.first;
                            _fifthQuestion = AnswerEnum.first;
                            _sixthQuestion = AnswerEnum.first;
                            _seventhQuestion = AnswerEnum.first;
                            _eigthQuestion = AnswerEnum.first;
                            _ninthQuestion = AnswerEnum.first;
                            _tenthQuestion = AnswerEnum.first;
                          });
                        }
                        if (value == customerRiskItems[1]) {
                          setState(() {
                            _firstQuestion = AnswerEnum.second;
                            _secondQuestion = AnswerEnum.second;
                            _thirdQuestion = AnswerEnum.second;
                            _forthQuestion = AnswerEnum.second;
                            _fifthQuestion = AnswerEnum.second;
                            _sixthQuestion = AnswerEnum.second;
                            _seventhQuestion = AnswerEnum.second;
                            _eigthQuestion = AnswerEnum.second;
                            _ninthQuestion = AnswerEnum.second;
                            _tenthQuestion = AnswerEnum.second;
                          });
                        }
                        if (value == customerRiskItems[2]) {
                          setState(() {
                            _firstQuestion = AnswerEnum.third;
                            _secondQuestion = AnswerEnum.third;
                            _thirdQuestion = AnswerEnum.third;
                            _forthQuestion = AnswerEnum.third;
                            _fifthQuestion = AnswerEnum.third;
                            _sixthQuestion = AnswerEnum.third;
                            _seventhQuestion = AnswerEnum.third;
                            _eigthQuestion = AnswerEnum.third;
                            _ninthQuestion = AnswerEnum.third;
                            _tenthQuestion = AnswerEnum.first;
                          });
                        }
                        if (value == customerRiskItems[3]) {
                          setState(() {
                            _firstQuestion = AnswerEnum.third;
                            _secondQuestion = AnswerEnum.third;
                            _thirdQuestion = AnswerEnum.third;
                            _forthQuestion = AnswerEnum.third;
                            _fifthQuestion = AnswerEnum.third;
                            _sixthQuestion = AnswerEnum.third;
                            _seventhQuestion = AnswerEnum.third;
                            _eigthQuestion = AnswerEnum.third;
                            _ninthQuestion = AnswerEnum.third;
                            _tenthQuestion = AnswerEnum.third;
                          });
                        }
                        if (value == customerRiskItems[4]) {
                          setState(() {
                            _firstQuestion = AnswerEnum.forth;
                            _secondQuestion = AnswerEnum.forth;
                            _thirdQuestion = AnswerEnum.forth;
                            _forthQuestion = AnswerEnum.forth;
                            _fifthQuestion = AnswerEnum.forth;
                            _sixthQuestion = AnswerEnum.forth;
                            _seventhQuestion = AnswerEnum.forth;
                            _eigthQuestion = AnswerEnum.forth;
                            _ninthQuestion = AnswerEnum.forth;
                            _tenthQuestion = AnswerEnum.forth;
                          });
                        }
                        setState(() {
                          riskLevelValue = value;
                          suitableSumPoints =
                              convertAnserEnumToInt(_firstQuestion) +
                                  convertAnserEnumToInt(_secondQuestion) +
                                  convertAnserEnumToInt(_thirdQuestion) +
                                  convertAnserEnumToInt(_forthQuestion) +
                                  convertAnserEnumToInt(_fifthQuestion) +
                                  convertAnserEnumToInt(_sixthQuestion) +
                                  convertAnserEnumToInt(_seventhQuestion) +
                                  convertAnserEnumToInt(_eigthQuestion) +
                                  convertAnserEnumToInt(_ninthQuestion) +
                                  convertAnserEnumToInt(_tenthQuestion);
                        });
                        print(suitableSumPoints);
                      },
                      errorText: misc.thErrorDropdownMessage(
                          model.pleaseSelectedYourRiskLevel)),
                  editSuitableEvaluteTextButton(),
                  paddingValue,
                  displayWidth,
                  context),
              HighSpace(height: height),
              CustomerEvaluateResults(points: suitableSumPoints),
              HighSpace(height: height),
              CustomerFATCA(
                fatcaInformationWidget: fatcaInternalWidget(),
                usPerson: usPerson,
              ),
              HighSpace(height: height),
              // CustomerEvaluateAdvisors(),
              KnowledgeTestWidget(widget1: doKnowledgeNow, widget2: doKnowledgeAfter, widget3: knowledgeTestExam(),),
              HighSpace(height: height),
              const CustomerAgreement(),
              const HighSpace(height: 50),
              CustomerEvaluateBottom(id: userid),
              HighSpace(height: height),
            ],
          ),
        ),
      ),
    );
  }
}

class HighSpace extends StatelessWidget {
  const HighSpace({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class CustomerEvaluateHeader extends StatelessWidget {
  const CustomerEvaluateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * displayWidth,
      padding: const EdgeInsets.all(pagePaddingValue),
      decoration: BoxDecoration(
          color: Colors.lightGreen.withOpacity(
            .3,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: const Text(
        'ประเมินความเหมาะสมในการลงทุน',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
