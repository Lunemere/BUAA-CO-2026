#include <stdio.h>
#include <stdbool.h>

int stack[50];
int top = -1;

void popin(char input);
char popout(void);

int main(void) {
    int lines;

    scanf("%d", &lines);

    getchar(); // remove the enter

    char temp;

    for (int i = 0; i < lines / 2; i++) {
        scanf("%c", &temp); // it wouldn't ignore the space
        popin(temp);
    }

    if (lines % 2 == 1) {
        getchar();
    }

    bool result = true;

    for (int i = 0; i < lines / 2; i++) {
        scanf("%c", &temp);
        if (temp != popout()) {
            result = false;
        }
    }

    if (result) {
        printf("true");
    }
    else {
        printf("false");
    }
}

void popin(char input) {
    stack[++top] = input;
}

char popout(void) {
    return stack[top--];
}