/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Array.hpp                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sklaokli <sklaokli@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/09 23:39:15 by sklaokli          #+#    #+#             */
/*   Updated: 2026/04/09 23:50:26 by sklaokli         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef ARRAY_HPP
#define ARRAY_HPP

#include <exception>
#include <iostream>
#include <string>

template <typename T>
class Array {
private:
	T* _data;
	unsigned int _size;

public:
	// Orthodox Canonical Form
	Array(void);
	Array(unsigned int n);
	Array(const Array& other);
	Array& operator=(const Array& other);
	~Array(void);

	// Operator functions
	T& operator[](unsigned int index);
	const T& operator[](unsigned int index) const;

	// Member functions
	unsigned int size(void) const;

	// Generic Nested Exception Class
	class Error : public std::exception {
	private:
		std::string _msg;

	public:
		Error(const std::string& msg) : _msg(msg) {}
		virtual ~Error() throw() {}
		virtual const char* what() const throw() { return _msg.c_str(); }
	};
};

#include "Array.tpp"

#endif
