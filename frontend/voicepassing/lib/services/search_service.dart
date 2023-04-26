import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  Textinput? searchWord;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 180,
                    height: 50,
                    child: Card(color: Colors.blue, child: searchWord),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            )),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
          ),
          child: GestureDetector(
              onTap: () async {
                ClipboardData? data =
                    await Clipboard.getData(Clipboard.kTextPlain);
                setState(() {
                  print(searchWord);
                });
                print(data?.text);
              },
              child: const Icon(
                Icons.paste_sharp,
                color: Colors.white,
              )),
        )
      ],
    );
  }
}

class Textinput extends StatefulWidget {
  const Textinput({super.key});

  @override
  State<Textinput> createState() => TextinputState();
}

class TextinputState extends State<Textinput> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String textValue = myController.text;
    bool showSuffixIcon = textValue.isNotEmpty;

    return Container(
      child: TextField(
        controller: myController,
        onChanged: (value) {
          setState(() {
            textValue = value;
          });
        },
        autofocus: true,
        decoration: InputDecoration(
          suffixIconConstraints: const BoxConstraints(
            maxHeight: 20,
            maxWidth: 20,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: showSuffixIcon
                ? IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      print('클릭이벤트');
                      setState(() {
                        myController.clear();
                        textValue = '';
                      });
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
