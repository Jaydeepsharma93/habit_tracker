import 'package:isar/isar.dart';

part 'appsettings.g.dart';

@Collection()
class AppSettings {
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;
}
