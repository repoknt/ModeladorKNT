import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knt_kitchen_app/paginas/EsquemaRegalosPage.dart';

final user = FirebaseAuth.instance.currentUser!;

class ModeladorRoyal extends StatefulWidget {
  const ModeladorRoyal({Key? key}) : super(key: key);

  @override
  State<ModeladorRoyal> createState() => _ModeladorRoyalState();
}

class _ModeladorRoyalState extends State<ModeladorRoyal> {
  List<List<String>> allDatos = [[]];
  List<String?> valorSeleccionado = [null];
  List<String?> preciosComerciales = [null];
  List<int> preciosSeleccionados = [0];
  List<int> preciosSeleccionados2 = [0];
  List<String?> precios = [null];
  List<int> preciosMinimos = [0];
  List<int> preciosMaximos = [0];
  List<String?> minimo = [null];
  late QuerySnapshot querySnapshot;
  bool datosCargados = false;
  int diferencia = 0;
  double regaloIdeal = 0;
  List<String> productosSinSet = [];
  List<int> valoresPredefinidos = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
  int valorSeleccionadoPredefinido = 0;
  String? valorSeleccionadoPromocion;
  bool promocionSeleccionada = false;
  bool mostrarDropdown = false;

  @override
  void initState() {
    super.initState();
    obtenerDatos();
  }

  Future<void> obtenerDatos() async {
    querySnapshot =
        await FirebaseFirestore.instance.collection('productos_royal').get();
    List<String> datos = ['Selecciona producto'];
    datos.addAll(
        querySnapshot.docs.map<String>((doc) => doc.get('producto')).toList());
    List<int> nuevosPrecios = querySnapshot.docs
        .map<int>((doc) => doc.get('precio_comercial'))
        .toList();
    List<int> precioRoyal =
        querySnapshot.docs.map<int>((doc) => doc.get('precio')).toList();
    List<int> preciosMin =
        querySnapshot.docs.map<int>((doc) => doc.get('minimo')).toList();
    List<int> preciosMax =
        querySnapshot.docs.map<int>((doc) => doc.get('maximo')).toList();

    productosSinSet = querySnapshot.docs
        .map<String>((doc) => doc.get('producto'))
        .where((producto) => !producto.toLowerCase().contains('set'))
        .toList();
    productosSinSet.insert(0, 'Selecciona producto');

    setState(() {
      allDatos = [datos];
      valorSeleccionado = [datos.isNotEmpty ? datos[0] : null];
      preciosComerciales = [null];
      precios = [null];
      minimo = [null];
      preciosSeleccionados = [0];
      preciosSeleccionados2 = [0];
      preciosMinimos = [0];
      preciosMaximos = [0];
      datosCargados = true;
      bool promocionSeleccionada = false;
    });
  }

  void agregarListaDesplegable() async {
    QuerySnapshot newQuerySnapshot =
        await FirebaseFirestore.instance.collection('productos_royal').get();
        
    List<String> datos = ['Selecciona producto'];
    datos.addAll(newQuerySnapshot.docs
        .map<String>((doc) => doc.get('producto'))
        .toList());
    List<int> nuevosPrecios = newQuerySnapshot.docs
        .map<int>((doc) => doc.get('precio_comercial'))
        .toList();
    List<int> precioRoyal =
        querySnapshot.docs.map<int>((doc) => doc.get('precio')).toList();
    List<int> preciosMin =
        querySnapshot.docs.map<int>((doc) => doc.get('minimo')).toList();
    List<int> preciosMax =
        querySnapshot.docs.map<int>((doc) => doc.get('maximo')).toList();

    setState(() {
      allDatos.add(datos);
      valorSeleccionado.add(datos.isNotEmpty ? datos[0] : null);
      preciosComerciales.add(null);
      precios.add(null);

      preciosSeleccionados.add(0);
      preciosSeleccionados2.add(0);
      preciosMinimos.add(0);
      preciosMaximos.add(0);
      valorSeleccionadoPromocion = null;
      actualizarPrecioComercial(allDatos.length - 1, null);
    });
  }

  void eliminarListaDesplegable(int index) {
    setState(() {
      if (allDatos.length > 1) {
        allDatos.removeAt(index);
        valorSeleccionado.removeAt(index);
        preciosComerciales.removeAt(index);
        precios.removeAt(index);
        preciosSeleccionados.removeAt(index);
        preciosSeleccionados2.removeAt(index);
        preciosMinimos.removeAt(index);
        preciosMaximos.removeAt(index);
        regaloIdeal = calcularRegaloIdeal();
        int sumaPreciosComerciales =
            preciosSeleccionados.reduce((a, b) => a + b);
        int sumaPrecios = preciosSeleccionados2.reduce((a, b) => a + b);
        diferencia = sumaPreciosComerciales - sumaPrecios;
      }
    });
  }

