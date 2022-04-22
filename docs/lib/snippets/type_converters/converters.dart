// #docregion start
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart' as j;

part 'converters.g.dart';

@j.JsonSerializable()
class Preferences {
  bool receiveEmails;
  String selectedTheme;

  Preferences(this.receiveEmails, this.selectedTheme);

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$PreferencesToJson(this);
}
// #enddocregion start

// #docregion converter
// stores preferences as strings
class PreferenceConverter extends TypeConverter<Preferences, String>
    with JsonTypeConverter<Preferences, String> {
  const PreferenceConverter();
  @override
  Preferences? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Preferences.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String? mapToSql(Preferences? value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}
// #enddocregion converter

// #docregion table
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  TextColumn get preferences =>
      text().map(const PreferenceConverter()).nullable()();
}
// #enddocregion table
