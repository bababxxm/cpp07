/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Array.hpp                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sklaokli <sklaokli@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/09 23:39:15 by sklaokli          #+#    #+#             */
/*   Updated: 2026/04/24 16:10:34 by sklaokli         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef ARRAY_HPP
#define ARRAY_HPP

#include <cstdlib>
#include <exception>
#include <iostream>
#include <string>

template <typename T>
class Array {
private:
	T* _data;
	unsigned int _size;

public:
	Array();
	Array(unsigned int);
	Array(const Array&);
	Array& operator=(const Array&);
	~Array();

	T& operator[](unsigned int);
	const T& operator[](unsigned int) const;

	unsigned int size() const;

	class ArrayException : public std::exception {
	private:
		const char* _msg;
		ArrayException();

	public:
		ArrayException(const ArrayException&);
		ArrayException& operator=(const ArrayException&);
		ArrayException(const char*);
		virtual ~ArrayException() throw();
		virtual const char* what() const throw();
	};
};

#include "Array.tpp"

#endif
