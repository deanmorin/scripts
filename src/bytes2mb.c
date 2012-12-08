#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: bytes2mb <number of bytes>\n");
        return 1;
    }
    long long bytes = atoll(argv[1]);
    
    int numlen = strlen(argv[1]);
    char formatbase[] = "%%%d.2f %s";
    char format[strlen(formatbase) + numlen + 1];

    sprintf(format, formatbase, numlen, "%s\n");

    printf("%s bytes\n", argv[1]);
    printf(format, bytes / pow(2, 10), "KB");
    printf(format, bytes / pow(2, 20), "MB");
    printf(format, bytes / pow(2, 30), "GB");

    return 0;
}
