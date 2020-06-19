import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:flutter/material.dart';

class ChatRulesDialog extends AlertDialog {
  ChatRulesDialog() : super();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      title: new ThemeText("Regeln"),
      content: SingleChildScrollView(
        child: ThemeText(
          """Willkommen auf unserem Aniflix Chat! Wir sind eine deutsche Community und es werden ausschließlich deutschsprachige Unterhaltungen geführt, jegliche andere Sprachen sind untersagt (mit Ausnahme von Anime Begriffen wie z.b. Kawaii). Damit eine reibungslose Unterhaltung geführt werden kann. Fremdwerbung für andere inoffizielle Streaming Plattformen ausgenommen YT, sofern sie keine Anime Serien oder Stream Seiten hervorheben, sind untersagt. Spoiler zur aktuellen Season sind untersagt. (Infos über Handlungen der Folge, sowie detaillierte Gespräche über gewisse Geschehnisse und Story relevanten Ereignissen. Reizende Inhalte von Pornographischen Inhalten wie Bilder, Seiten, Links und Video Content sind untersagt. Dazu gehören auch jeglicher Art von Hentais oder anderweitigen Sexuelle orientierte Kategorien diversen Formen. Beleidigungen sind in jeder Form verboten. Feindlichkeiten gegen andere Nationalitäten, sowie rechtsradikale Äußerungen und Rassismus, werden nicht toleriert. Provokationen, Aufhetzungen und Mobbing gegen über anderen Usern ist nicht gestattet! Jeder soll mit Respekt und Anstand behandelt werden. Bei Aufforderung von Moderatoren, bzw. Admins, sind diese Folge zu leisten. Das Kommentieren von Entscheidungen der Moderatoren ist untersagt. Bei Verletzung des Regelwerkes werden Konsequenzen in Nachsicht gezogen, die nach Ermessen des zu der Zeit anwesenden Mods oder Admins getroffen werden. Bei Problemen und Fragen stehen euch die aktiven Mods und Admins gerne zu Verfügung.
              Mfg, Euer Aniflix Team.""",
          softWrap: true,
          fontSize: 15,
        ),
      ),
    );
  }
}
