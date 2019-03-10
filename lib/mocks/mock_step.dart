import 'package:the_cookbook/models/step.dart';

class MockStep extends Step {

  static final List<Step> steps = [
    Step(
      id: 0,
      title: "Paso 1",
      description: "Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo. Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.Preparamos sobre la mesa todos los ingredientes que vamos a necesitar para esta receta de conejo.",
      photo: "https://t1.rg.ltmcdn.com/es/images/9/8/1/img_conejo_al_horno_con_patatas_56189_paso_0_600.jpg"
    ),
    Step(
      id: 1,
      title: "Paso 2",
      description: "En una fuente ponemos el conejo en crudo con el vino blanco, laurel, sal, pimienta y las finas hierbas.",
      photo: "https://t2.rg.ltmcdn.com/es/images/9/8/1/img_conejo_al_horno_con_patatas_56189_paso_1_600.jpg"
    ),
    Step(
      id: 2,
      title: "Paso 3",
      description: "Cortamos las patatas, las echamos por encima del resto de los ingredientes y lo bañamos con el aceite. Lo dejamos macerar durante una hora y poco antes se pondrá el horno a precalentar a 200ºC.",
      photo: "https://t1.rg.ltmcdn.com/es/images/9/8/1/img_conejo_al_horno_con_patatas_56189_paso_2_600.jpg"
    ),
    Step(
      id: 3,
      title: "Paso 4",
      description: "Metemos la fuente durante media hora en el horno y después daremos la vuelta al conejo y lo tendremos 10-15 minutos más.",
      photo: "https://t2.rg.ltmcdn.com/es/images/9/8/1/img_conejo_al_horno_con_patatas_56189_paso_3_600.jpg"
    ),
    Step(
      id: 4,
      title: "Paso 5",
      description: "Como veis este es el resultado, más fácil imposible ¡y rico como pocos! Y después del conejo al horno con patatas, ¿qué te parece una macedonia de frutas con gelatina? ¡A los niños les encantará!",
      photo: "https://t1.rg.ltmcdn.com/es/images/9/8/1/img_conejo_al_horno_con_patatas_56189_paso_4_600.jpg"
    ),
  ];

  static List<Step> FetchAll(){
    return steps;
  }

}