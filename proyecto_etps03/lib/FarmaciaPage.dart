import 'package:flutter/material.dart';
import 'package:proyecto_etps03/map_page.dart';

class FarmaciaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Farmacias'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Dropdown para departamentos
            DropdownButton<String>(
              hint: Text('Selecciona un departamento'),
              items: [
                // Agrega aquí los departamentos de El Salvador como elementos del Dropdown
                DropdownMenuItem<String>(
                  value: 'Departamento 1',
                  child: Text('Departamento 1'),
                ),
                DropdownMenuItem<String>(
                  value: 'Departamento 2',
                  child: Text('Departamento 2'),
                ),
                // Agrega más elementos de acuerdo a tus necesidades
              ],
              onChanged: (value) {
                // Maneja la selección del departamento aquí
              },
            ),
            SizedBox(height: 16.0), // Espacio entre elementos

            // Dropdown para municipios
            DropdownButton<String>(
              hint: Text('Selecciona un municipio'),
              items: [
                // Agrega aquí los municipios de El Salvador como elementos del Dropdown
                DropdownMenuItem<String>(
                  value: 'Municipio 1',
                  child: Text('Municipio 1'),
                ),
                DropdownMenuItem<String>(
                  value: 'Municipio 2',
                  child: Text('Municipio 2'),
                ),
                // Agrega más elementos de acuerdo a tus necesidades
              ],
              onChanged: (value) {
                // Maneja la selección del municipio aquí
              },
            ),
            SizedBox(height: 16.0), // Espacio entre elementos

            // Textbox para medicamento
            TextField(
              decoration: InputDecoration(labelText: 'Medicamento'),
            ),
            SizedBox(height: 16.0), // Espacio entre elementos

            // Botón 'Listado de Farmacias'
            ElevatedButton(
              onPressed: () {
                // Agrega la lógica para buscar farmacias aquí
              },
              child: Text('Listado de Farmacias'),
            ),
            SizedBox(height: 16.0), // Espacio entre elementos

            // GridView para mostrar resultados
            GridView.count(

              crossAxisCount: 2, // Dos columnas
              shrinkWrap: true, // Para ajustar su tamaño según el contenido
              children: [
                // Aquí puedes agregar las celdas del GridView con 'Farmacia' y 'Cantidad'
                // Puedes usar elementos como ListTile, Card, o personalizar según tus necesidades
                // Ejemplo:
                GestureDetector(
                  onTap: () {
                    // Navegar a la página del mapa cuando se toca una carta
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()), // Asegúrate de importar MapaPage
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Text('Farmacia 1'),
                        Text('Cantidad: 10'),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navegar a la página del mapa cuando se toca una carta
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()), // Asegúrate de importar MapaPage
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Text('Farmacia 1'),
                        Text('Cantidad: 10'),
                      ],
                    ),
                  ),
                ),
                // Agrega más celdas según tus resultados
              ],
            ),
          ],
        ),
      ),
    );
  }
}
