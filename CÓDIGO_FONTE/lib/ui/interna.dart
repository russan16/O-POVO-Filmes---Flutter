import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Interna extends StatelessWidget {
  String _urlBase = 'https://image.tmdb.org/t/p/w500';
  final Map _movieData;

  Interna(this._movieData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(_movieData['title'], style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.blueGrey[900],
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Center(
                child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: _urlBase + _movieData['backdrop_path'],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2,
                ),
              ),
              Container(
                child: GestureDetector(
                  child: Icon(Icons.favorite_border,
                      color: Colors.redAccent, size: 35),
                  onTap: () {},
                ),
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(20),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Lançamento: ' + _movieData['release_date'],
                      style: TextStyle(color: Colors.grey, fontSize: 15))),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Nota: ' + _movieData['vote_average'].toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 15)))
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Text(_movieData['title'],
                      style: TextStyle(color: Colors.white, fontSize: 35))),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 25),
                  child: Text(_movieData['overview'],
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, height: 1.5)))
            ],
          )
        ],
      )),
    );
  }
}
