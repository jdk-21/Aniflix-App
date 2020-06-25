import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/anime/Anime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingDialog extends StatefulWidget{

  Anime anime;
  Function(double) onSend;
  double newRating;

  RatingDialog(this.anime, this.onSend, this.newRating);

  @override
  RatingDialogState createState() => RatingDialogState(anime, onSend, newRating);
}

class RatingDialogState extends State<RatingDialog>{

  double _rating;
  Anime anime;
  Function(double) onSend;
  double newRating;

  RatingDialogState(this.anime, this.onSend, this.newRating){
    if(newRating != null){
      _rating = newRating;
    }else{
      _rating = anime.ownVote == null
          ? 0
          : anime.ownVote.value.floorToDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
          return AlertDialog(
            backgroundColor:
            Theme.of(context).backgroundColor,
            contentTextStyle: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .caption
                    .color),
            content: SmoothStarRating(
              color: Theme.of(context)
                  .textTheme
                  .caption
                  .color,
              allowHalfRating: false,
              borderColor: Theme.of(context)
                  .textTheme
                  .caption
                  .color,
              starCount: 5,
              rating: _rating,
              onRatingChanged: (v){
                setState(() {
                  _rating = v;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text(
                  "Abbrechen",
                  style: TextStyle(
                      color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _rating = anime.ownVote == null ? 0 : anime.ownVote.value.floorToDouble();
                },
              ),
              FlatButton(
                color: Colors.green,
                child: Text(
                  "Bewerten",
                  style: TextStyle(
                      color: Colors.white),
                ),
                onPressed: ()  {
                  onSend(_rating);
                  sendData();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
  }

  sendData() async {
    var newAnimeData = await APIManager.getAnime(anime.url);
    APIManager.setShowVote(newAnimeData.id, newAnimeData.ownVote.value, _rating.round());
  }
}