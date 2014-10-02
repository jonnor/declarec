declarec
=========

When working on software, protocols implemented in both both "high-level" languages (like Python, JavaScript, Java)
and a "low-level" languages (like C or C++) there is often a need to share definitions.

*declarec* allows you to generate C/C++ code for defining enums, include statements
from a .json definition.

That way you can use the .json definition directly in the high-level language,
and the generated code in C/C++.


Used by [MicroFlo](http://github.com/jonnor/microflo) and [Finito](http://github.com/jonnor/finito).
