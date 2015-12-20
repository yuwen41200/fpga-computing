/**
 * Sample Host Program
 * $ g++ -Wall -Wextra -Wpedantic -std=c++11 -pthread xillydemo.cpp -o xillydemo
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
		fpgaRead(fd, (unsigned char*) frame0[i], 2160);
	for (int i = 0; i < 1920; ++i)
		fpgaRead(fd, (unsigned char*) frame1[i], 2160);
	for (int i = 0; i < 1920; ++i)
		fpgaRead(fd, (unsigned char*) frame2[i], 2160);
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
	cout << "Some results from frame 0: " << frame0[0][0] << " "
	     << frame0[959][539] << " " << frame0[1919][1079] << endl;
	cout << "Some results from frame 1: " << frame1[0][0] << " "
	     << frame1[959][539] << " " << frame1[1919][1079] << endl;
	cout << "Some results from frame 2: " << frame2[0][0] << " "
	     << frame2[959][539] << " " << frame2[1919][1079] << endl;

	// End of the program.
	cout << "Time elapsed: " << (float) timer / CLOCKS_PER_SEC << endl;
	return 0;
}
