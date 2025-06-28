import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  final _box = Hive.box('mybox');
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _isDarkMode = _box.get('isDarkMode', defaultValue: false) as bool;
  }

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _box.put('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  static final _lightTheme = ThemeData(
    primaryColor: Colors.yellow,
    scaffoldBackgroundColor: Colors.yellow[200],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.yellow,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.yellow,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.black; // Checkbox background when checked
        }
        return Colors.grey[300]; // Checkbox background when unchecked
      }),
      checkColor: WidgetStateProperty.all(Colors.white), // White tick
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.yellow,
      brightness: Brightness.light,
    ),
  );

  static final _darkTheme = ThemeData(
    primaryColor: Colors.grey[900],
    scaffoldBackgroundColor: Colors.grey[850],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      elevation: 0,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.yellow,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.yellow; // Checkbox background when checked
        }
        return Colors.grey[600]; // Checkbox background when unchecked
      }),
      checkColor: WidgetStateProperty.all(Colors.black), // Black tick
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.grey,
      brightness: Brightness.dark,
    ),
  );
}