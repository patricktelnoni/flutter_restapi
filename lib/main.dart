import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Album>> fetchAlbum() async {
  List<Album> albums = [];
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final list = jsonDecode(response.body);
    for(var data in list){
      albums.add(Album.fromJson(data));
      print(data);
    }
    return albums;
    //return Album.fromJson(jsonDecode(response.body));
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
  List<Album> futureAlbum = [];
  //late Future<Album> futureAlbum;

  void getData() async{
    futureAlbum = await fetchAlbum();
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
        primarySwatch: Colors.lightBlue
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Fetch data example"),
        ),
        body: Center(
          child: ListView.separated(
            padding     : const EdgeInsets.all(10.0),
            itemCount   : futureAlbum.length,

            itemBuilder : (BuildContext context, int index){

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black26,
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                margin: EdgeInsets.all(2),
                child: ListTile(
                  title:Text('${futureAlbum[index].title}'),
                  onTap: (){
                    final snackBar = SnackBar(
                      content: Text('${futureAlbum[index].title}'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );

                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),

              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        ),
      ),
    );

  }
}
