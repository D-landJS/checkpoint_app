class ControlSets {
  late int id;
  late String name;
  late String description;
  // final int id;
  // final String name;
  // final String description;

  ControlSets({required id, required name, required description});

  ControlSets.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
  }

  // static ControlSets fromJson(json) => ControlSets(
  //       id: json["id"],
  //       name: json["name"],
  //       description: json["description"],
  //     );
}
