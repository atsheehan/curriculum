**Recursion** refers to the ability of a problem to be solved by repeatedly solving smaller versions of the same problem. In simpler terms, recursion is the ability of a method or function to internally calls itself.

### Learning Goals

* Understand recursion
* Examine a few examples of recursive problem-solving

### Solving Problems Recursively

#### Factorial

[Factorial - Wikipedia](http://en.wikipedia.org/wiki/Factorial)

From Wikipedia:

> In mathematics, the factorial of a non-negative integer n, denoted by n!, is the product of all positive integers less than or equal to n.

For example, the factorial of 5 is 120 or (5 * 4 * 3 * 2 * 1).

**Try to write a ruby program that calculates the factorial of a given number.**

**Spoiler Alert!** - Here is an [example solution for finding factorials](https://gist.github.com/HeroicEric/1220d0c320c6ae98b921).

#### Fibonacci Numbers

[Fibonacci Numbers - Wikipedia](http://en.wikipedia.org/wiki/Fibonacci_number)

Can you identify the pattern here?

`0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610`

This series of numbers is referred to as the **Fibonacci Numbers** or **Fibonacci Series**. Starting with 0 and 1, we can calculate the next number in the series by summing up the previous two numbers.

```ruby
# 0 1
0 + 1 = 1

# 0 1 1
1 + 1 = 2

# 0 1 1 2
2 + 1 = 3

# 0 1 1 2 3
2 + 3 = 5
```

A common programming interview question is to calculate the **nth** number in the Fibonacci Series, which is most commonly solved using recursion.

**Try writing a program that does this.** As an extra challenge, try to optimize
your solution so that you can find the 1000th number in the Fibonacci Series in
under a second.

**Spoiler Alert!** - Here is an [example solution for Fibonacci](https://gist.github.com/HeroicEric/4eaaf6d3158f0af29aa5).

#### Additional Common Programming Puzzles Solved with Recursion

- [Greatest Common Divisor (gcd)]( http://en.wikipedia.org/wiki/Greatest_common_divisor)
- [Eight Queens Puzzle](http://en.wikipedia.org/wiki/Eight_queens_puzzle)
- [Towers of Hanoi (challenging!)](http://en.wikipedia.org/wiki/Tower_of_Hanoi)

### Why This Matters

Once you understand that at its simplest, recursion is the act of solving small versions of a larger problem repetitively until the entire problem is solved you may start to uncover elegant solutions to your own problems that leverage recursion.

### Resources

- Chapter 10.1 - Learn to Program - Chris Pine
- [Recursion Wikipedia](http://en.wikipedia.org/wiki/Recursion_(computer_science))
- [Video - Ruby Kickstart - Introduction to Recursion](http://vimeo.com/24716767)
- [Video - Killing Fibonacci](http://confreaks.com/videos/2741-wickedgoodruby-killing-fibonacci)
- [Project Euler - Even Fibonacci numbers](http://projecteuler.net/index.php?section=problems&id=2)
- [Inception All Over Again: Recursion, Factorials, And Fibonacci In Ruby](http://natashatherobot.com/recursion-factorials-fibonacci-ruby/)
