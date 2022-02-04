import "list_controller.dart";

class LogController {
  var dataControllerLog = list_controller("log");

  record(String action) {
    var timestamp = DateTime.now();

    String logEntry = "{\"timestamp\": \"" +
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

    dataControllerLog.add(logEntry);
  }

  get() {
    return dataControllerLog.getList;
  }
}
