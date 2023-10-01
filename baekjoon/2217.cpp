#include <iostream>
#include <algorithm>
using namespace std;

int main(void) {
	int n;
	int max, current;
	int rope[100000];
	cin >> n;

	for (int i = 0; i < n; i++) {
		cin >> rope[i];
	}

	sort(rope, rope + n);
	max = rope[n - 1];
	for (int i = 0; i < n; i++) {
		current = rope[i] * (n - i);
		if (max < current)
			max = current;
	}
	cout << max;

	return 0;
}
