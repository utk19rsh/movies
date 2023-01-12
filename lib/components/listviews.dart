import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:suspense/constant.dart';
import 'package:http/http.dart' as http;
import 'package:suspense/screens/model/view.dart';

class ListOfMovies extends StatelessWidget {
  const ListOfMovies({
    Key? key,
    required this.movies,
    required this.width,
  }) : super(key: key);

  final List<Movie> movies;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        physics: const BouncingScrollPhysics(),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          Movie movie = movies[index];
          return Container(
            color: white,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Body(
                  movie: movie,
                  width: width,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(MdiIcons.heartOutline),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(MdiIcons.commentOutline),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(MdiIcons.shareOutline),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(MdiIcons.pinOutline),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class Body extends StatefulWidget {
  const Body({
    Key? key,
    required this.movie,
    required this.width,
  }) : super(key: key);

  final Movie movie;
  final double width;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late double width;
  late String url, name;
  late int id;
  bool isLoading = true, showBack = false;
  List<String> images = [];

  @override
  void initState() {
    id = widget.movie.id;
    width = widget.width;
    url = widget.movie.image;
    name = widget.movie.name;
    inception();
    super.initState();
  }

  inception() async {
    final http.Response res = await http.get(
      Uri.parse(
        'https://api.tvmaze.com/shows/$id/images',
      ),
    );
    List<dynamic> body = jsonDecode(res.body) as List<dynamic>;
    if (res.statusCode == 200) {
      for (int i = 0; i < body.length; i++) {
        dynamic json = body[i];
        Map details = json["resolutions"] as Map;
        var image = (details["original"] as Map)["url"];
        images.add(image);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() => showBack = !showBack);
          },
          child: Container(
            width: width,
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        width: 30,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      name,
                      style: const TextStyle(color: black),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(MdiIcons.dotsVertical),
                )
              ],
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: AnimatedSwitcher(
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            duration: const Duration(milliseconds: 500),
            child: showBack && !isLoading
                ? Wrap(
                    children: [
                      ...images
                          .map((url) => CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                progressIndicatorBuilder:
                                    (context, url, progress) {
                                  return Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                        backgroundColor: white,
                                        color: theme,
                                      ),
                                    ),
                                  );
                                },
                              ))
                          .toList(),
                    ],
                  )
                : CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    width: widget.width,
                    height: widget.width,
                    progressIndicatorBuilder: (context, url, progress) {
                      return Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            value: progress.progress,
                            backgroundColor: white,
                            color: theme,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
