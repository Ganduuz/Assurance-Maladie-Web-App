import 'package:pfe/responsive.dart';
import 'package:flutter/material.dart';
import 'info_emp.dart';
import 'bar_graph.dart';
class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 2,
            childAspectRatio: _size.width < 650 ? 1.2 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.3,
          ), 
        ),
        SizedBox(height: 50,),
        BarGraphCard(),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]),
    );
  }
}

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: info.color, // Utiliser la couleur de grille spécifiée dans l'objet CloudStorageInfo
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(204, 234, 252, 0.804),
        blurRadius: 20.0,
        offset: Offset(0, 5),
      ),
    ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
         children: [ Text(
            info.titre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
           style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.5),
          ),
        ],
      ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [ Image.asset(info.imagePath),
                
                ],
              ),
            SizedBox(width: 70,),
              Text(
                "${info.nombre}",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black)
              ),
            ],
          ),
         ],),
);
}
}