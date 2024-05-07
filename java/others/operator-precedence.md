# Operator Precedence

In Java, operator precedence determines the order in which operators are evaluated in an expression. Operators with higher precedence are evaluated before operators with lower precedence. If operators have the same precedence, they are evaluated from left to right.

Here's a general overview of operator precedence in Java, from highest to lowest precedence:

1. Postfix operators: `expr++`, `expr--`
2. Unary operators: `++expr`, `--expr`, `+expr`, `-expr`, `!expr`, `~expr`, `(type)expr`
3. Multiplicative operators: `*`, `/`, `%`
4. Additive operators: `+`, `-`
5. Shift operators: `<<`, `>>`, `>>>`
6. Relational operators: `<`, `<=`, `>`, `>=`, `instanceof`
7. Equality operators: `==`, `!=`
8. Bitwise AND: `&`
9. Bitwise XOR: `^`
10. Bitwise OR: `|`
11. Logical AND: `&&`
12. Logical OR: `||`
13. Ternary operator: `? :`
14. Assignment operators: `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `&=`, `^=`, `|=`, `<<=`, `>>=`, `>>>=`

**Parentheses `()` can be used to override the default precedence and force evaluation of parts of an expression first.**
