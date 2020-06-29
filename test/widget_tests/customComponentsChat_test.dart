import 'package:aniflix_app/components/custom/chat/chatInput.dart';
import 'package:aniflix_app/components/custom/chat/chatRulesDialog.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  group("Test Custom Components for Chat", (){
    testWidgets("chat input", (WidgetTester tester) async {
      await tester.pumpWidget(TestChatInput());

      expect(find.byType(IconButton), findsNWidgets(2));
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets("chat rules dialog", (WidgetTester tester) async {
      await tester.pumpWidget(TestChatRulesDialog());

      expect(find.byType(ThemeText), findsNWidgets(2));
      expect(find.text("Regeln"), findsOneWidget);
      expect(find.text("""Willkommen auf unserem Aniflix Chat! Wir sind eine deutsche Community und es werden ausschließlich deutschsprachige Unterhaltungen geführt, jegliche andere Sprachen sind untersagt (mit Ausnahme von Anime Begriffen wie z.b. Kawaii). Damit eine reibungslose Unterhaltung geführt werden kann. Fremdwerbung für andere inoffizielle Streaming Plattformen ausgenommen YT, sofern sie keine Anime Serien oder Stream Seiten hervorheben, sind untersagt. Spoiler zur aktuellen Season sind untersagt. (Infos über Handlungen der Folge, sowie detaillierte Gespräche über gewisse Geschehnisse und Story relevanten Ereignissen. Reizende Inhalte von Pornographischen Inhalten wie Bilder, Seiten, Links und Video Content sind untersagt. Dazu gehören auch jeglicher Art von Hentais oder anderweitigen Sexuelle orientierte Kategorien diversen Formen. Beleidigungen sind in jeder Form verboten. Feindlichkeiten gegen andere Nationalitäten, sowie rechtsradikale Äußerungen und Rassismus, werden nicht toleriert. Provokationen, Aufhetzungen und Mobbing gegen über anderen Usern ist nicht gestattet! Jeder soll mit Respekt und Anstand behandelt werden. Bei Aufforderung von Moderatoren, bzw. Admins, sind diese Folge zu leisten. Das Kommentieren von Entscheidungen der Moderatoren ist untersagt. Bei Verletzung des Regelwerkes werden Konsequenzen in Nachsicht gezogen, die nach Ermessen des zu der Zeit anwesenden Mods oder Admins getroffen werden. Bei Problemen und Fragen stehen euch die aktiven Mods und Admins gerne zu Verfügung.
              Mfg, Euer Aniflix Team."""), findsOneWidget);
    });

    /*needs mocked NetworkImage to run
    testWidgets("chat component", (WidgetTester tester) async {
      await tester.pumpWidget(TestChatComponent());

      expect(find.byType(ThemeText), findsWidgets);
     });*/
  });

}

class TestChatInput extends StatelessWidget{
  TestChatInput();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ChatInput([], (value){}),
      ),
    );
  }
}

class TestChatRulesDialog extends StatelessWidget{
  TestChatRulesDialog();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:ChatRulesDialog(),
      ),
    );
  }
}

/*class TestChatComponent extends StatelessWidget{
  TestChatComponent();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ChatComponent(new ChatMessage(1,1,1,"","","","", new User(1, "", "","","","","","","","",[]))),
      ),
    );
  }
}*/