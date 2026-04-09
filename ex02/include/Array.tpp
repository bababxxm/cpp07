/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Array.tpp                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sklaokli <sklaokli@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/09 23:39:53 by sklaokli          #+#    #+#             */
/*   Updated: 2026/04/10 05:51:39 by sklaokli         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef ARRAY_TPP
#define ARRAY_TPP

template <typename T>
Array<T>::Array() : _data(NULL), _size(0) {}

template <typename T>
Array<T>::Array(unsigned int n) : _size(n) {
	_data = new T[n]();
}

template <typename T>
Array<T>::Array(const Array& other) : _size(other._size) {
	_data = new T[_size]();
	for (unsigned int i = 0; i < _size; i++) { _data[i] = other._data[i]; }
}

template <typename T>
Array<T>& Array<T>::operator=(const Array& other) {
	if (this != &other) {
		delete[] _data;
		_size = other._size;
		_data = new T[_size]();
		for (unsigned int i = 0; i < _size; i++) { _data[i] = other._data[i]; }
	}
	return *this;
}

template <typename T>
Array<T>::~Array() {
	delete[] _data;
}

template <typename T>
T& Array<T>::operator[](unsigned int index) {
	if (index >= _size) throw Error("Array: Index out of bounds");
	return _data[index];
}

template <typename T>
const T& Array<T>::operator[](unsigned int index) const {
	if (index >= _size) throw Error("Array: Index out of bounds (const)");
	return _data[index];
}

template <typename T>
unsigned int Array<T>::size() const {
	return _size;
}

#endif
