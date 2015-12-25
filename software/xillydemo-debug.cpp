/**
 * Sample Host Program
 * $ g++ -Wall -Wextra -Wpedantic -std=c++11 -pthread xillydemo-debug.cpp -o xillydemo-debug
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
	for (int i = 0; i < 1920; ++i) {
		fpgaWrite(fd, (unsigned char*) frame0[i], 2160);
		cout << "Row " << i << " in frame 0 has been sent." << endl;
	}
	for (int i = 0; i < 1920; ++i) {
		fpgaWrite(fd, (unsigned char*) frame1[i], 2160);
		cout << "Row " << i << " in frame 1 has been sent." << endl;
	}
	for (int i = 0; i < 1920; ++i) {
		fpgaWrite(fd, (unsigned char*) frame2[i], 2160);
		cout << "Row " << i << " in frame 2 has been sent." << endl;
	}
	fpgaFlush(fd);
}

void receiver() {
	int fd = initRead();
	for (int i = 0; i < 1920; ++i) {
		fpgaRead(fd, (unsigned char*) frame3[i], 2160);
		cout << "Row " << i << " in frame 0 has been received." << endl;
	}
	for (int i = 0; i < 1920; ++i) {
		fpgaRead(fd, (unsigned char*) frame4[i], 2160);
		cout << "Row " << i << " in frame 1 has been received." << endl;
	}
	for (int i = 0; i < 1920; ++i) {
		fpgaRead(fd, (unsigned char*) frame5[i], 2160);
		cout << "Row " << i << " in frame 2 has been received." << endl;
	}
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
	cout << endl << "Results from frame 0: " << endl;
	for (int i = 0; i < 1920; ++i)
		for (int j = 0; j < 1080; ++j)
			cout << frame3[i][j] << " ";
	cout << endl << "Results from frame 1: " << endl;
	for (int i = 0; i < 1920; ++i)
		for (int j = 0; j < 1080; ++j)
			cout << frame4[i][j] << " ";
	cout << endl << "Results from frame 2: " << endl;
	for (int i = 0; i < 1920; ++i)
		for (int j = 0; j < 1080; ++j)
			cout << frame5[i][j] << " ";

	// End of the program.
	cout << "Time elapsed: " << (float) timer / CLOCKS_PER_SEC << endl;
	return 0;
}
