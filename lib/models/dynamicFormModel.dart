class DynamicFormData {
  final String name;
  final bool isActive;
  // final bool isFilled;
  final List<dynamic> form;
  final String formId;
  final String sheetName;
  final String createdAt;

  DynamicFormData(
      {required this.name,
      required this.isActive,
      // required this.isFilled,
      required this.form,
      required this.sheetName,
      required this.formId,
      required this.createdAt});

  factory DynamicFormData.fromJson(Map<String, dynamic> json) {
    return DynamicFormData(
        name: json['name'],
        isActive: json['isActive'],
        form: json['form'],
        formId: json['formId'],
        sheetName: json['sheetName'],
        createdAt: json['createdAt']);
  }

  // static List<FormField> parseFormFields(formJson) {
  //   var list = formJson['form'] as List;
  //   List<FormField> formsList =
  //       list.map((data) => FormField.fromJson(data)).toList();

  //   return formsList;
  // }
}

// class FormField {
//   final String type;
//   final String fieldName;

//   FormField({required this.type, required this.fieldName});

//   factory FormField.fromJson(Map<String, dynamic> parsedJson) {
//     return FormField(
//         type: parsedJson['type'], fieldName: parsedJson['fieldName']);
//   }
// }
