import 'package:aniflix_app/api/objects/Season.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/components/custom/episode/episodeBar.dart';
import 'package:aniflix_app/components/custom/episode/episodeHeader.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  group("Test Custom Components for Episode", (){

    /*testWidgets("Test Anime Player", (WidgetTester tester) async {
      await tester.pumpWidget(TestAnimePlayer());
    });*/

    testWidgets("Test Episode Bar", (WidgetTester tester) async {
      await tester.pumpWidget(TestEpisodeBar());

      expect(find.byType(FlatButton), findsOneWidget);
      //Episode Name; Season and Episode; Show Name; Date, UpVotes; DownVotes
      expect(find.byType(ThemeText), findsNWidgets(6));
      //Report; UpVote; DownVote
      expect(find.byType(IconButton), findsNWidgets(3));

    });

    testWidgets("Test Episode Header", (WidgetTester tester) async {
      await tester.pumpWidget(TestEpisodeHeader());

      expect(find.byType(DropdownButton), findsNWidgets(2));
      //next Episode; last Episode
      expect(find.byType(IconButton), findsNWidgets(2));
    });

  });
}

/*class TestAnimePlayer extends StatelessWidget{
  TestAnimePlayer();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AnimePlayer(new AnimeStream(), 1, new InAppWebView(), new InAppWebViewController()),
      ),
    );
  }
}*/

class TestEpisodeBar extends StatelessWidget{
  TestEpisodeBar();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: EpisodeBar(new EpisodeInfo(1,"",1,1,"2020-19-05","","",1,"","","",1,[],[],[], new Season(1,1,1,"", "","", "",1, new Show(1,"", "","","","","","","","","","",1,1,"",1))), (value){}),
      ),
    );
  }
}

class TestEpisodeHeader extends StatelessWidget{
  TestEpisodeHeader();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: EpisodeHeader(new EpisodeInfo(1,"",1,1,"","","",1,"","","",1,[],[],[], new Season(1,1,1,"", "","", "",1, new Show(1,"", "","","","","","","","","","",1,1,"",1))),(){}, (){},(value, value2, value3){},(value){}),
      ),
    );
  }
}