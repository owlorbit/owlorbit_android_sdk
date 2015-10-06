//: Playground - noun: a place where people can play

import UIKit




do {
    
    let htmlString = "<meta name=\"referrer\" content=\"origin\"><head><meta name=\"re<a href=\"awefawef=123\">...</a><a href=\"somesite.html?id=123\">...</a>" +
    "<a href=\"somesite.html?id=456\">...</a>" +
    "<a href=\"somesite.html?id=789\">...</a>" +
    "<a href=\"anothersite.html\">...</a>awefawefawef<b><a href=\"news\">Hacker News</a></b>\""
    //let seperateComponent = "<a href=\"somesite.html?id="
    let seperateComponent = "<a href=\"somesite.html?id="

    let linkExp = "[\\w]*\">"
    let linkRegExp = try NSRegularExpression(pattern:linkExp, options:NSRegularExpressionOptions.CaseInsensitive)
    let seperatedArray = htmlString.componentsSeparatedByString(seperateComponent)
    var resultArray = [String]()

    if seperatedArray.count > 1 {
        for seperatedString in seperatedArray {

            let deStr = seperatedString as NSString
            if deStr.length > 3{
                let myRange = linkRegExp.rangeOfFirstMatchInString(seperatedString, options:NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, deStr.length))
                if myRange.location != NSNotFound {
                    let matchString = (seperatedString as NSString).substringWithRange(myRange) as NSString
                    let linkString = (matchString as NSString).substringToIndex(
                        matchString.length - 2)
                    
                    resultArray.append(linkString)
                }
            }
        }
    }

    print(resultArray.count)
    print(resultArray)

}catch let error as NSError{
    print (error.description)
}