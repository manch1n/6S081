#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char **argv)
{
    int n = 2;
    int pipefd[2];
    int pid;
    pipe(pipefd);
    printf("prime 2\n");
    for (int i = 3; i <= 35; ++i)
    {
        if (i % 2 != 0)
        {
            write(pipefd[1], &i, sizeof(int));
        }
    }
    if ((pid = fork()) != 0) //parent
    {
        close(pipefd[0]);
        close(pipefd[1]);
        wait((int *)0);
    }

    while (pid == 0)
    {
        close(pipefd[1]);
        int ret = read(pipefd[0], &n, sizeof(int));
        if (ret == 0)
        {
            exit(0);
        }
        printf("prime %d\n", n);
        int nextPipefd[2];
        pipe(nextPipefd);
        int num;
        int writeOneFlag = 0;
        while ((ret = read(pipefd[0], &num, sizeof(int))) != 0)
        {
            if (num % n != 0)
            {
                writeOneFlag = 1;
                write(nextPipefd[1], &num, sizeof(int));
            }
        }
        if (writeOneFlag == 0)
        {
            exit(0);
        }
        close(pipefd[0]);
        pipefd[0] = nextPipefd[0];
        pipefd[1] = nextPipefd[1];
        if ((pid = fork()) != 0)
        {
            close(pipefd[0]);
            close(pipefd[1]);
            wait((int *)0);
        }
    }

    exit(0);
}