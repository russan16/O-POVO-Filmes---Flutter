import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fire_auth/utils/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_fire_auth/ui/interna.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 1;
  String _urlBase = 'https://image.tmdb.org/t/p/w300';

  // pegando a lista semanal
  Future<Map> _getMovies() async {
    http.Response response;
    if (_search == null || _search.isEmpty) {
      response = await http.get(
          'https://api.themoviedb.org/3/discover/movie?api_key=5c7d8c96f7fbb728f2caeefa0fbdc0db&language=pt-BR&sort_by=popularity.desc&include_adult=false&include_video=false&page=1');
      return json.decode(response.body);
    } else {
      response = await http.get(
          'https://api.themoviedb.org/3/search/movie?api_key=5c7d8c96f7fbb728f2caeefa0fbdc0db&language=pt-BR&query=$_search&page=$_offset&include_adult=false');
      return json.decode(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    _getMovies().then((map) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('O POVO Filmes', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey[900],
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Buscar filme',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 1;
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: _getMovies(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError)
                          return Container();
                        else
                          return _creatMovieTable(context, snapshot);
                    }
                  }))
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Icon(Icons.account_circle, size: 100, color: Colors.white,),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('imgs/cinema.jpg'),
                  fit: BoxFit.cover
                )
              ),
            ),
            ListTile(
              title: Text('Home', style: TextStyle(fontSize: 25)),
              onTap: (){
                setState(() {
                  _search = null;
                });
              },
            ),
            ListTile(
              title: Text('Sair', style: TextStyle(fontSize: 25)),
              onTap: () {
                AuthProvider().logOut();
              },
            ),
          ],
        ),
      ),
    );
    //);
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length - 1;
    }
  }

  Widget _creatMovieTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: (1 / 1.5)),
        itemCount: _getCount(snapshot.data['results']),
        itemBuilder: (context, index) {
          // ------ PRINT DE TESTES ------
          //int contagem = snapshot.data['results'].length;
          var _urlCapa = snapshot.data['results'][index]['poster_path'];
          //print('POST: $index/$contagem CAPA: $_urlCapa');
          // ------ PRINT DE TESTES ------
          if (_search == null ||
              (index + 1) < snapshot.data['results'].length &&
                  _urlCapa != null &&
                  index != null)
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  alignment: Alignment.center,
                  image: '$_urlBase$_urlCapa',
                  fit: BoxFit.cover),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Interna(snapshot.data['results'][index])));
              },
            );
          else if (index == snapshot.data['results'].length)
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 70,
                    ),
                    Text(
                      'Mais Populares',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _search = null;
                  });
                },
              ),
            );
          else if (_urlCapa == null)
            return GestureDetector(
              child: Image.asset('imgs/notfound.jpg'),
              onTap: () {},
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70,
                    ),
                    Text(
                      'Carregar mais',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 1;
                  });
                },
              ),
            );
        });
  }
}
