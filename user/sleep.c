#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        fprintf(2, "usage: sleep [ticks_num]");
        exit(1);
    }
    int sleep_count = atoi(argv[1]);
    sleep(sleep_count);
    exit(0);
}