  void actualizarPrecioComercial(int index, String? newValue) {
    if (newValue == 'Selecciona producto') {
      setState(() {
        preciosComerciales[index] = null;
        preciosSeleccionados[index] = 0;
        preciosSeleccionados2[index] = 0;
        regaloIdeal = 0;
        preciosMaximos[index] = 0;
        preciosMinimos[index] = 0;
      });
      return;
    }

    int precioComercial = preciosSeleccionados[0] ?? 0;
    int precio = preciosSeleccionados2[0] ?? 0;
    int preciosMinimo = preciosMinimos[0] ?? 0;
    int preciosMaximo = preciosMaximos[0] ?? 0;

    for (var doc in querySnapshot.docs) {
      if (doc.get('producto') == newValue) {
        precioComercial = doc.get('precio_comercial') ?? 0;
        precio = doc.get('precio') ?? 0;
        preciosMinimo = doc.get('minimo') ?? 0;
        preciosMaximo = doc.get('maximo') ?? 0;

        break;
      }
    }

    setState(() {
      preciosComerciales[index] = precioComercial.toString();
      preciosSeleccionados[index] = precioComercial;
      precios[index] = precio.toString();
      preciosSeleccionados2[index] = precio;
      preciosMinimos[index] = preciosMinimo;
      preciosMaximos[index] = preciosMaximo;

      int sumaPreciosComerciales = preciosSeleccionados.reduce((a, b) => a + b);
      int sumaPrecios = preciosSeleccionados2.reduce((a, b) => a + b);
      diferencia = sumaPreciosComerciales - sumaPrecios;

      regaloIdeal = calcularRegaloIdeal();
    });
  }

