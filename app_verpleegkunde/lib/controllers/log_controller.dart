import "list_controller.dart";

class log_controller {
  var data_controller_log = list_controller("log");

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

    data_controller_log.add(log_entry);
  }

  get() {
    return data_controller_log.getList;
  }
}
