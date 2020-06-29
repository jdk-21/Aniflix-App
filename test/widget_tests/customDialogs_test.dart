import 'package:aniflix_app/api/objects/Airing.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/Anime.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';
import 'package:aniflix_app/api/objects/anime/reviews/ReviewShow.dart';
import 'package:aniflix_app/components/custom/dialogs/aboutMeDialog.dart';
import 'package:aniflix_app/components/custom/dialogs/closeAppDialog.dart';
import 'package:aniflix_app/components/custom/dialogs/logoutDialog.dart';
import 'package:aniflix_app/components/custom/dialogs/ratingDialog.dart';
import 'package:aniflix_app/components/custom/dialogs/reportDialog.dart';
import 'package:aniflix_app/components/custom/dialogs/writeReviewDialog.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

void main(){
  group("Test Custom Dialogs", (){

    testWidgets("about me dialog", (WidgetTester tester) async {
      await tester.pumpWidget(TestAboutMeDialog());

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      //Buttons by Type and by Text
      expect(find.byType(FlatButton), findsNWidgets(2));
      expect(find.text("Abbrechen"), findsOneWidget);
      expect(find.text("Abgeben"), findsOneWidget);
    });

    testWidgets("logout dialog", (WidgetTester tester) async {
      await tester.pumpWidget(TestLogoutDialog());

      expect(find.byType(AlertDialog), findsOneWidget);
      //Description by Text and by Widget
      expect(find.text("Wirklich ausloggen?"), findsOneWidget);
      expect(find.byType(ThemeText), findsOneWidget);
      //Buttons by Text and by Type
      expect(find.byType(FlatButton), findsNWidgets(2));
      expect(find.text("Abbrechen"), findsOneWidget);
      expect(find.text("Ausloggen"), findsOneWidget);
    });

    testWidgets("rating dialog", (WidgetTester tester) async {
      await tester.pumpWidget(TestRatingDialog());

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(SmoothStarRating), findsOneWidget);
      //Buttons by Text and by Type
      expect(find.byType(FlatButton), findsNWidgets(2));
      expect(find.text("Abbrechen"), findsOneWidget);
      expect(find.text("Bewerten"), findsOneWidget);
    });

    testWidgets("report dialog", (WidgetTester tester) async {
      await tester.pumpWidget(TestReportDialog());

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      //Buttons by Text and by Type
      expect(find.byType(FlatButton), findsNWidgets(2));
      expect(find.text("Abbrechen"), findsOneWidget);
      expect(find.text("Absenden"), findsOneWidget);

    });

    testWidgets("write review dialog", (WidgetTester tester) async {
      await tester.pumpWidget(TestWriteReviewDialog());

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      //Buttons by Text and by Type
      expect(find.byType(FlatButton), findsNWidgets(2));
      expect(find.text("Abbrechen"), findsOneWidget);
      expect(find.text("Abgeben"), findsOneWidget);
    });

    testWidgets("close app dialog", (WidgetTester tester) async {
      await tester.pumpWidget(TestCloseAppDialog());

      expect(find.byType(AlertDialog), findsOneWidget);
      //Description by Text and by Widget
      expect(find.text("App beenden?"), findsOneWidget);
      expect(find.byType(ThemeText), findsOneWidget);
      //Buttons by Text and by Type
      expect(find.byType(FlatButton), findsNWidgets(2));
      expect(find.text("Abbrechen"), findsOneWidget);
      expect(find.text("Beenden"), findsOneWidget);
    });

  });
}

class TestAboutMeDialog extends StatelessWidget{
  TestAboutMeDialog();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AboutMeDialog((value){}),
      ),
    );
  }
}

class TestLogoutDialog extends StatelessWidget{
  TestLogoutDialog();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LogoutDialog(),
      ),
    );
  }
}

class TestRatingDialog extends StatelessWidget{
  TestRatingDialog();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RatingDialog(new Anime(1, "", "", "", "", "", "", "", "", "", "", "", new Vote(1, "",1, 1, 1, "", "",""),"", "", "", 1, 1, "", new Airing(1, 1, 1, 1, "", "", "", ""), [],[]), (value){}, 5),
      ),
    );
  }
}

class TestReportDialog extends StatelessWidget{
  TestReportDialog();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ReportDialog((value){}),
      ),
    );
  }
}

class TestWriteReviewDialog extends StatelessWidget{
  TestWriteReviewDialog();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: WriteReviewDialog((value){}, new ReviewShow(1,"","","","","","","","","","","",1,1,"",1,[]), new User(1,"","","","","","","","","",[])),
      ),
    );
  }
}

class TestCloseAppDialog extends StatelessWidget{
  TestCloseAppDialog();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CloseAppDialog((value){}),
      ),
    );
  }
}