  double calcularRegaloIdeal() {
    int sumaPreciosSeleccionados2 =
        preciosSeleccionados2.reduce((a, b) => a + b);
    double regaloIdeal = (sumaPreciosSeleccionados2 / 1.16) * 0.2;
    return regaloIdeal;
  }

  





void _continuar() {
  // Obtén los valores que deseas enviar a la siguiente página
  final preciosComercialesTotal = preciosSeleccionados.reduce((a, b) => a + b);
  final preciosRoyalTotal = preciosSeleccionados2.reduce((a, b) => a + b);
  final diferenciaTotal = diferencia;
  final regaloIdealTotal = regaloIdeal;
  final preciosMinimosTotal = preciosMinimos.reduce((a, b) => a + b);
  final preciosMaximosTotal = preciosMaximos.reduce((a, b) => a + b);
  final precioMinimoRoyaTotal = preciosMinimos.reduce((a, b) => a + b) + diferencia;
 final precioMaximoRoyalTotal= preciosMaximos.reduce((a, b) => a + b) + diferencia;
  // Navega a la página EsquemaRegalosPage y pasa los valores como argumentos
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EsquemaRegalosPage(
        preciosComerciales: preciosComercialesTotal,
        preciosRoyal: preciosRoyalTotal,
        diferencia: diferenciaTotal,
        regaloIdeal: regaloIdealTotal,
        preciosMinimos: preciosMinimosTotal,
        preciosMaximos: preciosMaximosTotal,
        RegaloMinRoyalCVitrex:precioMinimoRoyaTotal,
        RegaloMaxRoyalCVitrex:precioMaximoRoyalTotal,

      ),
    ),
  );
}











  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: Center(child: Text(user.email!)),
        leading: Image.asset(
          'assets/img/knt.png',
          width: 200.0,
          height: 200.0,
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Modelador Royal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Realiza la cotización',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            if (allDatos.isEmpty)
              Text(
                'No hay datos disponibles',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              )
            else



















              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allDatos.length,
                itemBuilder: (context, index) {
                  if (allDatos.isEmpty) {
                    return Text(
                      'No hay datos disponibles',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    );
                  }
                  return Row(
                    children: [  
                      Expanded( 
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton<String?>(
                              value: valorSeleccionado[index],
                              items: allDatos[index].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  
                                );
                                
                              }).toList(),
                              onChanged: (String? newValue) {
                                
                                actualizarPrecioComercial(index, newValue);
                                setState(() {
                                  valorSeleccionado[index] = newValue;
                                });
                              },
                              
                              dropdownColor: Colors.black,
                              isExpanded: true,
                              style: TextStyle(color: Colors.white), // Personalizar estilo del texto en la lista desplegable
                              icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Personalizar ícono de la lista desplegable
                            ),
                            
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          eliminarListaDesplegable(index);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                  
                },
              ),
            SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: agregarListaDesplegable,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Agregar nuevo producto',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),


            
            SizedBox(height: 40),











          Container(
  decoration: BoxDecoration(
    color: Colors.black,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.all(16), 
 child: Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), // Fondo de la fila
              borderRadius: BorderRadius.circular(5), // Bordes redondeados
            ),
            padding: EdgeInsets.all(10), // Espaciado interno
            child: Text(
              'Precios Comerciales',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              '\$${preciosSeleccionados.reduce((a, b) => a + b)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
    Divider(color: Colors.white),
    SizedBox(height: 5),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), // Fondo de la fila
              borderRadius: BorderRadius.circular(5), // Bordes redondeados
            ),
            padding: EdgeInsets.all(10), // Espaciado interno
            child: Text(
              'Precio Royal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              '\$${preciosSeleccionados2.reduce((a, b) => a + b)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
    Divider(color: Colors.white),
    SizedBox(height: 5),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), // Fondo de la fila
              borderRadius: BorderRadius.circular(5), // Bordes redondeados
            ),
            padding: EdgeInsets.all(10), // Espaciado interno
            child: Text(
              'Diferencia',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              '\$$diferencia',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
    Divider(color: Colors.white),
    SizedBox(height: 5),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), // Fondo de la fila
              borderRadius: BorderRadius.circular(5), // Bordes redondeados
            ),
            padding: EdgeInsets.all(10), // Espaciado interno
            child: Text(
              'Regalo ideal 20%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              '\$${regaloIdeal.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
    Divider(color: Colors.white),
    SizedBox(height: 5),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), // Fondo de la fila
              borderRadius: BorderRadius.circular(5), // Bordes redondeados
            ),
            padding: EdgeInsets.all(10), // Espaciado interno
            child: Text(
              'Regalo Min Lista Royal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              '\$${preciosMinimos.reduce((a, b) => a + b)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
    Divider(color: Colors.white),
    SizedBox(height: 5),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), // Fondo de la fila
              borderRadius: BorderRadius.circular(5), // Bordes redondeados
            ),
            padding: EdgeInsets.all(10), // Espaciado interno
            child: Text(
              'Regalo Max Lista Royal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              '\$${preciosMaximos.reduce((a, b) => a + b)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
    Divider(color: Colors.white),
    SizedBox(height: 5),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), // Fondo de la fila
              borderRadius: BorderRadius.circular(5), // Bordes redondeados
            ),
            padding: EdgeInsets.all(10), // Espaciado interno
            child: Text(
              'Regalo Min Royal C/Vitrex',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              '\$${preciosMinimos.reduce((a, b) => a + b) + diferencia}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
    Divider(color: Colors.white),
    SizedBox(height: 5),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), // Fondo de la fila
              borderRadius: BorderRadius.circular(5), // Bordes redondeados
            ),
            padding: EdgeInsets.all(10), // Espaciado interno
            child: Text(
              'Regalo Max Royal C/Vitrex',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              '\$${preciosMaximos.reduce((a, b) => a + b) + diferencia}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
  ],
),
          ),





            CheckboxListTile(
              title: Text(
                'Promoción',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              value: promocionSeleccionada,
              onChanged: (bool? newValue) {
                setState(() {
                  promocionSeleccionada = newValue ?? false;
                  mostrarDropdown = promocionSeleccionada;
                  if (!mostrarDropdown) {
                    valorSeleccionadoPromocion = null;
                  }
                });
              },
              checkColor: Colors.white,
            ),
            SizedBox(height: 10),
            Row(
              children: [


                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Visibility(
                        visible: mostrarDropdown,
                        maintainSize: false,
                        child: DropdownButton<String?>(
                          value: valorSeleccionadoPromocion,
                          items: productosSinSet.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              valorSeleccionadoPromocion = newValue;
                            });
                          },
                          dropdownColor: Colors.black,
                          isExpanded: true,
                          style: TextStyle(color: Colors.white), // Personalizar estilo del texto en la lista desplegable
                          icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Personalizar ícono de la lista desplegable
                        ),
                      ),
                    ),
                  ),
                ),



                SizedBox(width: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Visibility(
                        visible: mostrarDropdown,
                        maintainSize: false,
                        child: DropdownButton<int>(
                          value: valorSeleccionadoPredefinido,
                          items: valoresPredefinidos.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                value.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              valorSeleccionadoPredefinido = newValue!;
                            });
                          },
                          dropdownColor: Colors.black,
                          isExpanded: true,
                          style: TextStyle(color: Colors.white), // Personalizar estilo del texto en la lista desplegable
                          icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Personalizar ícono de la lista desplegable
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            
          // En el widget ElevatedButton
ElevatedButton(
  onPressed: _continuar, // Llama a la función _continuar al hacer clic en el botón
  child: Text(
    'Continuar',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  style: ElevatedButton.styleFrom(
    primary: Colors.blue,
    padding: EdgeInsets.symmetric(
      vertical: 15,
      horizontal: 30,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}


