// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'Draws';

  @override
  String get newDraw => 'New draw';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get emptyState => 'No draws yet.\nTap \"New draw\" to create one.';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '1 word',
      zero: '0 words',
    );
    return '$_temp0';
  }

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteDrawTitle => 'Delete draw?';

  @override
  String deleteDrawMessage(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get formTitleNew => 'New draw';

  @override
  String get formTitleEdit => 'Edit draw';

  @override
  String get save => 'Save';

  @override
  String get nameLabel => 'Draw name';

  @override
  String get wordsLabel => 'Words';

  @override
  String get add => 'Add';

  @override
  String wordLabel(int index) {
    return 'Word $index';
  }

  @override
  String get deleteWordTooltip => 'Delete word';

  @override
  String get deleteWordTitle => 'Delete word?';

  @override
  String get deleteWordMessage => 'This word will be removed from the draw.';

  @override
  String get errorNameEmpty => 'Enter a name for the draw.';

  @override
  String get errorWordEmpty => 'Add at least one word.';

  @override
  String get drawnMessage => 'Word drawn!';

  @override
  String get noWords => 'This draw has no words.\nEdit it to add some.';

  @override
  String get draw => 'Draw';

  @override
  String get drawing => 'Drawing…';

  @override
  String get shakeTip => 'Tip: shake your phone to draw.';

  @override
  String get languageSection => 'Language';

  @override
  String get languageSub => 'Choose the app language.';

  @override
  String get langSystem => 'System default';

  @override
  String get licenseSection => 'License';

  @override
  String get licenseText =>
      'This is a free-code project, licensed under the GNU GPL-3.0. The app artworks are public domain (CC0 1.0).';

  @override
  String get licenseGithub => 'github.com/3duardobn/sorteio';

  @override
  String get contactSection => 'Contact';

  @override
  String get contactSub => 'Questions, suggestions and bug reports';

  @override
  String get contactSite => 'Website';

  @override
  String get contactEmail => 'Email';

  @override
  String get backupSection => 'Backup';

  @override
  String get backupSub => 'Save or share your draws as a JSON file.';

  @override
  String get export => 'Make a backup';

  @override
  String get exportShare => 'Share';

  @override
  String get exportSave => 'Save file';

  @override
  String get exportSubject => 'Sorteio app backup';

  @override
  String get exportEmpty => 'There are no draws to back up.';

  @override
  String get exportSuccess => 'Backup saved.';

  @override
  String get exportError => 'Could not generate the backup.';

  @override
  String get import => 'Restore backup';

  @override
  String get importTitle => 'Restore backup?';

  @override
  String importMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'This backup contains $count draws.',
      one: 'This backup contains 1 draw.',
    );
    return '$_temp0 Your current draws will be replaced. Continue?';
  }

  @override
  String importSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backup restored: $count draws.',
      one: 'Backup restored: 1 draw.',
    );
    return '$_temp0';
  }

  @override
  String get importError => 'Invalid backup file.';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsEmpty =>
      'No draws recorded yet.\nDraw some words to see the statistics.';

  @override
  String statsTotal(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total draws in total',
      one: '1 draw in total',
      zero: '0 draws in total',
    );
    return '$_temp0';
  }

  @override
  String statsDraws(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: '1 time',
      zero: '0 times',
    );
    return '$_temp0';
  }

  @override
  String get avoidRepeatLabel => 'Avoid repeating the last word';

  @override
  String get avoidRepeatSub => 'Does not draw the same word twice in a row.';

  @override
  String get deactivateLabel => 'Remove drawn word';

  @override
  String get deactivateSub =>
      'Each draw removes the word from the draw, like a raffle that shrinks.';

  @override
  String get allWordsDrawn => 'All words have been drawn. Restarting!';

  @override
  String get saveError => 'Could not save. Please try again.';

  @override
  String remainingWords(int restante, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      restante,
      locale: localeName,
      other: '$restante words left of $total',
      one: '1 word left of $total',
      zero: 'No words left of $total',
    );
    return '$_temp0';
  }
}
