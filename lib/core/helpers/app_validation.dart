import 'app_regex.dart';

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'الاسم مطلوب';
  } else if (value.length < 2) {
    return 'يجب أن يحتوي الاسم على حرفين على الأقل';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'البريد الإلكتروني مطلوب';
  } else if (!AppRegex.isEmailValid(value)) {
    return 'يرجى إدخال بريد إلكتروني جامعي صحيح';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'كلمة المرور مطلوبة';
  } else if (!AppRegex.isPasswordValid(value)) {
    return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل وتحتوي على حرف ورقم';
  }
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'يرجى تأكيد كلمة المرور';
  } else if (value != password) {
    return 'كلمتا المرور غير متطابقتين';
  }
  return null;
}

String? validateGrade(String? value) {
  if (value == null || value.isEmpty) {
    return 'يرجى إدخال المعدل';
  }

  final grade = int.tryParse(value);
  if (grade == null) {
    return 'الرجاء إدخال رقم صحيح صالح';
  }

  if (value.contains('.')) {
    return 'المعدل يجب أن يكون إلي أقرب رقم صحيح بدون كسور عشرية';
  }

  if (grade < 0 || grade > 100) {
    return 'يجب أن يكون المعدل بين 0 و 100';
  }

  return null;
}

String? validateFaculty(String? value) {
  if (value == null || value.isEmpty) {
    return 'الرجاء اختيار الكلية';
  }
  return null;
}

String? validateLevel(String? value) {
  if (value == null || value.isEmpty) {
    return 'الرجاء اختيار الفرقة';
  }
  return null;
}
