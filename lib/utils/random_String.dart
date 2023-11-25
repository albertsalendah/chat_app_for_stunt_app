import 'dart:math' as math;

class RandomString {
  String makeId(int length) {
    String result = "";
    const characters =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    int charactersLength = characters.length;
    int counter = 0;

    while (counter < length) {
      result += characters[math.Random().nextInt(charactersLength)];
      counter += 1;
    }

    return result;
  }
}
