class ControlSet {
  late int id;
  late String name;
  late String description;
  late List<Questions> questions;
  late List<Pictures> pictures;

  ControlSet(
      {required int id,
      required String name,
      required String description,
      required List<Questions> questions,
      required List<Pictures> pictures});

  ControlSet.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions.add(Questions.fromJson(v));
      });
    }
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures.add(Pictures.fromJson(v));
      });
    }
  }
}

class Questions {
  late String question;
  late List<String> options;

  Questions({questions, options});

  Questions.fromJson(Map<String, dynamic> json) {
    question = json["question"];

    options = <String>[];
    json['options'].forEach((v) {
      options.add(v);
    });
  }
}

class Pictures {
  late String name;
  late String description;

  Pictures({required name, required description});

  Pictures.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    description = json["description"];
  }
}
