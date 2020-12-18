class ToDoTask {
  final String title;
  final String description;
  final String time;
  final int minutes;

  ToDoTask(this.title, this.description,this.time,this.minutes);

  ToDoTask.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        time = json['time'],
        minutes =json['minutes'];

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'decription': description,
        'time': time,
        'minutes': minutes,

      };
}