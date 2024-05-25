import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pfe/Dashboard/info_remb.dart';
import 'package:pfe/responsive.dart';
import 'gridViewEmp.dart';
class dashboard extends StatelessWidget {
   dashboard({super.key});

  @override
  Widget build(BuildContext context) {
     
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
     children: [
      /*Row(
    children: [  Text("Tableau de bord",style: Theme.of(context).textTheme.headlineMedium,),
      Spacer(),
      Expanded(
        
        child: TextField(
        decoration: InputDecoration(
          filled: true,
          hintText: "Recherche",
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none, 
          ),
          suffixIcon: InkWell(
            onTap: (){

            },
            child:Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(color:Colors.blue ,
              borderRadius: BorderRadius.all(Radius.circular(12)),),
            child: Icon(Icons.search),
          )
          ),
        ),
      ),
      ),
         ],
        ),*/
        SizedBox(height: 20,),
        Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(),
                      SizedBox(height: 10),
                      if (Responsive.isMobile(context))
                        SizedBox(height: 10),
                      if (Responsive.isMobile(context)) InfoRemb(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: 10),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: InfoRemb(),
                  ),
              ],
            )
          ],
        ),
     ),
);
}
}