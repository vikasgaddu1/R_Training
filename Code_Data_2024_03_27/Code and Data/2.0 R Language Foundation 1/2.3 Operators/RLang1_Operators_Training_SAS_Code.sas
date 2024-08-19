
data test;

** Setup;
a = 1;
b = 2;

** Arithmetic Operators **;
c = a + b;     * Addition;
c = a - b;     * Subtraction;
c = a * b;     * Multiplication;
c = a / b;     * Division;

c = a ** b;         * Exponent;
c = int(a / b);     * Quotient;
c = mod(a, b);      * Remainder;

** Relational Operators **;
d = (a = b);     * Comparison Equals; 
d = (a ^= b);    * Not Equal;  
d = (a > b);     * Greater Than;
d = (a < b);     * Less Than;
d = (a >= b);    * Greater Than or Equal To;
d = (a <= b);    * Less Than or Equal To;

run;


data test2;

** Setup;
a = 1;
b = 0;

** Logical Operators **;
e = (a & b);     * And;
e = (a | b);     * Or;
e = (e ^= a);    * Not;

run;



