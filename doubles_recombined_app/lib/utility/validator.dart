class Validator {
  static String? NameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return '名前を入力してください';
    }
    value = value.trim();

    if (value.length > 12) {
      return '12文字以下にしてください';
    }
    return null;
  }

  static String? NameKanaValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'ふりがなを入力してください';
    }
    value = value.trim();

    if (value.length > 12) {
      return '12文字以下にしてください';
    }
    return null;
  }
}