//: Playground - noun: a place where people can play

import UIKit

var haystack = "Tim N. says:\nDucking fuck fuck fixawefawefaew  Ducking fuck fuck fixawefa"
var needle = "says:\n"

let hayStackRange = haystack.rangeOfString(needle)
let myRange = Range<String.Index>(start: hayStackRange!.endIndex, end: haystack.endIndex)


print(hayStackRange?.startIndex)
print("----")
print(haystack.substringWithRange(myRange))