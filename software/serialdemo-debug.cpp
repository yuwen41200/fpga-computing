/**
 * Serial Version Program
 * $ g++ -Wall -Wextra -Wpedantic -std=c++11 serialdemo-debug.cpp -o serialdemo-debug
 */

#include <iostream>
#include <cstdint>
#include <ctime>

using namespace std;

uint16_t frame0[256][256];

int main() {
	// Initialize 1 frame.
	for (int i = 0; i < 256; ++i)
		for (int j = 0; j < 256; ++j)
			frame0[i][j] = i * 256 + j;

	// Start extremely large calculation.
	clock_t timer = clock();

	// Calculate frame 0.
	for (int i = 0; i < 256; ++i)
		for (int j = 0; j < 256; ++j)
			for (int k = 0; k < 1024; ++k)
				frame0[i][j] = frame0[i][j] + (frame0[i][j] >> 3);

	// Finish extremely large calculation.
	timer = clock() - timer;

	// Output results.
	cout << "Results from frame 0: " << endl;
	for (int i = 0; i < 2; ++i)
		for (int j = 0; j < 256; ++j)
			cout << frame0[i][j] << " ";

	// End of the program.
	cout << endl << "Time elapsed: " << (float) timer / CLOCKS_PER_SEC << endl;
	return 0;
}
