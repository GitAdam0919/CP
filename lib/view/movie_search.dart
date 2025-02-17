import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controller/movieController.dart';

class MovieSearch extends StatefulWidget {
  const MovieSearch({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MovieSearchState createState() => _MovieSearchState();
}

class _MovieSearchState extends State<MovieSearch> {
  final MovieController movieController = Get.put(MovieController());
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Icon actionIcon = const Icon(Icons.search);
  searchMovie(String movieName) {
    movieController.getSearchedMovie(movieName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          autofocus: true,
          focusNode: _focusNode,
          controller: searchController,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            hintText: "Search...",
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onEditingComplete: () => searchMovie(searchController.text),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              alignment: Alignment.centerRight,
              onPressed: () => searchMovie(searchController.text),
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Obx(() => movieController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : movieController.searchedMovies.isEmpty
                ? const Center(
                    child: Text('No Movie Found, Start Searching'),
                  )
                : ListView.separated(
                    separatorBuilder: (_, __) => const SizedBox(
                      height: 5,
                    ),
                    itemCount: movieController.searchedMovies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white10,
                            ),
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.4,
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                        movieController
                                            .searchedMovies[index].title!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall),
                                    subtitle: Wrap(
                                      children: movieController
                                          .searchedMovies[index].category!
                                          .map((e) => Text('${e.category}  '))
                                          .toList(),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.amber,
                                      ),
                                      child: Text(
                                        movieController
                                            .searchedMovies[index].rating!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width / 3.5,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                image: NetworkImage(
                                    "$posterURL${movieController.searchedMovies[index].posterURL}"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      );
                    },
                  )),
      ),
    );
  }
}
