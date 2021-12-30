#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void recur_search(const char *path, const char *target)
{
    struct dirent de;
    struct stat st;
    int fd = open(path, 0);
    while (read(fd, &de, sizeof(de)) == sizeof(de))
    {
        if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
        {
            continue;
        }
        if (de.inum == 0)
        {
            continue;
        }
        char fileRelatiPath[512] = {0};
        strcpy(fileRelatiPath, path);
        char *p = fileRelatiPath + strlen(path);
        *p = '/';
        ++p;
        memcpy(p, de.name, DIRSIZ);
        p[DIRSIZ] = '\0';
        if (stat(fileRelatiPath, &st) < 0)
        {
            printf("ls: cannot stat %s\n", fileRelatiPath);
            continue;
        }
        if (st.type == T_DIR)
        {
            recur_search(fileRelatiPath, target);
        }
        else
        {
            if (strcmp(de.name, target) == 0)
            {
                printf("%s\n", fileRelatiPath);
            }
        }
    }
    close(fd);
}

int main(int argc, char **argv)
{
    if (argc != 3)
    {
        printf("usage: find [path] [specificname]\n");
        exit(1);
    }
    struct stat st;
    int rootFd = open(argv[1], 0);
    if (rootFd < 0)
    {
        fprintf(2, "find: cannot open %s\n", argv[1]);
        exit(1);
    }
    if (fstat(rootFd, &st) < 0)
    {
        fprintf(2, "find: cannot stat %s\n", argv[1]);
        close(rootFd);
        exit(1);
    }
    if (st.type != T_DIR)
    {
        fprintf(2, "just directory %s\n", argv[1]);
    }
    close(rootFd);
    recur_search(argv[1], argv[2]);
    exit(0);
}