import 'package:flutter/material.dart';
import 'package:movie_firman/http_helper.dart';

import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late HttpHelper helper;
  late int moviesCount;
  late List movies;

  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  Icon visibleIcon = const Icon(Icons.search);
  Widget searchBar = const Text('firman production');

  bool isLoading = true;

  Future<void> initialize() async {
    setState(() {
      isLoading = true;
    });
    helper.getUpcoming().then((response) {
      setState(() {
        moviesCount = response.length;
        movies = response;
        isLoading = false;
      });
    });
  }

  Future<void> search(String title) async {
    setState(() {
      isLoading = true;
    });
    helper.findMovies(title).then((response) {
      setState(() {
        moviesCount = response.length;
        movies = response;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    helper = HttpHelper();
    moviesCount = 0;
    movies = [];
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;

    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: [
          IconButton(
            icon: visibleIcon,
            onPressed: () {
              if (visibleIcon.icon == Icons.search) {
                setState(() {
                  visibleIcon = const Icon(Icons.cancel);
                  searchBar = TextField(
                    onSubmitted: (String text) {
                      search(text);
                    },
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  );
                });
              } else {
                setState(() {
                  visibleIcon = const Icon(Icons.search);
                  searchBar = const Text('firman production');
                });
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return initialize();
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: moviesCount,
                itemBuilder: (BuildContext context, int position) {
                  if (movies[position].posterPath != null) {
                    image =
                        NetworkImage(iconBase + movies[position].posterPath);
                  } else {
                    image = NetworkImage(defaultImage);
                  }

                  return Card(
                    color: Colors.grey[200],
                    elevation: 2.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10.0),
                      onTap: () {
                        MaterialPageRoute route = MaterialPageRoute(
                            builder: (_) =>
                                MovieDetail(movie: movies[position]));
                        Navigator.push(context, route);
                      },
                      leading: SizedBox(
                        width: 50.0,
                        child: Image(
                          image: image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        '${movies[position].title}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(
                            'Released: ${movies[position].releaseDate}',
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Vote: ${movies[position].voteAverage}',
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
