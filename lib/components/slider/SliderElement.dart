import 'package:flutter/material.dart';
import '../custom/text/highlighted_text_box.dart';

class SliderElement extends StatelessWidget {
  Function(BuildContext) onTap;
  String name;
  String description;
  String image;
  Function close;
  Color desccolor;

  SliderElement({this.name, this.description, this.image, this.onTap, this.close,this.desccolor = const Color.fromRGBO(15, 15, 19, 1)});

  @override
  Widget build(BuildContext context) {
    return Container(child: InkWell(
          onTap: (){
            onTap(context);
          },
          child: Container(
              margin: EdgeInsets.only(left: 3, right: 3),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.fill)),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Stack(
                  children: [
                    (close == null)
                        ? Align(
                            alignment: AlignmentDirectional.topStart,
                          )
                        : Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Container(
                              width: 25,
                              height: 25,
                                child: FittedBox(child: FloatingActionButton(
                                  heroTag: null,
                                  backgroundColor: Color.fromRGBO(15, 15, 19, 1),
                                  child: Icon(Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: close,)),
                              color: Color.fromRGBO(15, 15, 19, 0),
                            )),
                    //IconButton(icon: Icon(Icons.close, color: Colors.white,), onPressed: close)),
                    (name != "" && name != null)
                        ? Align(
                            alignment: AlignmentDirectional.bottomStart,
                            child: HighlightedTextBox(name))
                        : Align(alignment: AlignmentDirectional.bottomStart),
                    (description != "" && description != null)
                        ? Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: HighlightedTextBox(description,color: desccolor))
                        : Align(alignment: AlignmentDirectional.topEnd),
                  ],
                ),
              )),
        ));
  }

    
}
