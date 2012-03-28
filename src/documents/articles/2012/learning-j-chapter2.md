--- yaml
layout: 'article'
title: 'Learning J - Chapter 2: Lists and Tables'
author: 'Yongjae Choi'
date: '2012-02-24'
tags: ['javascript', 'CPS', 'programming', 'continuation']
---

## chapter 2: 리스트와 테이블

Computations need data. So far we have seen data only as single numbers or lists of numbers. We can have other things by way of data, such as tables for example. Things like lists and tables are called "arrays".

## 2.1 Tables
A table with, say, 2 rows and 3 columns can be built with the $ function:

	   table =: 2 3   $   5 6 7  8 9 10
	   table
	5 6  7
	8 9 10

The scheme here is that the expression (x $ y) builds a table. The dimensions of the table are given by the list x which is of the form number-of-rows followed by number-of-columns. The elements of the table are supplied by the list y.
Items from y are taken in order, so as to fill the first row, then the second, and so on. The list y must contain at least one item. If there are too few items in y to fill the whole table, then y is re-used from the beginning.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>2 4 $ 5 6 7 8 9</tt></td>
<td><tt>2 2 $ 1</tt></td>
</tr><tr valign="TOP">
<td><tt>5 6 7 8<br>
9 5 6 7</tt></td>
<td><tt>1 1<br>
1 1</tt></td>
</tr></tbody></table>

The $ function offers one way to build tables, but there are many more ways: see Chapter 05.

Functions can be applied to whole tables exactly as we saw earlier for lists:

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>table  </tt></td>
<td><tt>10 * table</tt></td>
<td><tt>table + table</tt></td>
</tr><tr valign="TOP">
<td><tt>5 6&nbsp;&nbsp;7<br>
8 9 10</tt></td>
<td><tt>50 60&nbsp;&nbsp;70<br>
80 90 100</tt></td>
<td><tt>10 12 14<br>
16 18 20</tt></td>
</tr></tbody></table>

One argument can be a table and one a list:

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>table</tt></td>
<td><tt>0 1 * table</tt></td>
</tr><tr valign="TOP">
<td><tt>5 6&nbsp;&nbsp;7<br>
8 9 10</tt></td>
<td><tt>0 0&nbsp;&nbsp;0<br>
8 9 10</tt></td>
</tr></tbody></table>

In this last example, evidently the items of the list 0 1 are automatically matched against the rows of the table, 0 matching the first row and 1 the second. Other patterns of matching the arguments against each other are also possible - see Chapter 07.

## 2.2 Arrays
A table is said to have two dimensions (namely, rows and columns) and in this sense a list can be said to have only one dimension.
We can have table-like data objects with more than two dimensions. The left argument of the $ function can be a list of any number of dimensions. The word "array" is used as the general name for a data object with some number of dimensions. Here are some arrays with one, two and three dimensions:

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>3 $ 1</tt></td>
<td><tt>2 3 $ 5 6 7</tt></td>
<td><tt>2 2 3 $ 5 6 7 8</tt></td>
</tr><tr valign="TOP">
<td><tt>1 1 1</tt></td>
<td><tt>5 6 7<br>
5 6 7</tt></td>
<td><tt>5 6 7<br>
8 5 6<br>
<br>
7 8 5<br>
6 7 8</tt></td>
</tr></tbody></table>

The 3-dimensional array in the last example is said to have 2 planes, 2 rows and 3 columns and the two planes are displayed one below the other.

Recall that the monadic function # gives the length of a list.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt># 6 7</tt></td>
<td><tt># 6 7 8</tt></td>
</tr><tr valign="TOP">
<td><tt>2</tt></td>
<td><tt>3</tt></td>
</tr></tbody></table>

