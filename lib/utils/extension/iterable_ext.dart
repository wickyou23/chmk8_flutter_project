extension IterableExt on Iterable {
  Iterable shift(int number) {
    if (number <= 0) {
      return this;
    }

    final sub = this.length - number;
    return Iterable.generate(this.length, (index) {
      if (sub + index < this.length) {
        return this.elementAt(sub + index);
      } else {
        return this.elementAt(index - number);
      }
    });
  }
}