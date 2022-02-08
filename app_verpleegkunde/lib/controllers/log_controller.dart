import "list_controller.dart";

class LogController {
  ListController logController = ListController("log");

  record(String action) {
    DateTime time = DateTime.now();
    String now = "{\"timestamp\": \"" +
        time.year.toString() +
        "-" +
        time.month.toString() +
        "-" +
        time.day.toString() +
        "T" +
        time.hour.toString() +
        ":" +
        time.minute.toString() +
        ":" +
        time.second.toString() +
        "\", \"action\": \"" +
        action +
        "\"}";
    logController.add(now);
  }

  get() {
    return logController.getList;
  }
}
