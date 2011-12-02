#include <LiquidCrystal.h>

LiquidCrystal lcd(13, 2, 12, 4, 8, 7);

char* MESSAGES[] = {
  // Git / GitHub
  "There is no way to  do CVS right        ",
  "GitHub              Social Coding       ",
  "GitHub Tokyo Meetup \xb7\xde\xaf\xc4\xca\xcc\xde\xc4\xb3\xb7\xae\xb3 \xd0-\xc4\xb1\xaf\xcc\xdf",
  // Me
  "I'm Kato Kazuyoshi  \xdc\xc0\xbc \xca \xb6\xc4\xb3 \xb6\xbd\xde\xd6\xbc \xc3\xde\xbd ",
  "github.com/kzys     8-p.info/           ",
  "I'm @kzys                               ",
  // Others
  "This \"name board\"   works on Arduino Uno ",
};
int count = 0;
int SMOOTHNESS = 7;
int now = 0;
int next = 1;
char buffer[20 * 2 + 1];

void setup() {
  lcd.begin(20, 2);
  lcd.setCursor(0, 0);
#if 0
  memset(buffer, ' ', 20 * 2);
#else
  for (int i = 0; i < 20 * 2 + 1; i++) {
    buffer[i] = '!' + i;
  }
  buffer[20 * 2] = '\0';

  lcd.setCursor(0, 0);
  lcd.print(buffer);
  lcd.setCursor(0, 1);
  lcd.print(buffer+20);
  delay(1000);
#endif
}

void loop() {
  for (int i = 0; i < 20 * 2 + 1; i++) {
    char diff = MESSAGES[next][i] - MESSAGES[now][i];
    buffer[i] = MESSAGES[now][i] + (diff * count >> SMOOTHNESS);
  }
  buffer[20 * 2] = '\0';

  lcd.setCursor(0, 0);
  lcd.print(buffer);
  lcd.setCursor(0, 1);
  lcd.print(buffer+20);

  if (count < (1 << SMOOTHNESS)) {
    count += 1;
    delay(5);
  } else {
    count = 0;
    delay(10000);

    now = next;
    next = random(sizeof(MESSAGES) / sizeof(MESSAGES[1]));
  }
}

