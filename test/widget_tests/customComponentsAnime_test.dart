import 'package:aniflix_app/api/objects/Airing.dart';
import 'package:aniflix_app/api/objects/anime/Anime.dart';
import 'package:aniflix_app/api/objects/anime/AnimeSeason.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';
import 'package:aniflix_app/components/custom/anime/animeDescription.dart';
import 'package:aniflix_app/components/custom/anime/episodeList.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  group("Test Custom Components for Anime", (){
    testWidgets("episode list", (WidgetTester tester) async {
      await tester.pumpWidget(TestEpisodeList());

      expect(find.byType(ThemeText), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets("anime description", (WidgetTester tester) async {
      await tester.pumpWidget(TestAnimeDescription());

      expect(find.byType(ExpandablePanel), findsOneWidget);
      expect(find.byType(ThemeText), findsWidgets);
    });

    /* not finished because mocking of AniflixImage is needed
     testWidgets("anime header", (WidgetTester tester) async {
     await tester.pumpWidget(TestAnimeHeader());

     expect(find.byType(ThemeText), findsWidgets);
    });*/
  });

}

class TestAnimeDescription extends StatelessWidget{
  TestAnimeDescription();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:AnimeDescription("", context),
      ),
    );
  }
}

class TestEpisodeList extends StatelessWidget{
  TestEpisodeList();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: EpisodeList(new AnimeSeason(1,1,1,"","","","",1,[]), new Anime(1, "", "", "", "", "", "", "", "", "", "", "", new Vote(1, "",1, 1, 1, "", "",""),"", "", "", 1, 1, "", new Airing(1, 1, 1, 1, "", "", "", ""), [],[]))
      ),
    );
  }
}

/*class TestAnimeHeader extends StatelessWidget{
  TestAnimeHeader();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: AnimeHeader(new Anime(1, "", "", "", "", "", "", "", "", "", "", "", new Vote(1, "",1, 1, 1, "", "",""),"", "", "", 1, 1, "", new Airing(1, 1, 1, 1, "", "", "", ""), [],[]), 1, context)
      ),
    );
  }
}*/