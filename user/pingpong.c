#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char **argv)
{
    int pipefd[2];
    pipe(pipefd);
    if (fork() == 0) //child
    {
        char pingpongball;
        read(pipefd[0], &pingpongball, 1);
        int pid = getpid();
        printf("%d: received ping\n", pid);
        write(pipefd[1], &pingpongball, 1);
    }
    else //parent
    {
        char pingpongball;
        write(pipefd[1], &pingpongball, 1);
        read(pipefd[0], &pingpongball, 1);
        int pid = getpid();
        printf("%d: received pong\n", pid);
    }
    close(pipefd[0]);
    close(pipefd[1]);
    exit(0);
}