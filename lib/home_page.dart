import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tarea_individual/const.dart';
import 'package:tarea_individual/utils/my_button.dart';
import 'package:tarea_individual/utils/result_message.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //lista de numeros
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
  ];

  //numero A Y B
  int numberA = 1;
  int numberB = 1;

  //Respuestas de usuario
  String userAnswer = '';
  //el usduario cuando presiona el boton
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        //Calcular las respuesta si es correcta o incorrecta
        CheckResult();
      }

      //limpiar la entrada
      else if (button == 'C') {
        userAnswer = '';
      }
      //eliminar el anterior
      else if (button == 'DEL') {
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      }
      //MAXIMO DE 3 NUMEROS QUE PUEDEN SER ESCRITOS
      else if (userAnswer.length < 3) {
        userAnswer += button;
      }
    });
  }

  // Comprobador de respuestas
  void CheckResult() {
    if (numberA + numberB == int.parse(userAnswer)) {
      showDialog(
          context: context,
          builder: (context) {
            return ResultMessage(
                message: 'CORRECT!!',
                onTap: goToNextQuestion,
                icon: Icons.arrow_forward);
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return ResultMessage(
                message: 'INCORRECT!!',
                onTap: goBackToQuestion,
                icon: Icons.rotate_left);
          });
    }
  }
  //Crear numeros aleatorios

  var randomNumber = Random();
//metodo de ir a la siguiente pregunta
  void goToNextQuestion() {
    Navigator.of(context).pop();
    //Restablecer los valores
    setState(() {
      userAnswer = '';
    });
    //Crear una nueva pregunta
    numberA = randomNumber.nextInt(10);
    numberB = randomNumber.nextInt(10);
  }

  //regresar a la pregunta
  void goBackToQuestion() {
    //Quitar la ventana de correcto
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: Column(
        children: [
          //Nivel de progreso,el jugador necesita 5 respuestas correctas en una fila para continuar al siguiente  nivel

          Container(
            height: 160,
            color: Colors.deepPurple,
          ),

          //Pregunta
          Expanded(
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //pregunta
                    Text(
                      numberA.toString() + '+' + numberB.toString() + '=',
                      style: whiteTextStyle,
                    ),

                    //Caja de respuesta

                    Container(
                      height: 80,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[400],
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          userAnswer,
                          style: whiteTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          //numero
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                    itemCount: numberPad.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemBuilder: (context, index) {
                      return MyButton(
                        child: numberPad[index],
                        onTap: () => buttonTapped(numberPad[index]),
                      );
                    }),
              )),
        ],
      ),
    );
  }
}
