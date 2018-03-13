class Stats {
  num time;
  num fee;
  num flow;

  Stats(this.time, this.fee, this.flow);

  @override
  String toString() {
    return 'Stats{time: $time, fee: $fee, flow: $flow}';
  }
}
