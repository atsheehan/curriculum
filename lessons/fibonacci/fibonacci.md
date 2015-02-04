# Fibonacci Numbers

[Fibonacci Numbers - Wikipedia](http://en.wikipedia.org/wiki/Fibonacci_number)

Can you identify the pattern here?

`1 1 2 3 5 8 13 21 34 55 89 144 233 377 610`

This series of numbers is referred to as the **Fibonacci Numbers** or
**Fibonacci Series**. Starting with 0 and 1, we can calculate the next number
in the series by summing up the previous two numbers.

A common programming interview question is to calculate the **nth** number in
the Fibonacci Series, which is most commonly solved using recursion.

## Instructions

Write a program that calculates the nth number in Fibonacci series.

As an extra challenge, try to optimize your solution so that you can find
the 1000th number in the Fibonacci Series in under a second.

> Hint: You can use
> [Benchmark](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/benchmark/rdoc/Benchmark.html)
> to measure the time that your code takes to run.

## Example

```
fibonacci(6)
=> 8

fibonacci(8)
=> 21

fibonacci(13)
=> 233
```
