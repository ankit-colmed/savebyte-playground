extension StringExtensions on String {
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidPassword {
    return length >= 6;
  }

  bool get isNotEmpty => trim().isNotEmpty;

  String get toCapitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}