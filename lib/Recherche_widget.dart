
import 'package:flutter/material.dart';

class RechercheWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RechercheWidget ({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 35,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Recherche',
          contentPadding: EdgeInsets.fromLTRB(5, 0, 7, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          suffixIcon: Tooltip(
            message: 'Rechercher',
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ),
        ),
        onChanged: onChanged,
     ),
);
}
}