The monadic function $ gives the list-of-dimensions of its argument:

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>L =: 5 6 7</tt></td>
<td><tt>$ L</tt></td>
<td><tt>T =: 2 3 $ 1</tt></td>
<td><tt>$ T</tt></td>
</tr><tr valign="TOP">
<td><tt>5 6 7</tt></td>
<td><tt>3</tt></td>
<td><tt>1 1 1<br>
1 1 1</tt></td>
<td><tt>2 3</tt></td>
</tr></tbody></table>

Hence, if x is an array, the expression (# $ x) yields the length of the list-of-dimensions of x, that is, the dimension-count of x, which is 1 for a list, 2 for a table and so on.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> L </tt></td>
<td><tt>$ L </tt></td>
<td><tt> # $ L</tt></td>
<td><tt> T </tt></td>
<td><tt>$T</tt></td>
<td><tt># $ T</tt></td>
</tr><tr valign="TOP">
<td><tt>5 6 7</tt></td>
<td><tt>3</tt></td>
<td><tt>1</tt></td>
<td><tt>1 1 1<br>
1 1 1</tt></td>
<td><tt>2 3</tt></td>
<td><tt>2</tt></td>
</tr></tbody></table>

If we take x to be a single number, then the expression (# $ x) gives zero.

	   # $ 17
	0

We interpret this to mean that, while a table has two dimensions, and a list has one, a single number has none, because its dimension-count is zero. A data object with a dimension-count of zero will be called a scalar. We said that "arrays" are data objects with some number of dimensions, and so scalars are also arrays, the number of dimensions being zero in this case.
We saw that (# $ 17) is 0. We can also conclude from this that, since a scalar has no dimensions, its list-of-dimensions (given here by $ 17) must be a zero-length, or empty, list. Now a list of length 2, say can be generated by an expression such as 2 $ 99 and so an empty list, of length zero, can be generated by 0 $ 99 (or indeed, 0 $ any number)

The value of an empty list is displayed as nothing:

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>2 $ 99</tt></td>
<td><tt>0 $ 99</tt></td>
<td><tt> $ 17</tt></td>
</tr><tr valign="TOP">
<td><tt>99 99</tt></td>
<td><tt>&nbsp;</tt></td>
<td><tt>&nbsp;</tt></td>
</tr></tbody></table>

Notice that a scalar, (17 say), is not the same thing as a list of length one (e.g. 1 $ 17), or a table with one row and one column (e.g. 1 1 $ 17). The scalar has no dimensions, the list has one, the table has two, but all three look the same when displayed on the screen:

	   S =: 17
	   L =: 1 $ 17
	   T =: 1 1 $ 17

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> S </tt></td>
<td><tt> L </tt></td>
<td><tt> T </tt></td>
<td><tt># $ S</tt></td>
<td><tt># $ L</tt></td>
<td><tt># $ T</tt></td>
</tr><tr valign="TOP">
<td><tt>17</tt></td>
<td><tt>17</tt></td>
<td><tt>17</tt></td>
<td><tt>0</tt></td>
<td><tt>1</tt></td>
<td><tt>2</tt></td>
</tr></tbody></table>

A table may have only one column, and yet still be a 2-dimensional table. Here t has 3 rows and 1 column.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>t =: 3 1 $ 5 6 7</tt></td>
<td><tt>$ t</tt></td>
<td><tt># $ t</tt></td>
</tr><tr valign="TOP">
<td><tt>5<br>
6<br>
7</tt></td>
<td><tt>3 1</tt></td>
<td><tt>2</tt></td>
</tr></tbody></table>

## 2.3 Terminology: Rank and Shape
The property we called "dimension-count" is in J called by the shorter name of of "rank", so a single number is a said to be a rank-0 array, a list of numbers a rank-1 array and so on. The list-of-dimensions of an array is called its "shape".
The mathematical terms "vector" and "matrix" correspond to what we have called "lists" and "tables" (of numbers). An array with 3 or more dimensions (or, as we now say, an array of rank 3 or higher) will be called a "report".

A summary of terms and functions for describing arrays is shown in the following table.

	+--------+--------+-----------+------+
	|        | Example| Shape     | Rank |
	+--------+--------+-----------+------+
	|        | x      | $ x       | # $ x|
	+--------+--------+-----------+------+
	| Scalar | 6      | empty list| 0    |
	+--------+--------+-----------+------+
	| List   | 4 5 6  | 3         | 1    |
	+--------+--------+-----------+------+
	| Table  |0 1 2   | 2 3       | 2    |
	|        |3 4 5   |           |      |
	+--------+--------+-----------+------+
	| Report |0  1  2 | 2 2 3     | 3    |
	|        |3  4  5 |           |      |
	|        |        |           |      |
	|        |6  7  8 |           |      |
	|        |9 10 11 |           |      |
	+--------+--------+-----------+------+

This table above was in fact produced by a small J program, and is a genuine "table", of the kind we have just been discussing. Its shape is 6 4. However, it is evidently not just a table of numbers, since it contains words, list of numbers and so on. We now look at arrays of things other than numbers.

## 2.4 Arrays of Characters
Characters are letters of the alphabet, punctuation, numeric digits and so on. We can have arrays of characters just as we have arrays of numbers. A list of characters is entered between single quotes, but is displayed without the quotes. For example:

	   title =: 'My Ten Years in a Quandary'
	   title
	My Ten Years in a Quandary

A list of characters is called a character-string, or just a string. A single quote in a string is entered as two successive single quotes.

	   'What''s new?'
	What's new?

An empty, or zero-length, string is entered as two successive single quotes, and displays as nothing.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> '' </tt></td>
<td><tt># '' </tt></td>
</tr><tr valign="TOP">
<td><tt>&nbsp;</tt></td>
<td><tt>0</tt></td>
</tr></tbody></table>

## 2.5 Some Functions for Arrays
At this point it will be useful to look at some functions for dealing with arrays. J is very rich in such functions: here we look at a just a few.

### 2.5.1 Joining
The built-in function , (comma) is called "Append". It joins things together to make lists.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>a =: 'rear'</tt></td>
<td><tt>b =: 'ranged'</tt></td>
<td><tt>a,b</tt></td>
</tr><tr valign="TOP">
<td><tt>rear</tt></td>
<td><tt>ranged</tt></td>
<td><tt>rearranged</tt></td>
</tr></tbody></table>

The "Append" function joins lists or single items.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>x =: 1 2 3</tt></td>
<td><tt>0 , x </tt></td>
<td><tt>x , 0 </tt></td>
<td><tt>0 , 0</tt></td>
<td><tt>x , x </tt></td>
</tr><tr valign="TOP">
<td><tt>1 2 3</tt></td>
<td><tt>0 1 2 3</tt></td>
<td><tt>1 2 3 0</tt></td>
<td><tt>0 0</tt></td>
<td><tt>1 2 3 1 2 3</tt></td>
</tr></tbody></table>

The "Append" function can take two tables and join them together end-to-end to form a longer table:

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>T1=: 2 3 $ 'catdog'</tt></td>
<td><tt>T2=: 2 3 $ 'ratpig'</tt></td>
<td><tt>T1,T2</tt></td>
</tr><tr valign="TOP">
<td><tt>cat<br>
dog</tt></td>
<td><tt>rat<br>
pig</tt></td>
<td><tt>cat<br>
dog<br>
rat<br>
pig</tt></td>
</tr></tbody></table>

For more information about "Append", see Chapter 05.

### 2.5.2 Items
The items of a list of numbers are the individual numbers, and we will say that the items of a table are its rows. The items of a 3-dimensional array are its planes. In general we will say that the items of an array are the things which appear in sequence along its first dimension. An array is the list of its items.
Recall the built-in verb # ("Tally") which gives the length of a list.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>x</tt></td>
<td><tt> # x</tt></td>
</tr><tr valign="TOP">
<td><tt>1 2 3</tt></td>
<td><tt>3</tt></td>
</tr></tbody></table>

In general # counts the number of items of an array, that is, it gives the first dimension:

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>T1</tt></td>
<td><tt>$ T1</tt></td>
<td><tt># T1</tt></td>
</tr><tr valign="TOP">
<td><tt>cat<br>
dog</tt></td>
<td><tt>2 3</tt></td>
<td><tt>2</tt></td>
</tr></tbody></table>

Evidently # T1 is the first item of the list-of-dimensions $ T1. A scalar, with no dimensions, is regarded as a single item:

	   # 6
	1

Consider again the example of "Append" given above.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>T1</tt></td>
<td><tt>T2</tt></td>
<td><tt>T1 , T2</tt></td>
</tr><tr valign="TOP">
<td><tt>cat<br>
dog</tt></td>
<td><tt>rat<br>
pig</tt></td>
<td><tt>cat<br>
dog<br>
rat<br>
pig</tt></td>
</tr></tbody></table>

Now we can say that in general (x , y) is a list consisting of the items of x followed by the items of y.

For another example of the usefulness of "items", recall the verb +/ where + is inserted between items of a list.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>+/ 1 2 3</tt></td>
<td><tt>1 + 2 + 3</tt></td>
</tr><tr valign="TOP">
<td><tt>6</tt></td>
<td><tt>6</tt></td>
</tr></tbody></table>

Now we can say that in general +/ inserts + between items of an array. In the next example the items are the rows:

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>T =: 3 2 $ 1 2 3 4 5 6</tt></td>
<td><tt>+/ T</tt></td>
<td><tt>1 2 + 3 4 + 5 6</tt></td>
</tr><tr valign="TOP">
<td><tt>1 2<br>
3 4<br>
5 6</tt></td>
<td><tt>9 12</tt></td>
<td><tt>9 12</tt></td>
</tr></tbody></table>

### 2.5.3 Selecting
Now we look at selecting items from a list. Positions in a list are numbered 0, 1, 2 and so on. The first item occupies position 0. To select an item by its position we use the function { (left brace, called "From") .

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>Y =: 'abcd'</tt></td>
<td><tt>0 { Y</tt></td>
<td><tt>1 { Y</tt></td>
<td><tt>3 { Y</tt></td>
</tr><tr valign="TOP">
<td><tt>abcd</tt></td>
<td><tt>a</tt></td>
<td><tt>b</tt></td>
<td><tt>d</tt></td>
</tr></tbody></table>

A position-number is called an index. The { function can take as left argument a single index or a list of indices:

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> Y</tt></td>
<td><tt> 0 { Y</tt></td>
<td><tt> 0 1 { Y</tt></td>
<td><tt> 3 0 1 { Y</tt></td>
</tr><tr valign="TOP">
<td><tt>abcd</tt></td>
<td><tt>a</tt></td>
<td><tt>ab</tt></td>
<td><tt>dab</tt></td>
</tr></tbody></table>

There is a built-in function i. (letter-i dot). The expression (i. n) generates n successive integers from zero.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>i. 4</tt></td>
<td><tt>i. 6</tt></td>
<td><tt>1 + i. 3</tt></td>
</tr><tr valign="TOP">
<td><tt>0 1 2 3</tt></td>
<td><tt>0 1 2 3 4 5</tt></td>
<td><tt>1 2 3</tt></td>
</tr></tbody></table>

If x is a list, the expression (i. # x) generates all the possible indexes into the list x.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>x =: 'park'</tt></td>
<td><tt># x</tt></td>
<td><tt>i. # x</tt></td>
</tr><tr valign="TOP">
<td><tt>park</tt></td>
<td><tt>4</tt></td>
<td><tt>0 1 2 3</tt></td>
</tr></tbody></table>

With a list argument, i. generates an array:

	   i. 2 3
	0 1 2
	3 4 5

There is a dyadic version of i., called "Index Of". The expression (x i. y) finds the position, that is, index, of y in x.

	   'park' i. 'k'
	3

The index found is that of the first occurrence of y in x.

	   'parka' i. 'a'
	1

If y is not present in x, the index found is 1 greater than the last possible position.

	   'park' i. 'j'
	4

For more about the many variations of indexing, see Chapter 06.

### 2.5.4 Equality and Matching
Suppose we wish to determine whether two arrays are the same. There is a built-in verb -: (minus colon, called "Match"). It tests whether its two arguments have the same shapes and the same values for corresponding elements.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>X =: 'abc'</tt></td>
<td><tt>X -: X</tt></td>
<td><tt>Y =: 1 2 3 4</tt></td>
<td><tt>X -: Y</tt></td>
</tr><tr valign="TOP">
<td><tt>abc</tt></td>
<td><tt>1</tt></td>
<td><tt>1 2 3 4</tt></td>
<td><tt>0</tt></td>
</tr></tbody></table>

Whatever the arguments, the result of Match is always a single 0 or 1.

Notice that an empty list of, say, characters is regarded as matching an empty list of numbers:

	   '' -: 0 $ 0
	1

because they have the same shapes, and furthermore it is true that all corresponding elements have the same values, (because there are no such elements).
There is another verb, = (called "Equal") which tests its arguments for equality. = compares its arguments element by element and produces an array of booleans of the same shape as the arguments.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>Y</tt></td>
<td><tt>Y = Y</tt></td>
<td><tt>Y = 2</tt></td>
</tr><tr valign="TOP">
<td><tt>1 2 3 4</tt></td>
<td><tt>1 1 1 1</tt></td>
<td><tt>0 1 0 0</tt></td>
</tr></tbody></table>

Consequently, the two arguments of = must have the same shapes, (or at least, as in the example of Y=2, compatible shapes). Otherwise an error results.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>Y</tt></td>
<td><tt>Y = 1 5 6 4</tt></td>
<td><tt>Y = 1 5 6</tt></td>
</tr><tr valign="TOP">
<td><tt>1 2 3 4</tt></td>
<td><tt>1 0 0 1</tt></td>
<td><tt>error</tt></td>
</tr></tbody></table>

## 2.6 Arrays of Boxes
### 2.6.1 Linking
There is a built-in function ; (semicolon, called "Link"). It links together its two arguments to form a list. The two arguments can be of different kinds. For example we can link together a character-string and a number.

	   A =: 'The answer is'  ;  42
	   A
	+-------------+--+
	|The answer is|42|
	+-------------+--+

The result A is a list of length 2, and is said to be a list of boxes. Inside the first box of A is the string 'The answer is'. Inside the second box is the number 42. A box is shown on the screen by a rectangle drawn round the value contained in the box.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> A </tt></td>
<td><tt> 0 { A</tt></td>
</tr><tr valign="TOP">
<td><tt>+-------------+--+<br>
|The answer is|42|<br>
+-------------+--+</tt></td>
<td><tt>+-------------+<br>
|The answer is|<br>
+-------------+</tt></td>
</tr></tbody></table>

A box is a scalar whatever kind of value is inside it. Hence boxes can be packed into regular arrays, just like numbers. Thus A is a list of scalars.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> A </tt></td>
<td><tt>$ A</tt></td>
<td><tt>s =: 1 { A</tt></td>
<td><tt> # $ s</tt></td>
</tr><tr valign="TOP">
<td><tt>+-------------+--+<br>
|The answer is|42|<br>
+-------------+--+</tt></td>
<td><tt>2</tt></td>
<td><tt>+--+<br>
|42|<br>
+--+</tt></td>
<td><tt>0</tt></td>
</tr></tbody></table>

The main purpose of an array of boxes is to assemble into a single variable several values of possibly different kinds. For example, a variable which records details of a purchase (date, amount, description) could be built as a list of boxes:

	   P =: 18 12 1998  ;  1.99  ;  'baked beans'
	   P
	+----------+----+-----------+
	|18 12 1998|1.99|baked beans|
	+----------+----+-----------+

Note the difference between "Link" and "Append". While "Link" joins values of possibly different kinds, "Append" always joins values of the same kind. That is, the two arguments to "Append" must both be arrays of numbers, or both arrays of characters, or both arrays of boxes. Otherwise an error is signalled.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>'answer is'; 42</tt></td>
<td><tt>'answer is' , 42</tt></td>
</tr><tr valign="TOP">
<td><tt>+---------+--+<br>
|answer is|42|<br>
+---------+--+</tt></td>
<td><tt>error</tt></td>
</tr></tbody></table>

On occasion we may wish to combine a character-string with a number, for example to present the result of a computation together with some description. We could "Link" the description and the number, as we saw above. However a smoother presentation could be produced by converting the number to a string, and then Appending this string and the description, as characters.

Converting a number to a string can be done with the built-in "Format" function ": (double-quote colon). In the following example n is a single number, while s, the formatted value of n, is a string of characters of length 2.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>n =: 42</tt></td>
<td><tt>s =: ": n</tt></td>
<td><tt># s</tt></td>
<td><tt>'answer is ' , s</tt></td>
</tr><tr valign="TOP">
<td><tt>42</tt></td>
<td><tt>42</tt></td>
<td><tt>2</tt></td>
<td><tt>answer is 42</tt></td>
</tr></tbody></table>

For more about "Format", see Chapter 19. Now we return to the subject of boxes. Because boxes are shown with rectangles drawn round them, they lend themselves to presentation of results on-screen in a simple table-like form.

	   p =: 4 1 $ 1 2 3 4
	   q =: 4 1 $ 3 0 1 1
	   
	   2 3 $ ' p ' ; ' q ' ; ' p+q ' ;  p ; q ; p+q
	+---+---+-----+
	| p | q | p+q |
	+---+---+-----+
	|1  |3  |4    |
	|2  |0  |2    |
	|3  |1  |4    |
	|4  |1  |5    |
	+---+---+-----+

### 2.6.2 Boxing and Unboxing
There is a built-in function < (left-angle-bracket, called "Box"). A single boxed value can be created by applying < to the value.

	   < 'baked beans'
	+-----------+
	|baked beans|
	+-----------+

Although a box may contain a number, it is not itself a number. To perform computations on a value in a box, the box must be, so to speak "opened" and the value taken out. The function > (right-angle-bracket) is called "Open".

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>b =: &lt; 1 2 3</tt></td>
<td><tt>&gt; b</tt></td>
</tr><tr valign="TOP">
<td><tt>+-----+<br>
|1 2 3|<br>
+-----+</tt></td>
<td><tt>1 2 3</tt></td>
</tr></tbody></table>

It may be helpful to picture < as a funnel. Flowing into the wide end we have data, and flowing out of the narrow end we have boxes which are scalars, that is, dimensionless or point-like. Conversely for > . Since boxes are scalars, they can be strung together into lists of boxes with the comma function, but the semicolon function is often more convenient because it combines the stringing-together and the boxing:

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>(&lt; 1 1) , (&lt; 2 2) , (&lt; 3 3)</tt></td>
<td><tt>1 1 ; 2 2 ; 3 3</tt></td>
</tr><tr valign="TOP">
<td><tt>+---+---+---+<br>
|1 1|2 2|3 3|<br>
+---+---+---+</tt></td>
<td><tt>+---+---+---+<br>
|1 1|2 2|3 3|<br>
+---+---+---+</tt></td>
</tr></tbody></table>

## 2.7 Summary
In conclusion, every data object in J is an array, with zero, one or more dimensions. An array may be an array of numbers, or an array of characters, or an array of boxes (and there are further possibilities).
This brings us to the end of Chapter 2.
