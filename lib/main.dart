import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Album> fetchAlbum() async {
  //List<Album> albums = [];
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    /*final list = jsonDecode(response.body);
    for(var data in list){
      albums.add(Album.fromJson(data));
      //print(data);
    }*/
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId  : json['userId'],
      id      : json['id'],
      title   : json['title'],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _State();
}

class _State extends State<MyApp>{
  //List<Album> futureAlbum = [];
  late Future<Album> futureAlbum;

  void getData() async{
    futureAlbum = fetchAlbum();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Fetch data",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Fetch data example"),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return Text(snapshot.data!.title, style: TextStyle(fontSize: 28),);
              }
              else if(snapshot.hasError){
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );

  }
}
