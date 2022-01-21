// import "list_controller.dart";
class log_controller{
  // var log_save_controller = list_controller("log");

  record(String action){
    var time = DateTime.now();
    String now = "{\"timestamp\": \"" + time.year.toString() + "-" +  time.month.toString() + "-" +  time.day.toString() + "T" +  time.hour.toString() + ":" +  time.minute.toString() + ":" +  time.second.toString() + ", \"action\": \"" + action + "\"}";
    // log_save_controller.add(action);
    print(now);
  }
}