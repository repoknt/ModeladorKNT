import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EsquemaRegalosPage extends StatefulWidget {
  final int preciosComerciales;
  final int preciosRoyal;
  final int diferencia;
  final double regaloIdeal;
  final int preciosMinimos;
  final int preciosMaximos;
  final int RegaloMinRoyalCVitrex;
  final int RegaloMaxRoyalCVitrex;

  EsquemaRegalosPage({
    required this.preciosComerciales,
    required this.preciosRoyal,
    required this.diferencia,
    required this.regaloIdeal,
    required this.preciosMinimos,
    required this.preciosMaximos,
    required this.RegaloMinRoyalCVitrex,
    required this.RegaloMaxRoyalCVitrex,
  });

  @override
  _EsquemaRegalosPageState createState() => _EsquemaRegalosPageState();
}

class _EsquemaRegalosPageState extends State<EsquemaRegalosPage> {
  late User user;
  late QuerySnapshot querySnapshot;
  List<String> productosConSet = [];
  List<List<String>> allDatos = [[]];
  List<String?> valoresSeleccionados = [null];
  String? valorSeleccionadoPromocion;
  List<String?> preciosComerciales1 = [null];
  List<int> preciosSeleccionados = [0];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    obtenerDatos();
  }

  Future<void> obtenerDatos() async {
    querySnapshot =
        await FirebaseFirestore.instance.collection('productos_royal').get();
    List<String> datos = querySnapshot.docs
        .map<String>((doc) => doc.get('producto'))
        .where((producto) => !producto.toLowerCase().contains('set'))
        .toList();
    List<int> nuevosPrecios = querySnapshot.docs
        .map<int>((doc) => doc.get('precio_comercial'))
        .toList();

    setState(() {
      allDatos = [datos];
      productosConSet = ['Selecciona un producto', ...datos];
      valorSeleccionadoPromocion = 'Selecciona un producto';
      preciosComerciales1 = [null];
      preciosSeleccionados = [0];
    });
  }

  void agregarListaDesplegable() async {
    QuerySnapshot newQuerySnapshot =
        await FirebaseFirestore.instance.collection('productos_royal').get();

    List<String> datos = newQuerySnapshot.docs
        .map<String>((doc) => doc.get('producto'))
        .where((producto) => producto.toLowerCase().contains('set'))
        .toList();

    datos.insert(0, 'Selecciona un producto');

    List<int> nuevosPrecios = newQuerySnapshot.docs
        .map<int>((doc) => doc.get('precio_comercial'))
        .toList();

    setState(() {
      allDatos.add(datos);
      valoresSeleccionados.add('Selecciona un producto');
      preciosComerciales1.add(null);
      preciosSeleccionados.add(0);
    });
  }

  void actualizarPrecioComercial(int index, String? newValue) {
    if (newValue == 'Selecciona producto') {
      setState(() {
        preciosComerciales1[index] = null;
      });
      return;
    }

    int precioComercial1 = preciosSeleccionados[0] ?? 0;

    for (var doc in querySnapshot.docs) {
      if (doc.get('producto') == newValue) {
        precioComercial1 = doc.get('precio_comercial') ?? 0;
        break;
      }
    }

    setState(() {
      preciosSeleccionados[index] = precioComercial1;

      int sumaPreciosComerciales = preciosSeleccionados.reduce((a, b) => a + b);
    });
  }

  void eliminarListaDesplegable(int index) {
    setState(() {
      if (allDatos.length > 1) {
        allDatos.removeAt(index);
        preciosSeleccionados.removeAt(index);
        valoresSeleccionados.removeAt(index);
        preciosComerciales1.removeAt(index);
        int sumaPreciosComerciales =
            preciosSeleccionados.reduce((a, b) => a + b);
      }
    });
  }

  String getDescuentoRestante(int descuentoRestante) {
    if (descuentoRestante >= 0) {
      return 'Descuento Restante: \$$descuentoRestante';
    } else {
      return 'Descuento se paso: \$${-descuentoRestante}';
    }
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
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Esquema de Regalos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allDatos.length,
                itemBuilder: (context, index) {
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
                              value: valorSeleccionadoPromocion,
                              items: productosConSet.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                actualizarPrecioComercial(index, newValue);
                                setState(() {
                                  valorSeleccionadoPromocion = newValue;
                                });
                              },
                              dropdownColor: Colors.black,
                              isExpanded: true,
                              style: TextStyle(color: Colors.white),
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
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
              SizedBox(height: 10),

              Opacity(
                opacity: 1.0,
                child: Text(
                  getDescuentoRestante(widget.RegaloMaxRoyalCVitrex -
                      preciosSeleccionados.reduce((a, b) => a + b)),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (widget.RegaloMaxRoyalCVitrex -
                                preciosSeleccionados.reduce((a, b) => a + b)) >=
                            0
                        ? Colors.green
                        : Colors.red,
                    fontSize: 30,
                  ),
                ),
              ),

             

              Opacity(
                opacity: 1.0,
                child: Text(
                  'Total del regalo: \$${preciosSeleccionados.reduce((a, b) => a + b)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),

              Opacity(
                opacity: 1.0,
                child: Text(
                  'Regalo Otorgado: \$${widget.RegaloMaxRoyalCVitrex}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),

              Opacity(
                opacity: 1.0,
                child: Text(
                  'Total: ${widget.preciosRoyal}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),



Opacity(
                opacity: 1.0,
                child: // Dentro de la función build, busca el contenedor que muestra "Sin Rentabilidad"
Container(
  color: (widget.RegaloMaxRoyalCVitrex - preciosSeleccionados.reduce((a, b) => a + b)) >= 0 ? Colors.green : Colors.red,
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      (widget.RegaloMaxRoyalCVitrex - preciosSeleccionados.reduce((a, b) => a + b)) >= 0
        ? 'Aprobado'
        : 'Sin Rentabilidad',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  ),
),
              ),












              Opacity(
                opacity: 0.0,
                child: Text(
                  'Precios Royal: ${widget.preciosRoyal}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Text(
                  'Diferencia: ${widget.diferencia}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Text(
                  'Regalo Ideal: ${widget.regaloIdeal}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Text(
                  'Precios Mínimos: ${widget.preciosMinimos}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Text(
                  'Precios Máximos: ${widget.preciosMaximos}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Text(
                  'Regalo Min Royal C/Vitrex: ${widget.RegaloMinRoyalCVitrex}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),

              Opacity(
                opacity: 0.0,
                child: Text(
                  'Descuento meximo: ${widget.RegaloMaxRoyalCVitrex}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),


 













            ],
          ),
        ],
      ),
    );
  }
}
