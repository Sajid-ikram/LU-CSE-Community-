class IndividualModel {
  String name;
  String url;
  String startTime;
  String duration;
  String endTime;
  String site;

  IndividualModel({
    required this.name,
    required this.duration,
    required this.url,
    required this.endTime,
    required this.startTime,
    required this.site,
  });

  factory IndividualModel.fromJson(Map<String, dynamic> json, bool haveSite) {
    String startTime = "", endTime = "";
    if (json["start_time"].contains(" UTC")) {
      startTime =
          json["start_time"].substring(0, json["start_time"].indexOf(' UTC'));

      endTime = json["end_time"].substring(0, json["end_time"].indexOf(' UTC'));
    } else {
      startTime = json["start_time"];
      endTime = json["end_time"];
    }
    return IndividualModel(
      name: json["name"],
      duration: json["duration"],
      startTime: startTime,
      url: json["url"],
      endTime: endTime,
      site: haveSite ? json["site"] : "",
    );
  }
}
