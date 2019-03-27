# numberNotCompleted2
An SPSS macro to code individual response option data

This macro allows to recode responses to multiple choice question items with one correct answer to be given that is coded with one variable (0 = not marked, 1 = marked) per response option (rather than one variable per item). It requires 0 and 1 values entered only on all variables and, according to specified variable names and response option numbers, calculates 
* for each item with a group of response options: the given response (if on eresponse was given only) or technically a missing value if no or multiple answers were given for a particular item
* for each item with a group of response options: the number of response options marked
* for the entire test: the number of consecutive items with 0 response options marked at the end of the test
