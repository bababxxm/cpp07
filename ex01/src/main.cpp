/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.cpp                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sklaokli <sklaokli@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/23 12:01:23 by sklaokli          #+#    #+#             */
/*   Updated: 2026/04/23 12:54:34 by sklaokli         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <iostream>
#include <string>
#include "iter.hpp"

#define B_CYAN "\033[1;36m"
#define B_YELLOW "\033[1;33m"
#define B_GREEN "\033[1;32m"
#define B_RED "\033[1;31m"
#define DIM "\033[2m"
#define RESET "\033[0m"

void test_header(const std::string& title) {
	std::cout << B_CYAN << "[ " << title << " ]" << RESET << std::endl;
}

void printInt(int& n) {
	std::cout << n << " ";
}

int multiplyByTwo(int& n) {
	n *= 2;
	return n;
}

struct Adder {
	int _amount;
	Adder(int amount) : _amount(amount) {}
	void operator()(int& n) const { n += _amount; }
};

struct StringPrinter {
	void operator()(std::string& s) const { std::cout << "[" << s << "] "; }
};

void test1() {
	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
	test_header("TEST 1: Basic Function Pointers");
	int intArray[] = {1, 2, 3, 4, 5};
	std::cout << "Original: ";
	::iter(intArray, 5, printInt);
	std::cout << std::endl;
	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

void test2() {
	test_header("TEST 2: Function with Return Value");
	int intArray[] = {1, 2, 3, 4, 5};
	::iter(intArray, 5, multiplyByTwo);
	std::cout << "Result (*2): ";
	::iter(intArray, 5, printInt);
	std::cout << std::endl;
	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

void test3() {
	test_header("TEST 3: Functors (Stateful Objects)");
	int intArray[] = {1, 2, 3, 4, 5};
	Adder add100(100);
	::iter(intArray, 5, add100);
	std::cout << "After +100: ";
	::iter(intArray, 5, printInt);
	std::cout << std::endl;
	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

void test4() {
	test_header("TEST 4: String Array (Generic T)");
	std::string strArray[] = {"42", "Bangkok", "C++", "Templates"};
	StringPrinter sPrinter;
	::iter(strArray, 4, sPrinter);
	std::cout << std::endl;
	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

void test5() {
	test_header("TEST 5: NULL Array Safety");
	int* nullArray = NULL;
	::iter(nullArray, 0, printInt);
	std::cout << B_GREEN << "SUCCESS: Handled 0 length safely!" << RESET
	          << std::endl;
	std::cout << DIM << "----------------------------------------" << RESET
	          << std::endl;
}

int main() {
	test1();
	test2();
	test3();
	test4();
	test5();
	return 0;
}
