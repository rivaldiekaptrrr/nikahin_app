import 'package:uuid/uuid.dart';

class UuidUtils {
  static const Uuid _uuid = Uuid();

  /// Generates a standard v4 UUID string
  static String generateId() => _uuid.v4();
}
