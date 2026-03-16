#include <errno.h>
#include <libgen.h>
#include <limits.h>
#include <process.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

// https://www.qnx.com/developers/docs/8.0/com.qnx.doc.neutrino.lib_ref/topic/c/_cmdname.html
// Returns the full path of the KinectSim image directory.
static int build_default_image_dir(char *out, size_t out_size) {
    char *exe_path = _cmdname(NULL);
    if (exe_path == NULL) {
        return -1;
    }

    char *exe_path_copy = strdup(exe_path);
    if (exe_path_copy == NULL) {
        return -1;
    }

    char *exe_dir = dirname(exe_path_copy);
    int written = snprintf(out, out_size, "%s/kinect_demo_images", exe_dir);

    free(exe_path_copy);

    if (written < 0 || (size_t)written >= out_size) {
        errno = ENAMETOOLONG;
        return -1;
    }

    return 0;
}

int main(int argc, char *argv[]) {
    char image_dir[PATH_MAX];

    if (argc > 1) {
        int written = snprintf(image_dir, sizeof(image_dir), "%s", argv[1]);
        if (written < 0 || (size_t)written >= sizeof(image_dir)) {
            fprintf(stderr, "image directory argument is too long\n");
            return 1;
        }
    } else if (build_default_image_dir(image_dir, sizeof(image_dir)) != 0) {
        perror("failed to determine default image directory");
        return 1;
    }

    printf("KinectSim at %s\n", image_dir);

    return 0;
}
