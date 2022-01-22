import 'dart:convert';

import 'package:examen/usuario_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
      ),
      body: FutureBuilder<dynamic>(
        future: pegarUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var usuario = snapshot.data![index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UsuarioPage(usuario: usuario)));
                    },
                    leading: CircleAvatar(
                      child: Text(usuario['id'].toString()),
                    ),
                    title: Text(usuario['name']),
                    subtitle: Text(usuario['website']),
                  );
                });
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  pegarUsuarios() async {
    var url = Uri.parse('http://jsonplaceholder.typicode.com/users');
    var respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      return jsonDecode(respuesta.body);
    } else {
      throw Exception('No se ha podido cargar los usuarios');
    }
  }
}
