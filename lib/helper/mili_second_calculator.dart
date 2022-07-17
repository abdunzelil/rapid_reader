int miliSecondCalculator(int wordDeger, int speedDeger) {
  int miliSecon = 200;
  if (wordDeger == 1) {
    miliSecon = (60000 / speedDeger).round();
  } else if (wordDeger == 2) {
    miliSecon = (60000 / speedDeger * 2).round();
  }
  return miliSecon;
}
