/**
 * Parallel Version Program w/ Datasize = Small
 * $ g++ -Wall -Wextra -Wpedantic -std=c++11 -pthread parallel-sm.cpp -o parallel-sm
 */

#include <iostream>
#include <cstdint>
#include <thread>
#include <ctime>
#include "xillybus.h"

using namespace std;

uint16_t frame0[256][256];
uint16_t frame1[256][256];

void sender() {
	int fd = initWrite();
	for (int i = 0; i < 256; ++i)
		fpgaWrite(fd, (unsigned char*) frame0[i], 512);
}

void receiver() {
	int fd = initRead();
	for (int i = 0; i < 256; ++i)
		fpgaRead(fd, (unsigned char*) frame1[i], 512);
}

int main() {
	// Initialize 1 frame.
	for (int i = 0; i < 256; ++i)
		for (int j = 0; j < 256; ++j)
			frame0[i][j] = i * 256 + j;

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
	for (int i = 0; i < 256; ++i)
		for (int j = 0; j < 256; ++j)
			cout << frame1[i][j] << " ";

	// End of the program.
	cout << endl << "Time elapsed: " << (float) timer / CLOCKS_PER_SEC << endl;
	return 0;
}
