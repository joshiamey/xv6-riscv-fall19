#include "kernel/syscall.h"
#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if (argc > 1)
    {
        fprintf(2, "Usage: pingpong (no args) \n");
        exit(1);
    }

    int parent_fd[2];
    int child_fd[2];

    if (pipe(parent_fd) < 0)
    {
        fprintf(2, "error creating pipe for parent fds \n");
        exit(1);
    }
    if (pipe(child_fd) < 0)
    {
        fprintf(2, "error creating pipe for child fds \n");
        exit(1);
    }

    int pid = fork();

    if (pid < 0)
    {
        fprintf(2, "Error creating child process \n");
        exit(1);
    }
    else if (pid == 0)
    {

        char buf[1];
        int child_pid = getpid();
        close(parent_fd[1]);
        close(child_fd[0]);
        // fprintf(1, " Child process [%d].\n", child_pid);

        int n = read(parent_fd[0], buf, sizeof(buf));
        close(parent_fd[0]);
        if (n < 0)
        {
            fprintf(2, "Read error in child.\n");
            exit(1);
        }
        else if (n == 0)
        {
            fprintf(2, " parent_fd[0] closed nothing read\n");
            exit(1);
        }
        else
        {
            // fprintf(1, " Read %d bytes from parent [%s]\n", n, buf);
            fprintf(1, "%d: received ping\n", child_pid);
            if (write(child_fd[1], "p", sizeof(buf)) != n)
            {
                fprintf(2, " write error sending pong to parent.\n");
                exit(1);
            }
            // else
            // {
            //     fprintf(1, " write sucess sending pong to parent.\n");
            // }
            close(child_fd[1]);
        }
        exit(0);
    }
    else
    {
        /* parent process */
        char buf[1];
        int parent_pid = getpid();
        close(parent_fd[0]);
        close(child_fd[1]);
        // fprintf(1, " Parent process [%d].\n", parent_pid);

        if (write(parent_fd[1], "p", sizeof(buf)) != sizeof(buf))
        {
            fprintf(2, " write error sending ping to child.\n");
            exit(1);
        }
        // else
        // {
        //     fprintf(1, "wrote 1 byte to parent pipe \n");
        // }
        close(parent_fd[1]);
        // fprintf(1, "Waiting for Child process\n");
        wait(0);
        int n = read(child_fd[0], buf, sizeof(buf));
        // fprintf(1, "Child process exited \n");
        if (n < 0)
        {
            fprintf(2, "Read error in parent.\n");
            exit(1);
        }
        else if (n == 0)
        {
            fprintf(2, " child_fd[0] closed nothing read\n");
            exit(1);
        }
        else
        {
            // fprintf(1, " Read %d bytes from child \n", n);
            fprintf(1, "%d: received pong\n", parent_pid);
        }
        close(child_fd[0]);
    }
    exit(0);
}