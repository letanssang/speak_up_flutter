class LectureProcess {
  int processID;

  // lesson have many lecture. Example Lesson idiom has: idiom about money lecture, friendship lecture, etc.
  int lectureID;
  int process;
  String uid;

  LectureProcess({
    required this.processID,
    required this.lectureID,
    required this.process,
    required this.uid,
  });
}
