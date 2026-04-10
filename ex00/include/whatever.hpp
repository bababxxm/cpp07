/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Whatever.hpp                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sklaokli <sklaokli@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/09 19:16:01 by sklaokli          #+#    #+#             */
/*   Updated: 2026/04/09 19:32:54 by sklaokli         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef WHATEVER_HPP
#define WHATEVER_HPP

#include <iostream>
#include <string>

template <typename T> void swap(T &a, T &b) {
  T temp = a;
  a = b;
  b = temp;
}

template <typename T> const T &min(const T &a, const T &b) {
  return (a < b ? a : b);
}

template <typename T> const T &max(const T &a, const T &b) {
  return (a > b ? a : b);
}

#endif
