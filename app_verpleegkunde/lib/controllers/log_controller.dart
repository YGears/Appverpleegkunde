import "list_controller.dart";

class LogController {
  var dataControllerLog = list_controller("log");

  record(String action) {
    var timestamp = DateTime.now();

    String log_entry = "{\"timestamp\": \"" +
      timestamp.year.toString() +
      "-" +
      timestamp.month.toString() +
      "-" +
      timestamp.day.toString() +
      "T" +
      timestamp.hour.toString() +
      ":" +
      timestamp.minute.toString() +
      ":" +
      timestamp.second.toString() +
      "\", \"action\": \"" +
      action +
      "\"}";

    dataControllerLog.add(log_entry);
  }

  get() {
    return dataControllerLog.getList;
  }
}
