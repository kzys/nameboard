#include <LiquidCrystal.h>

LiquidCrystal lcd(13, 2, 12, 4, 8, 7);

struct Marquee {
    int count_;
    int next_;
    char buffer_[20 + 1];
    char message_[200];
};

void marquee_add_char(Marquee* m, char c) {
    m->message_[m->next_] = c;
    m->next_++;
}

void marquee_update(Marquee* m) {
    for (int i = 0; i < 20; i++) {
        char c = m->message_[(m->count_ + i) % (strlen(m->message_)+1)];
        if (c == '\0') {
            c = '\x14';
        }
        m->buffer_[i] = c;
    }
    m->buffer_[20] = '\0';

    m->count_++;
    if (m->count_ > strlen(m->message_)) {
        m->count_ = 0;
    }
}

Marquee marquee;

void setup() {
    Serial.begin(9600);

    lcd.begin(20, 2);
    lcd.setCursor(0, 0);

    marquee.count_ = 0;
    marquee.next_ = 0;
    marquee.message_[0] = '\0';
}

void receive() {
    while (Serial.available()) {
        int c = Serial.read();
        if (c == '\n') {
            marquee_add_char(&marquee, '\0');
            marquee.next_ = 0;
        } else {
            marquee_add_char(&marquee, c);
        }
    }
}

void loop() {
    marquee_update(&marquee);

    char* ptr = marquee.buffer_;
    lcd.setCursor(0, 0);
    lcd.print(ptr);

    receive();

    delay(200);
}

