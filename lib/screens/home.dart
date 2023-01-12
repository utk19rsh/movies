import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:suspense/components/listviews.dart';
import 'package:suspense/constant.dart';
import 'package:suspense/screens/model/view.dart';
import 'package:suspense/screens/search.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<List<Movie>> inception() async {
    List<Movie> movies = [];
    final http.Response res = await http.get(
      Uri.parse(
        'https://api.tvmaze.com/schedule/web?date=2022-12-01&country=US',
      ),
    );
    List<dynamic> body = jsonDecode(res.body) as List<dynamic>;
    if (res.statusCode == 200) {
      for (int i = 0; i < body.length; i++) {
        dynamic json = body[i];
        Map<String, dynamic> details =
            json["_embedded"]["show"] as Map<String, dynamic>;
        var temp = details["image"] as Map;
        movies.add(
          Movie.fromJson(
            id: details["id"],
            name: details["name"],
            image: temp["original"],
          ),
        );
      }
    }
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text("Feather Cap", style: TextStyle(color: theme)),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: trans,
          statusBarIconBrightness: Brightness.dark,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => const Search(),
                ),
              );
            },
            icon: const Icon(
              MdiIcons.magnify,
              color: theme,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: inception(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Movie> movies = snapshot.data!;
            return ListOfMovies(
              movies: movies,
              width: width,
            );
          } else {
            const CircularProgressIndicator();
          }
          return Container();
        },
      ),
    );
  }
}
