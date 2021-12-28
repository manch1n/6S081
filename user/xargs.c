#include "kernel/types.h"
#include "user/user.h"
#include "kernel/param.h"

int pushArgs(char *buf, char **args, int argc, char **argv, int argcoffset)
{
    static int pushArgvFlag = 0;
    static int argNum = 1;
    if (pushArgvFlag == 0)
    {
        args[0] = argv[1];
        for (int i = argcoffset; i < argc; ++i)
        {
            args[argNum] = argv[i];
            argNum++;
        }
        pushArgvFlag = 1;
    }
    int begin = 0;
    int i = 0;
    for (i = 0; i < 512; ++i)
    {
        if (buf[i] == ' ')
        {
            args[argNum] = buf + begin;
            begin = i + 1;
            argNum++;
            buf[i] = '\0';
        }
        else if (buf[i] == '\0' || buf[i] == '\n')
        {
            if (i != 0)
            {
                args[argNum] = buf + begin;
                argNum++;
                if (buf[i] == '\n')
                {
                    buf[i] = '\0';
                }
            }
            break;
        }
    }
    return i + 1;
}

void read_line(char *buf)
{
    //escape " \n
    int num = 0;
    while (1)
    {
        char c;
        int ret = read(0, &c, sizeof(char));
        if (ret < 1)
        {
            break;
        }
        if (c == '"')
        {
            continue;
        }
        else if (c == '\\')
        {
            ret = read(0, &c, sizeof(char));
            if (ret < 1 || c == 'n')
            {
                break;
            }
        }
        buf[num] = c;
        num++;
    }
    buf[num] = '\0';
}

int main(int argc, char **argv)
{
    if (argc == 1)
    {
        fprintf(2, "usage: [args] | xargs (-n 1) [cmd]\n");
        exit(1);
    }
    if (strcmp(argv[1], "-n") == 0)
    {
        if (argc <= 3 || strcmp(argv[2], "1") != 0)
        {
            fprintf(2, "error\n");
            exit(1);
        }
        while (1)
        {
            char *args[MAXARG] = {0};
            char buf[512] = {0};
            read_line(buf);
            if (buf[0] == '\n' || buf[0] == '\0')
            {
                break;
            }
            pushArgs(buf, args, argc, argv, 4);
            if (fork() == 0) //child
            {
                exec(argv[3], args);
            }
            else
            {
                wait((int *)0);
            }
        }
    }
    else
    {
        char *args[MAXARG] = {0};
        char buf[512] = {0};
        int offset = 0;
        while (1)
        {
            gets(buf + offset, 511);
            if (buf[offset] == '\0' || buf[offset] == '\n')
            {
                break;
            }
            offset = pushArgs(buf, args, argc, argv, 2);
        }
        exec(argv[1], args);
    }
    exit(0);
}