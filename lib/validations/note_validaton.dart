class NoteValidation {
  String? validateTitle(String val) {
    if (val.length < 3) {
      return 'Please enter at least 3 characters';
    }
  }

  String? validateDescription(String val) {
    if (val.length < 3) {
      return 'Please enter at least 3 characters';
    }
  }

  String? validateUrl(String val) {
    if (val.length < 3) {
      return 'Please enter at least 3 characters';
    } else {
      bool _validURL = Uri.parse(val).isAbsolute;
      if (_validURL == false) {
        return 'Please enter valid url';
      }
    }
  }
}
