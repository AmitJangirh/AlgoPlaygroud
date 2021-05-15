import UIKit
import Foundation

/*
 Problem: Provide a way to convert String -> Int
 */

var sampleString = "1347"

/*
 Default way to do this is as below:
 
func convert(string: String) -> Int {
    return Int(string) ?? 0 // Solve this prblem wihtout String to Int Conversion
}
*/


func convert(string: String) -> Int? {
    var total = 0
    let characterMap: [Character: Int] = ["0": 0,
                                     "1": 1,
                                     "2": 2,
                                     "3": 3,
                                     "4": 4,
                                     "5": 5,
                                     "6": 6,
                                     "7": 7,
                                     "8": 8,
                                     "9": 9]
    
    for (index, char) in string.enumerated() {
        // 1347 = 1000 + 300 + 40 + 7
        // 1347 = 1 * 10^3 + 3 * 10^2 + 4 * 10^1 + 7 * 10^0p
        let exponent = string.count - index - 1
        if let intValue = characterMap[char] {
            let num = Decimal(intValue) * pow(10, exponent)
            total += NSDecimalNumber(decimal: num).intValue
        } else {
            return nil
        }
    }
    return total
}

convert(string: sampleString)
