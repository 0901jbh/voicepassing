import 'package:flutter/material.dart';
import 'package:voicepassing/services/search_service.dart';

class SearchScreenResult extends StatefulWidget {
  const SearchScreenResult({super.key});

  @override
  State<SearchScreenResult> createState() => _SearchScreenResultState();
}

class _SearchScreenResultState extends State<SearchScreenResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   foregroundColor: Colors.black,
      //   elevation: 0,
      // ),
      body: Builder(
        builder: (BuildContext context) {
          return const Padding(
            padding: EdgeInsets.all(30.0),
            child: Hero(
              tag: 'searchBar',
              child: SearchWidget(),
            ),
          );
        },
      ),
    );
  }
}
