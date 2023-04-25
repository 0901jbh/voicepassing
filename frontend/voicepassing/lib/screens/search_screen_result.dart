import 'package:flutter/material.dart';

class SearchScreenResult extends StatelessWidget {
  const SearchScreenResult({super.key});

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
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Hero(
              tag: 'searchBar',
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      // Card(
                      //   child: IconButton(
                      //     onPressed: () {
                      //       // print(context);
                      //       Navigator.pop(context);
                      //     },
                      //     icon: const Icon(
                      //       Icons.arrow_back,
                      //     ),
                      //     color: Colors.white,
                      //   ),
                      // ),
                      //
                      Column(
                        children: const [
                          Text(
                            'URL을 입력하세요',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const Icon(Icons.search, color: Colors.white)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
