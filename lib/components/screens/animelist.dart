import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimeList extends StatefulWidget {
  @override
  AnimeListState createState() => AnimeListState();
}

class AnimeListState extends State<AnimeList> {
  List<String> filterCriteria = ["Genre", "A - Z", "Bewertung", "Abos"];
  bool _onlyAiring = false;
  int _actualFilterCriteria;

  changeCheckbox() {
    setState(() {
      _onlyAiring = !_onlyAiring;
    });
  }

  changeActualFilterCriteria(int newValue){
    setState(() {
      _actualFilterCriteria = newValue;
    });
  }

  updateAnimeList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext ctx) {
    if(_actualFilterCriteria == null){
      _actualFilterCriteria = 0;
    }
    return Container(
        color: Theme.of(ctx).backgroundColor,
        child: ListView(
          padding: EdgeInsets.only(left: 5, right: 5),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Theme(
                  data: Theme.of(ctx)
                      .copyWith(canvasColor: Theme.of(ctx).backgroundColor),
                  child: DropdownButton(
                    items: getFilterCriteriaAsDropdownList(),
                    value: _actualFilterCriteria,
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 15),
                    onChanged: (newValue) {changeActualFilterCriteria(newValue);},
                  ),
                ),
                FlatButton(
                  child: Row(
                      children: <Widget>[
                        Theme(
                          data: Theme.of(ctx).copyWith(
                              unselectedWidgetColor:
                                  Theme.of(ctx).textTheme.title.color),
                          child: Checkbox(
                            onChanged: (newValue) {
                              changeCheckbox();
                            },
                            value: _onlyAiring,
                          ),
                        ),
                        Text(
                          "Nur Airing",
                          style: TextStyle(
                              color: Theme.of(ctx).textTheme.title.color, fontWeight: FontWeight.normal),
                        )
                      ]),
                  onPressed: () {
                    changeCheckbox();
                  },
                ),
              ],
            )
          ],
        ));
  }

  List<DropdownMenuItem<int>> getFilterCriteriaAsDropdownList() {
    List<DropdownMenuItem<int>> filterCriteriaAsDropdown = [];
    for(int l = 0; l < filterCriteria.length; l++){
      filterCriteriaAsDropdown.add(DropdownMenuItem(value: l, child: Text(filterCriteria.elementAt(l))));
    }
    return filterCriteriaAsDropdown;
  }
}
