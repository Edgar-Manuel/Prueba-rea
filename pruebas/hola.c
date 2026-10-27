#include <stdio.h>
#include <string.h>

int checksum(const char *s) {
    int total = 0;
    for (size_t i = 0; i < strlen(s); i++) total = total * 31 + s[i];
    return total;
}

int main(int argc, char **argv) {
    const char *msg = argc > 1 ? argv[1] : "hola rea";
    printf("checksum(%s) = %d\n", msg, checksum(msg));
    return 0;
}
