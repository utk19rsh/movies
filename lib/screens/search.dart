import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:suspense/components/listviews.dart';
import 'package:suspense/constant.dart';
import 'package:suspense/screens/model/view.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchValue = "";
  List<Movie> movies = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  Future<List<Movie>> inception() async {
    movies = [];
    setState(() => isLoading = true);
    final http.Response res = await http.get(
      Uri.parse(
        'https://api.tvmaze.com/search/shows?q=$searchValue',
      ),
    );
    List<dynamic> body = jsonDecode(res.body) as List<dynamic>;
    if (res.statusCode == 200) {
      for (int i = 0; i < body.length; i++) {
        dynamic json = body[i];
        Map<String, dynamic> details = json["show"] as Map<String, dynamic>;
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
    setState(() => isLoading = false);
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: black),
        title: TextFormField(
          cursorHeight: 20,
          cursorColor: theme,
          controller: searchController,
          onChanged: (value) =>  searchValue = value,
          decoration: InputDecoration(
            border: border(),
            errorBorder: border(),
            enabledBorder: border(),
            focusedBorder: border(),
            disabledBorder: border(),
            focusedErrorBorder: border(),
            fillColor: grey.shade300,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            hintText: " Search movies here...",
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              inception();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Icon(
                MdiIcons.magnify,
                color: theme,
              ),
            ),
          ),
          if (searchValue.isNotEmpty)
            GestureDetector(
              onTap: () {
                searchController.clear();
                setState(() {
                  movies = [];
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  MdiIcons.close,
                  color: theme,
                ),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: theme),
            )
          : searchValue.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/search.gif",
                    width: width / 2,
                    height: width / 2,
                  ),
                )
              : movies.isEmpty
                  ? const Center(
                      child: Text("No results found"),
                    )
                  : ListOfMovies(movies: movies, width: width),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: trans),
    );
  }
}
