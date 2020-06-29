import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/components/custom/episode/comments/AnswerCommentComponent.dart';
import 'package:aniflix_app/components/custom/episode/comments/CommentComponent.dart';
import 'package:aniflix_app/components/custom/episode/comments/answerBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  group("Test Custom Components for Comments", (){

    testWidgets("Test Answer Bar and Answer Comment Component", (WidgetTester tester) async {
      await tester.pumpWidget(TestAnswerBar());

      //Answer bar includes Answer Comment Component
      expect(find.byType(AnswerCommentComponent), findsOneWidget);

      //Answer Comment Component
      expect(find.byType(TextField), findsOneWidget);
      //User Icon; Send Icon
      expect(find.byType(IconButton), findsNWidgets(2));
      expect(find.byIcon(Icon(Icons.send).icon), findsOneWidget);
      expect(find.byIcon(Icon(Icons.person).icon), findsOneWidget);
    });


    testWidgets("Test Comment Component", (WidgetTester tester) async {
      await tester.pumpWidget(TestCommentComponent());

      expect(find.byType(TextField), findsOneWidget);
      //User Icon; Send Icon
      expect(find.byType(IconButton), findsNWidgets(2));
      expect(find.byIcon(Icon(Icons.send).icon), findsOneWidget);
      expect(find.byIcon(Icon(Icons.person).icon), findsOneWidget);
    });

/* Needs mocked auth Request
    testWidgets("Test Comment Container", (WidgetTester tester) async {
      await tester.pumpWidget(TestCommentContainer());

      //Username; Comment; Answer Button Description; more in SubComponents like VoteBar
      expect(find.byType(ThemeText), findsWidgets);
      //ThemeText Answer Button
      expect(find.text("Antworten"), findsOneWidget);

      //Person Icon; more in Sub Components
      expect(find.byType(IconButton), findsWidgets);
      expect(find.byIcon(Icon(Icons.person).icon), findsWidgets);

      //Report Delete Bar and Report Delete Bar of Sub Component SubCommentContainer
      expect(find.byType(ReportDeleteBar), findsNWidgets(2));
      //Same as Report Delete Bar
      expect(find.byType(VoteBar), findsNWidgets(2));
      expect(find.byType(FlatButton), findsOneWidget);
      expect(find.byType(AnswerBar), findsOneWidget);
      expect(find.byType(SubCommentContainer), findsOneWidget);
    });

    testWidgets("Test Sub Comment Container", (WidgetTester tester) async {
      await tester.pumpWidget(TestSubCommentContainer());

      //Person Icon; more in Sub Components
      expect(find.byType(IconButton), findsWidgets);
      expect(find.byIcon(Icon(Icons.person).icon), findsWidgets);

      //Username; Comment; more in Sub Components like ReportDeleteBar
      expect(find.byType(ThemeText), findsWidgets);

      expect(find.byType(ReportDeleteBar), findsOneWidget);
      expect(find.byType(VoteBar), findsOneWidget);
    });*/

  });
}

class TestAnswerBar extends StatelessWidget{
  TestAnswerBar();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AnswerBar(new User(1,"",null,"","","","","","","",[]), true, (value){}),
      ),
    );
  }
}


class TestCommentComponent extends StatelessWidget{
  TestCommentComponent();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CommentComponent(new User(1,"",null,"","","","","","","",[]), (value){}),
      ),
    );
  }
}


/*
class TestCommentContainer extends StatelessWidget{
  TestCommentContainer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CommentContainer(new Comment(1,"",1, "",1, "2020-19-05", "","",1,new User(1,"",null,"","","","","","","",[]), [],[new SubComment(1,"",1, "",1, "2020-19-05", "","",1,new User(1,"",null,"","","","","","","",[]), [])]), new User(1,"","","","","","","","","",[]), (value, value2){}, (value){}, (value, value2){}, new EpisodeScreenState("digimon-adventure-2020",1, 4, null)),
      ),
    );
  }
}

class TestSubCommentContainer extends StatelessWidget{
  TestSubCommentContainer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SubCommentContainer(new SubComment(1,"",1, "",1, "2020-19-05", "","",1,new User(1,"",null,"","","","","","","",[]), []), new User(1,"","","","","","","","","",[]), (){}, new EpisodeScreenState("digimon-adventure-2020",1, 4, null)),
      ),
    );
  }
}*/