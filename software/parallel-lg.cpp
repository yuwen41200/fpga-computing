/**
 * Sample Host Program w/ Datasize = Large
 * $ g++ -Wall -Wextra -Wpedantic -std=c++11 -pthread parallel-lg.cpp -o parallel-lg
 */

#include <iostream>
#include <cstdint>
#include <thread>
#include <ctime>
#include "xillybus.h"

using namespace std;

uint16_t frame0[1920][1080];
uint16_t frame1[1920][1080];
uint16_t frame2[1920][1080];
uint16_t frame3[1920][1080];
uint16_t frame4[1920][1080];
uint16_t frame5[1920][1080];

void sender() {
	int fd = initWrite();
	for (int i = 0; i < 1920; ++i)
		fpgaWrite(fd, (unsigned char*) frame0[i], 2160);
	for (int i = 0; i < 1920; ++i)
		fpgaWrite(fd, (unsigned char*) frame1[i], 2160);
	for (int i = 0; i < 1920; ++i)
		fpgaWrite(fd, (unsigned char*) frame2[i], 2160);
	fpgaFlush(fd);
}

void receiver() {
	int fd = initRead();
	for (int i = 0; i < 1920; ++i)
		fpgaRead(fd, (unsigned char*) frame3[i], 2160);
	for (int i = 0; i < 1920; ++i)
		fpgaRead(fd, (unsigned char*) frame4[i], 2160);
	for (int i = 0; i < 1920; ++i)
		fpgaRead(fd, (unsigned char*) frame5[i], 2160);
}

int main() {
	// Initialize 3 frames.
	for (int i = 0; i < 1920; ++i) {
		for (int j = 0; j < 1080; ++j) {
			frame0[i][j] = 0;
			frame1[i][j] = 127;
			frame2[i][j] = 255;
		}
	}

	// Start extremely large calculation.
	clock_t timer = clock();
	thread send(sender);
	thread recv(receiver);

	// Finish extremely large calculation.
	send.join();
	recv.join();
	timer = clock() - timer;

	// Output results.
	cout << "Some results from frame 0: " << frame3[0][0] << " "
	     << frame3[959][539] << " " << frame3[1919][1079] << endl;
	cout << "Some results from frame 1: " << frame4[0][0] << " "
	     << frame4[959][539] << " " << frame4[1919][1079] << endl;
	cout << "Some results from frame 2: " << frame5[0][0] << " "
	     << frame5[959][539] << " " << frame5[1919][1079] << endl;

	// End of the program.
	cout << "Time elapsed: " << (float) timer / CLOCKS_PER_SEC << endl;
	return 0;
}
