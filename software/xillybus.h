#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

const char *readDeviceFile = "/dev/xillybus_read_32";
const char *writeDeviceFile = "/dev/xillybus_write_32";

int initRead() {
	int fileDescriptor = open(readDeviceFile, O_RDONLY);
	if (fileDescriptor < 0) {
		if (errno == ENODEV)
			fprintf(stderr, "Maybe %s is a write-only file.\n", readDeviceFile);
		perror("Failed to open the device file for read");
		exit(1);
	}
	return fileDescriptor;
}

int initWrite() {
	int fileDescriptor = open(writeDeviceFile, O_WRONLY);
	if (fileDescriptor < 0) {
		if (errno == ENODEV)
			fprintf(stderr, "Maybe %s is a read-only file.\n", writeDeviceFile);
		perror("Failed to open the device file for write");
		exit(1);
	}
	return fileDescriptor;
}

void fpgaRead(int fileDescriptor, unsigned char *buffer, int length) {
	int received = 0;
	int rc;
	while (received < length) {
		rc = read(fileDescriptor, buffer + received, length - received);
		if ((rc < 0) && (errno == EINTR))
			continue;
		if (rc < 0) {
			perror("Failed to read");
			exit(1);
		}
		if (rc == 0) {
			fprintf(stderr, "Reached read EOF.\n");
			exit(0);
		}

		received += rc;
	}
}

void fpgaWrite(int fileDescriptor, unsigned char *buffer, int length) {
	int sent = 0;
	int rc;
	while (sent < length) {
		rc = write(fileDescriptor, buffer + sent, length - sent);
		if ((rc < 0) && (errno == EINTR))
			continue;
		if (rc < 0) {
			perror("Failed to write");
			exit(1);
		}
		if (rc == 0) {
			fprintf(stderr, "Reached write EOF ?!\n");
			exit(1);
		}
		sent += rc;
	}
}

void fpgaFlush(int fileDescriptor) {
	int rc;
	while (1) {
		rc = write(fileDescriptor, NULL, 0);
		if ((rc < 0) && (errno == EINTR))
			continue;
		if (rc < 0)
			perror("Failed to flush");
		break;
	}
}
