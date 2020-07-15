import 'package:flutter/material.dart';
import '../custom/text/highlighted_text_box.dart';

class SliderElement extends StatelessWidget {
  Function(BuildContext) onTap;
  String name;
  String description;
  String image;
  Function close;
  Color desccolor;
  bool horizontal;
  bool highlight;

  SliderElement(
      {this.name,
      this.description,
      this.image,
      this.onTap,
      this.close,
      this.desccolor = const Color.fromRGBO(15, 15, 15, 1),
      this.horizontal = true,
      this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {
        onTap(context);
      },
      child: Container(
          margin: EdgeInsets.only(left: 3, right: 3),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(image), fit: BoxFit.contain)),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Stack(
              children: [
                (close == null)
                    ? (highlight)
                        ? Align(
                            alignment: AlignmentDirectional.topStart,
                            child: HighlightedTextBox("🔥",color: Colors.white,size: 20,),
                          )
                        : Align(
                            alignment: AlignmentDirectional.topStart,
                          )
                    : Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              shape: BoxShape.circle),
                          child: FittedBox(
                              child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Theme.of(context).backgroundColor,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: close,
                          )),
                        )),
                (name != "" && name != null)
                    ? Align(
                        alignment: (horizontal)
                            ? AlignmentDirectional.bottomStart
                            : AlignmentDirectional.bottomCenter,
                        child: HighlightedTextBox(name))
                    : Align(
                        alignment: (horizontal)
                            ? AlignmentDirectional.bottomStart
                            : AlignmentDirectional.bottomCenter),
                (description != "" && description != null)
                    ? Align(
                        alignment: AlignmentDirectional.topEnd,
                        child:
                            HighlightedTextBox(description, color: desccolor))
                    : Align(alignment: AlignmentDirectional.topEnd),
              ],
            ),
          )),
    ));
  }
}
