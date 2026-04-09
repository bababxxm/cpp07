/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.cpp                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sklaokli <sklaokli@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/09 23:51:37 by sklaokli          #+#    #+#             */
/*   Updated: 2026/04/09 23:52:27 by sklaokli         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <iostream>
#include <string>
#include "Array.hpp"

// --- Helpers ---

void test_header(std::string title) {
	std::cout << std::endl;
	std::cout << "\033[1;33m[ " << title << " ]\033[0m" << std::endl;
}

// --- Test Functions ---

void test1_basic_construction() {
	test_header("TEST 1: Basic Construction & Size");

	Array<int> empty;
	std::cout << "Empty array size: " << empty.size() << std::endl;

	unsigned int n = 5;
	Array<int> numbers(n);
	std::cout << "Sized array (5) size: " << numbers.size() << std::endl;

	std::cout << "Content (should be default-init to 0): ";
	for (unsigned int i = 0; i < numbers.size(); i++) std::cout << numbers[i] << " ";
	std::cout << std::endl;
}

void test2_deep_copy_constructor() {
	test_header("TEST 2: Deep Copy (Copy Constructor)");

	Array<int> original(3);
	original[0] = 1;
	original[1] = 2;
	original[2] = 3;

	Array<int> copy(original);
	copy[0] = 42;

	std::cout << "Original[0]: " << original[0] << " (should be 1)" << std::endl;
	std::cout << "Copy[0]: " << copy[0] << " (should be 42)" << std::endl;

	if (original[0] != copy[0])
		std::cout << "\033[1;32mSUCCESS: Deep copy verified!\033[0m" << std::endl;
	else
		std::cout << "\033[1;31mFAILURE: Shallow copy detected!\033[0m" << std::endl;
}

void test3_assignment_operator() {
	test_header("TEST 3: Deep Copy (Assignment Operator)");

	Array<std::string> a(2);
	a[0] = "Hello";
	a[1] = "World";

	Array<std::string> b;
	b = a;
	b[1] = "Bangkok";

	std::cout << "A: " << a[0] << " " << a[1] << std::endl;
	std::cout << "B: " << b[0] << " " << b[1] << std::endl;

	if (a[1] != b[1])
		std::cout << "\033[1;32mSUCCESS: Assignment deep copy verified!\033[0m" << std::endl;
}

void test4_exception_handling() {
	test_header("TEST 4: Exception Handling (Bounds Check)");

	Array<float> arr(3);
	try {
		std::cout << "Accessing index 2... " << arr[2] << " \033[0;32mOK\033[0m" << std::endl;
		std::cout << "Accessing index 3... ";
		std::cout << arr[3] << std::endl;
	} catch (const std::exception& e) {
		std::cout << "\033[1;31mCaught expected error: \033[0m" << e.what() << std::endl;
	}
}

void test5_const_array() {
	test_header("TEST 5: Const Array Access");

	const Array<int> c_arr(2);
	// c_arr[0] = 10; // This would cause a compiler error
	std::cout << "Const access index 0: " << c_arr[0] << " \033[0;32m(Read-only OK)\033[0m"
	          << std::endl;
}

void test6_complex_type() {
	test_header("TEST 6: Array of Arrays (Generic Depth)");

	Array<Array<int> > matrix(2);
	matrix[0] = Array<int>(2);
	matrix[1] = Array<int>(2);

	matrix[0][0] = 42;
	matrix[1][1] = 24;

	std::cout << "Matrix[0][0]: " << matrix[0][0] << std::endl;
	std::cout << "Matrix[1][1]: " << matrix[1][1] << std::endl;
}

int main() {
	test1_basic_construction();
	test2_deep_copy_constructor();
	test3_assignment_operator();
	test4_exception_handling();
	test5_const_array();
	test6_complex_type();
	return (0);
}
