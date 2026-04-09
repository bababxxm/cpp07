/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.cpp                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sklaokli <sklaokli@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/09 21:15:14 by sklaokli          #+#    #+#             */
/*   Updated: 2026/04/09 23:10:31 by sklaokli         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <iostream>
#include <string>
#include "iter.hpp"

// --- Helpers and Functors (Global Scope for C++98) ---

void test_header(std::string title) {
	std::cout << std::endl;
	std::cout << "\033[1;36m[ " << title << " ]\033[0m" << std::endl;
}

void printInt(int& n) {
	std::cout << n << " ";
}
void displayInt(const int& n) {
	std::cout << n << " ";
}

int multiplyByTwo(int& n) {
	n *= 2;
	return n;
}

struct Adder {
	int _amount;
	Adder(int amount) : _amount(amount) {}
	void operator()(int& n) { n += _amount; }
};

struct StringPrinter {
	void operator()(std::string& s) { std::cout << "[" << s << "] "; }
};

// --- Test Functions ---

void test1_basic_pointers() {
	test_header("TEST 1: Basic Function Pointers");
	int intArray[] = {1, 2, 3, 4, 5};
	std::cout << "Original: ";
	::iter(intArray, 5, printInt);
	std::cout << std::endl;
}

void test2_return_values() {
	test_header("TEST 2: Function with Return Value (R deduction)");
	int intArray[] = {1, 2, 3, 4, 5};
	::iter(intArray, 5, multiplyByTwo);
	std::cout << "Result (*2): ";
	::iter(intArray, 5, printInt);
	std::cout << std::endl;
}

void test3_functors() {
	test_header("TEST 3: Functors (Stateful Objects)");
	int intArray[] = {1, 2, 3, 4, 5};
	Adder add100(100);
	::iter(intArray, 5, add100);
	std::cout << "After +100: ";
	::iter(intArray, 5, printInt);
	std::cout << std::endl;
}

void test4_generic_types() {
	test_header("TEST 4: String Array (Generic T)");
	std::string strArray[] = {"42", "Bangkok", "C++", "Templates"};
	StringPrinter sPrinter;
	::iter(strArray, 4, sPrinter);
	std::cout << std::endl;
}

void test5_null_array() {
	test_header("TEST 5: NULL Array Safety");
	int* nullArray = NULL;
	::iter(nullArray, 5, printInt);
	std::cout << "\033[1;32mSUCCESS: No crash on NULL array!\033[0m" << std::endl;
}

void test6_null_function() {
	test_header("TEST 6: NULL Function Pointer Safety");
	int intArray[] = {1, 2, 3};
	void (*nullFunc)(int&) = NULL;
	::iter(intArray, 3, nullFunc);
	std::cout << "\033[1;32mSUCCESS: No crash on NULL function pointer!\033[0m" << std::endl;
}

void test7_const_null_hint() {
	test_header("TEST 7: Const NULL Function Safety (The Hint)");
	int intArray[] = {1, 2, 3};
	void (*nullConstFunc)(const int&) = NULL;

	std::cout << "Testing NULL pointer with 'const int&' parameter..." << std::endl;
	::iter(intArray, 3, nullConstFunc);
	std::cout << "\033[1;32mSUCCESS: Const NULL caught by specialized template!\033[0m"
	          << std::endl;
}

int main() {
	test1_basic_pointers();
	test2_return_values();
	test3_functors();
	test4_generic_types();
	test5_null_array();
	// test6_null_function();
	// test7_const_null_hint();
	return (0);
}
