import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/reviews/Review.dart';
import 'package:aniflix_app/api/objects/anime/reviews/ReviewShow.dart';
import 'package:flutter/material.dart';

class WriteReviewDialog extends StatelessWidget {
  Function(Review) onSend;
  ReviewShow review;
  User user;
  var controller = TextEditingController();

  WriteReviewDialog(this.onSend, this.review, this.user);

  @override
  Widget build(BuildContext ctx) {
    return AlertDialog(
      backgroundColor: Theme.of(ctx).backgroundColor,
      contentTextStyle: TextStyle(color: Theme.of(ctx).textTheme.title.color),
      content: Column(
        children: <Widget>[Text("Review schreiben"),
        TextField(
          style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
          keyboardType: TextInputType.multiline,
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Review'),
        )],

      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.red,
          child: Text(
            "Abbrechen",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
        FlatButton(
          color: Colors.green,
          child: Text(
            "Abgeben",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            onSend(new Review((review.reviews.length < 1 ? 0 : review.reviews.first.id + 1), review.id, user.id,
                controller.text, null, user));
            controller.text = "";
            Navigator.of(ctx).pop();
          },
        )
      ],
    );
  }
}
