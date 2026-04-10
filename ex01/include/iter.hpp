/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   iter.hpp                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sklaokli <sklaokli@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/09 20:04:39 by sklaokli          #+#    #+#             */
/*   Updated: 2026/04/09 23:10:09 by sklaokli         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef ITER_HPP
#define ITER_HPP

#include <cstddef>

template <typename T, typename F> void iter(T *array, size_t length, F ft) {
  if (!array)
    return;
  for (size_t i = 0; i < length; i++) {
    ft(array[i]);
  }
}

// template <typename T, typename F>
// void _iter_exec(T* addr, size_t len, F ft) {
// 	if (!addr) return;
// 	for (size_t i = 0; i < len; i++) { ft(addr[i]); }
// }

// template <typename T, typename F>
// void iter(T* addr, size_t len, F ft) {
// 	_iter_exec(addr, len, ft);
// }

// template <typename T, typename R>
// void iter(T* addr, size_t len, R (*ft)(T&)) {
// 	if (!ft) return;
// 	_iter_exec(addr, len, ft);
// }

// template <typename T, typename R>
// void iter(T* addr, size_t len, R (*ft)(const T&)) {
// 	if (!ft) return;
// 	_iter_exec(addr, len, ft);
// }

#endif
