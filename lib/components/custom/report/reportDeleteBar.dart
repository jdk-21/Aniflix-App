import 'package:flutter/material.dart';

class ReportDeleteBar extends StatelessWidget {
  bool _delete;
  Function() _onReport;
  Function() _onDelete;

  ReportDeleteBar(this._delete, this._onReport, this._onDelete);

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
            color: Theme.of(ctx).primaryIconTheme.color,
          ),
          onPressed: () {
            _onReport();
          },
        )
      ],
    );
  }
}
