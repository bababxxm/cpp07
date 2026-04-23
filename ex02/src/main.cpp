/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.cpp                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sklaokli <sklaokli@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/23 12:05:12 by sklaokli          #+#    #+#             */
/*   Updated: 2026/04/23 13:46:41 by sklaokli         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <iostream>
#include <string>
#include "Array.hpp"

#define B_CYAN "\033[1;36m"
#define B_YELLOW "\033[1;33m"
#define B_GREEN "\033[1;32m"
#define B_RED "\033[1;31m"
#define DIM "\033[2m"
#define RESET "\033[0m"

void test_header(const std::string& title) {
	std::cout << B_CYAN << "[ " << title << " ]" << RESET << std::endl;
}

void test1() {
	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
	test_header("TEST 1: Basic Construction & Size");

	Array<int> empty;
	std::cout << "Empty array size: " << empty.size() << std::endl;

	unsigned int n = 5;
	Array<int> numbers(n);
	std::cout << "Sized array (5) size: " << numbers.size() << std::endl;

	std::cout << "Content (default-init to 0): ";
	for (unsigned int i = 0; i < numbers.size(); i++)
		std::cout << numbers[i] << " ";
	std::cout << std::endl;
	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

void test2() {
	test_header("TEST 2: Deep Copy (Copy Constructor)");

	Array<int> original(3);
	original[0] = 1;
	original[1] = 2;
	original[2] = 3;

	Array<int> copy(original);
	copy[0] = 42;

	std::cout << "Original[0]: " << original[0] << " (Expect 1)" << std::endl;
	std::cout << "Copy[0]:     " << copy[0] << " (Expect 42)" << std::endl;

	if (original[0] != copy[0])
		std::cout << B_GREEN << "SUCCESS: Deep copy verified!" << RESET
		          << std::endl;
	else
		std::cout << B_RED << "FAILURE: Shallow copy detected!" << RESET
		          << std::endl;

	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

void test3() {
	test_header("TEST 3: Deep Copy (Assignment Operator)");

	Array<std::string> a(2);
	a[0] = "Hello";
	a[1] = "World";

	Array<std::string> b;
	b = a;
	b[1] = "Bangkok";

	std::cout << "A[1]: " << a[1] << " (Expect World)" << std::endl;
	std::cout << "B[1]: " << b[1] << " (Expect Bangkok)" << std::endl;

	if (a[1] != b[1])
		std::cout << B_GREEN << "SUCCESS: Assignment deep copy verified!"
		          << RESET << std::endl;

	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

void test4() {
	test_header("TEST 4: Exception Handling (Bounds Check)");

	Array<float> arr(3);
	try {
		std::cout << "Accessing index 2... " << arr[2] << " \033[0;32mOK\033[0m"
		          << std::endl;
		std::cout << "Accessing index 3... ";
		std::cout << arr[3] << std::endl;
	} catch (const std::exception& e) {
		std::cout << B_RED << "Caught expected error: " << RESET << e.what()
		          << std::endl;
	}

	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

void test5() {
	test_header("TEST 5: Const Array Access");

	const Array<int> c_arr(2);
	std::cout << "Const access index 0: " << c_arr[0] << " " << B_GREEN
	          << "(Read-only OK)" << RESET << std::endl;

	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

void test6() {
	test_header("TEST 6: Array of Arrays (Generic Depth)");

	Array<Array<int> > matrix(2);
	matrix[0] = Array<int>(2);
	matrix[1] = Array<int>(2);

	matrix[0][0] = 42;
	matrix[1][1] = 24;

	std::cout << "Matrix[0][0]: " << matrix[0][0] << std::endl;
	std::cout << "Matrix[1][1]: " << matrix[1][1] << std::endl;

	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

int main() {
	test1();
	test2();
	test3();
	test4();
	test5();
	test6();
	return 0;
}
