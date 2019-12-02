import 'package:flutter/material.dart';

class ReportDeleteBar extends StatefulWidget {
  bool _delete;
  bool _reported;
  Function() _onReport;
  Function() _onDelete;
  Function(ReportDeleteBarState) _created;

  ReportDeleteBar(this._delete, this._reported, this._onReport, this._onDelete,
      this._created);

  @override
  ReportDeleteBarState createState() => ReportDeleteBarState(this._delete,
      this._reported, this._onReport, this._onDelete, this._created);
}

class ReportDeleteBarState extends State<ReportDeleteBar> {
  bool _reported;
  bool _delete;
  Function(ReportDeleteBarState) _created;
  Function() _onReport;
  Function() _onDelete;

  ReportDeleteBarState(this._delete, this._reported, this._onReport,
      this._onDelete, this._created);

  @override
  void initState() {
    this._created(this);
    super.initState();
  }

  toggleState() {
    setState(() {
      this._reported = !_reported;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Row(
      children: [
        (_delete)
            ? IconButton(
                padding: EdgeInsets.all(0),
                iconSize: 15,
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(ctx).primaryIconTheme.color,
                ),
                onPressed: _onDelete,
              )
            : Container(),
        IconButton(
          padding: EdgeInsets.all(0),
          iconSize: 15,
          icon: Icon(
            Icons.report,
            color: (!_reported)?Theme.of(ctx).primaryIconTheme.color:Colors.red,
          ),
          onPressed: () {
            if (!_reported) {
              setState(() {
                _reported = true;
              });
              _onReport();
            }
          },
        )
      ],
    );
  }
}
