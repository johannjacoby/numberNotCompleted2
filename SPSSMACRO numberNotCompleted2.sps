 * >>> prefix is a scale name, enclosed in parentheses, that is put in the beginning of the names of all variables to be computed. it must only have letters, not blanks, no special characters.
 *  >>> varList is a list of variables belonging to a scale, all spelled out, in the order in which they appear in the dataset, all enclosed in two parentheses, open before the first, closed after the last variable name.
 *  >>> nsOfOptions is a list of the number of response options foreach item that is cast in the variables, separated by blank spaces and enclosed in two parentheses (open before first number and closed after last). 
 *  The numbers of response options (nsOfOptions) must be in the same order as the variables appear, different numbers can be indicated for different items, but even if they are all the same, they must all be spelled out. 
 *  The sum of all listed nsOfOptions must be equal to the number of variables listed in varList.


DEFINE numberNotCompleted2 (prefix = !ENCLOSE('(',')') / varList = !ENCLOSE('(',')') / nsOfOptions = !ENCLOSE('(',')') )

   ECHO !QUOTE(!prefix).

   !LET !nOfVars = 0.
   !DO !x !IN (!varList).
   !LET !nOfVars = !LENGTH(!CONCAT(!BLANK(!nOfVars), !BLANK(1))).
   !DOEND.

   !LET !nOfOptions = 0.
   !DO !x !IN (!nsOfOptions).
   !LET !nOfOptions = !LENGTH(!CONCAT(!BLANK(!nOfOptions), !BLANK(!x))).
   !DOEND.

   !LET !nOfItems = 0.
   !DO !x !IN (!nsOfOptions).
   !LET !nOfItems = !LENGTH(!CONCAT(!BLANK(!nOfItems), !BLANK(1))).
   !DOEND.

   !IF (!nOfOptions <> !nOfVars) !THEN 
      ECHO !QUOTE("ERROR >>>>>>>>>>>>>>>>>>>>>>>>> The number of variables and the listed options are not ")

      ECHO !QUOTE("consistent in the call of the macro numberNotCompleted2.")
   !ELSE !IF (!INDEX(!prefix," ") > 0) !THEN
   ECHO !QUOTE("ERROR >>>>>>>>>>>>>>>>>>>>>>>>> The prefix may not have blanks.")

   ECHO !QUOTE(" Please choose a string with letters only.")

   !ELSE
      !LET !counterItems = 1.
      !LET !counterOptions = 0.
      !LET !varlisttheR0 = "".
      !DO !i !IN (!nsOfOptions).
         COMPUTE !CONCAT(!prefix,"_ITEM_",!counterItems,"_numResp") = 0.
         VAR LAB !CONCAT(!prefix,"_ITEM_",!counterItems,"_numResp") !CONCAT(" 'Number of responses given for item no ",!counterItems," '.").
         COMPUTE !CONCAT("ITEM_",!counterItems,"_theR0") = -99.
         !LET !varlisttheR0 = !CONCAT(!varlisttheR0," ITEM_",!counterItems,"_theR0").

         !DO !j = 1 !TO !i.
            ECHO !QUOTE(!CONCAT("item ",!counterItems,", option ",!counterOptions))
            !LET !currentOption = !LENGTH(!CONCAT(!BLANK(!counterOptions), !BLANK(!j))).
            !LET !cVars = 0.
            !DO !k !IN (!varList)
               !LET !cVars = !LENGTH(!CONCAT(!BLANK(!cVars), !BLANK(1))).
               !IF (!cVars !EQ !currentOption) !THEN
                  ECHO !QUOTE(!CONCAT(" k:",!k)).
                  ECHO !QUOTE(!currentOption).
                  COMPUTE !CONCAT(!prefix,"_ITEM_",!counterItems,"_numResp") = !CONCAT(!prefix,"_ITEM_",!counterItems,"_numResp") + !k.
                  do if !k = 1.
                     do if !CONCAT("ITEM_",!counterItems,"_theR0") = -99.
                        COMPUTE !CONCAT("ITEM_",!counterItems,"_theR0") = !j.
                     else if !CONCAT("ITEM_",!counterItems,"_theR0") <> -99.
                        COMPUTE !CONCAT("ITEM_",!counterItems,"_theR0") = -88.
                     end if.
                  end if.
                  EXEC.
               !IFEND.
            !DOEND.
         !DOEND.
         !LET !counterOptions = !LENGTH(!CONCAT(!BLANK(!counterOptions), !BLANK(!i))).
         !LET !counterItems = !LENGTH(!CONCAT(!BLANK(!counterItems), !BLANK(1))).
      !DOEND.

   !DO !x =1 !TO !nOfItems.
         COMPUTE !CONCAT(!prefix,"_ITEM_",!x,"_theR") = !CONCAT("ITEM_",!x,"_theR0").
         VAR LAB !CONCAT(!prefix,"_ITEM_",!x,"_theR") !CONCAT(" 'Which unique response to item no ",!x," - if any - was given?'.").
         VAL LAB  !CONCAT(!prefix,"_ITEM_",!x,"_theR") !CONCAT(" -99 'No response to this item (",!x,") at all'  -88 'multiple responses were given to this item (",!x,")'.").
   !DOEND.


   EXEC.
   DELETE VARS !varlisttheR0.
   EXEC.

    COMPUTE #currentCountZeros = 0.
    !DO !n = 1 !TO !nOfItems.
       IF !CONCAT(!prefix,"_ITEM_",!n,"_numResp") NE 0 #currentCountZeros = 0.
       IF !CONCAT(!prefix,"_ITEM_",!n,"_numResp") EQ 0 #currentCountZeros = #currentCountZeros + 1.
    !DOEND.
    COMPUTE !CONCAT(!prefix,"_blankItemsAtEnd") = #currentCountZeros.
    VAR LAB !CONCAT(!prefix,"_blankItemsAtEnd") 'The number of consecutive items at the end of the order for which no response has been given at all.'
   !IFEND.
   !IFEND.
   EXEC.

!ENDDEFINE

numberNotCompleted2 prefix = (The So andsoscale) varList = (item01a item01b item01c item02a item02b item02c item03a item03b item03c item04a item04b item04c item05a item05b item05c item06a item06b item06c)  nsOfOptions = (3 3 3 3 3 3 ).
