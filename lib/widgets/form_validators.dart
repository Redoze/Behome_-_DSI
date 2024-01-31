// Arquivo: form_validators.dart

class FormValidators {
  static String? amount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um valor válido';
    } else if (double.tryParse(value) == null) {
      return 'Por favor, insira um valor válido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma senha válida';
    } else if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um email válido';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma senha válida';
    } else if (value != password) {
      return 'As senhas não coincidem';
    }
    return null;
  }
}
