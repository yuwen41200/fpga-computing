/**
 * Serial Version Program
 * $ g++ -Wall -Wextra -Wpedantic -std=c++11 serialdemo.cpp -o serialdemo
 */

#include <iostream>
#include <cstdint>
#include <ctime>

using namespace std;

uint16_t frame0[1920][1080];
uint16_t frame1[1920][1080];
uint16_t frame2[1920][1080];

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

	// Calculate frame 0.
	for (int i = 0; i < 1920; ++i)
		for (int j = 0; j < 1080; ++j)
			for (int k = 0; k < 1024; ++k)
				frame0[i][j] = frame0[i][j] + (frame0[i][j] >> 3);

	// Calculate frame 1.
	for (int i = 0; i < 1920; ++i)
		for (int j = 0; j < 1080; ++j)
			for (int k = 0; k < 1024; ++k)
				frame1[i][j] = frame1[i][j] + (frame1[i][j] >> 3);

	// Calculate frame 2.
	for (int i = 0; i < 1920; ++i)
		for (int j = 0; j < 1080; ++j)
			for (int k = 0; k < 1024; ++k)
				frame2[i][j] = frame2[i][j] + (frame2[i][j] >> 3);

	// Finish extremely large calculation.
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
