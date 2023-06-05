
// calculates the depth of list
function Depth(a) = is_list(a) ? len(a) == undef ? 0 : 1 + Depth(a[0]) : 0;

// flattens a list
function Flatten(l) = [for (a = l) for (b = a) b];

// flattens a list that can contain any arbitrary amount of nested lists at any
// position
function DeepFlatten(l, d = 2) = Flatten([for (a = l) Depth(a) > d ? DeepFlatten(a, d) : [a]]);

// use merge sort to sort given array
function MergeSort(arr, keypos = undef) =
    !(len(arr) > 1)
        ? arr
        : let(left = [for (i = [0:floor(len(arr) / 2) - 1]) arr[i]],
              right = [for (i = [floor(len(arr) / 2):len(arr) - 1]) arr[i]],
              mlft = MergeSort(left, keypos),
              mrgt = MergeSort(right, keypos))
              Merge(left = mlft, right = mrgt, kp = keypos);

// merge the lists left and right from position j[0] and j[1] respectively;
// _acc is the list with the merge already done
// do not call this unless you know what youre doing
function Merge(left, right, kp, j = [ 0, 0 ], _acc = []) =
    j[0] >= len(left) && j[1] >= len(right)
        ? _acc
        : Merge(left = left,
                right = right,
                kp = kp,
                j = NextJs(j, left, right, kp),
                _acc = concat(_acc, NextEntry(j, left, right, kp)));

// dont call this unless you know what youre doing
function NextJs(j, lft, rgt, kp) =
    let(jl = j[0], jr = j[1]) jl >= len(lft) || jr >= len(rgt)
        ? // any partition is done ?
        [ jl + 1, jr + 1 ]
        : // advance both pointers
        kp == undef
            ? // is there a key ? // select the partition to take from
            lft[jl] > rgt[jr] ? [ jl, jr + 1 ] : [ jl + 1, jr ]
            : lft[jl][kp] > rgt[jr][kp] ? [ jl, jr + 1 ] : [ jl + 1, jr ];

// dont call this unless you know what youre doing
function NextEntry(j, lft, lrt, kp) =
    let(jl = j[0], jr = j[1]) jl >= len(lft)
        ? [lrt[jr]]
        : // partition left is done ? no, take from right
        jr >= len(lrt) ? [lft[jl]]
                       : // partition right is done ? no, take from left
        kp == undef ?    // is there a key ?
        lft[jl] > lrt[jr] ? [lrt[jr]] : [lft[jl]]
                    : lft[jl][kp] > lrt[jr][kp] ? [lrt[jr]] : [lft[jl]];

// reverses given list eg. [1, 2, 3] -> [3, 2, 1]
function ReverseList(list) = [for (i = [len(list)-1:-1:0]) list[i]];

// generates a list of random integers
function RandomIntList(min = 0, max = 100, size = 100) = let(rand_l = rands(min, max, size)) [for(i = rand_l) round(i)];

// finds the largest integer in a list
function FindLargest(a, i = 0) = (i < len(a) - 1) ? max(a[i], FindLargest(a, i +1 )) : a[i];

// finds the smallest number in the list and returns it
function FindSmallest(a, i = 0) = (i < len(a) - 1) ? min(a[i], FindSmallest(a, i + 1)) : a[i];

// splits given list at given index (between the value before the index and the index)
function SplitAtIndex(list, index) = let(arr1 = [for(i = [0:index - 1]) list[i]], arr2 = index > len(list) - 1 ? [] : [for(i = [index:len(list) - 1]) list[i]]) [arr1, arr2];

// Trims the first index of a list
function TrimFirstIndex(list) = SplitAtIndex(list, 1)[1];

// sets given index in the list to given value
function SetValueInList(list, index, value) = let(arrs = SplitAtIndex(list, index), secondary_arr = TrimFirstIndex(arrs[1])) concat(arrs[0], [value], secondary_arr);

// removes everything in the list that falls inside the given start and end variables
function RemoveRange(list, range_start, range_end) = let(left = SplitAtIndex(list, range_start), right = SplitAtIndex(list, range_end)) concat(left[0], right[1]);

// gets everything in the list between start and end indexes
function GetRange(list, range_start, range_end) = let(left = SplitAtIndex(list, range_start), mid = SplitAtIndex(left[1], (range_end - (len(left[0])-1)))) mid[0];

// turns a string into a list
function ListifyString(string) = GetRange(string, 0, len(string) + 1);

// compares a list and a string and checks for equality
function CmpEqString(list, string) = ListifyString(string) == list;

// Compares a list and a string for not equal
function CmpNEqString(list, string) = ListifyString(string) != list;

// dont call unless you know what youre doing
function MakeSplits(string, selector, index = 0, splits = []) = index == len(string) ? splits : string[index] == selector ? MakeSplits(string, selector, index + 1, concat(splits, [index])) : MakeSplits(string, selector, index + 1, splits);

// Splits a string into an array at selector
function SplitString(string, selector) = let(splits = MakeSplits(string, selector)) Flatten([for(i = [0:len(splits)]) i == 0 ? GetRange(string, 0, splits[i] + 1) : i == len(splits) ? GetRange(string, splits[i - 1] + 1, len(string) - 1) : GetRange(string, splits[i - 1] + 1, splits[i] - 1) ]);

// removes element with given index in given list
function RemoveElement(list, index) = let(split = SplitAtIndex(list, index), right = split[0], left = TrimFirstIndex(split[1])) concat(left, right);

// inserts element into list at index
function InsertElement(list, element, index) = let(split = SplitAtIndex(list, index)) concat(concat(split[0], [element]), split[1]);

function InsertElements(list, elements, index) = let(split = SplitAtIndex(list, index)) concat(concat(split[0], elements), split[1]);

// listifies array of strings
function ListOfStringsToList(list) = [for(i = list) ListifyString(i)];

// converts a string to a list of numbers which are the integer unicode representation of the string
function StringListToUnicodeNumList(list) = [for(i = list) ord(i[0])];

// does opposite what the StringListToUnicodeNumList does
function UnicodeNumListToChrList(list) = [for(i = list) chr(i)];

// sorts a list alphabetically (probably)
function SortAlphabetically(list) = UnicodeNumListToChrList(MergeSort(StringListToUnicodeNumList(list)));

// checks if list contains an element
function ListContainsElement(list, element, index = 0) = list[index] == element ? true : len(list) == index ? false : ListContainsElement(list, element, index + 1);

// checks if list contains all elements of other list
function CmpAllMatch(list, list_of_strings, index = 0, matches = 0) = let(listified = ListOfStringsToList(list_of_strings), f = echo("matches", matches), fg = echo("index", index), l = echo("listified", listified)) index > len(listified) - 1 ? matches == len(listified) ? true : false : ListContainsElement(list, listified[index]) ? CmpAllMatch(list, list_of_strings, index + 1, matches + 1) : CmpAllMatch(list, list_of_strings, index + 1, matches);

// checks if a char is uppercase
function IsUpperCase(char) = ord(char) >= 97 ? ord(char) <= 122 ? true : false : false;

// converts a list of chars to uppercase
function ToUpperCase(list) = [for(i = list) IsUpperCase(i) ? chr(ord(i) - 32) : i];

