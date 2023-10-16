class LectureProcess {
  // lesson have many lecture. Example Lesson idiom has: idiom about money lecture, friendship lecture, etc.
  int lectureID;
  int? progress;
  String uid;

  LectureProcess({
    required this.lectureID,
    this.progress,
    required this.uid,
  });
}
