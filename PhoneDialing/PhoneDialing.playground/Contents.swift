import UIKit

/*
 Problem: Write a code for solving below problem
 Provide a value to return matched name against typing phone number
*/

public func solution(_ S : inout String) -> String {
    // write your code in Swift 4.2.1 (Linux)
    var phoneNumber = ""
    // Iterate over string with charater
    for char in S {
        // for Each:
        // Check if character is '-' or " " then skip that character
        if char != "-" || char != " " {
            phoneNumber.append(char)
        }
    }
    // Append the "-" in phone number fornmat
    //phoneNumber.insert("-", at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 3))
    return phoneNumber
}




var nunmner = "32312-323-32"
print(solution(&nunmner))









/*
public func solution(_ A : inout [String], _ B : inout [String], _ P : inout String) -> String {
    // write your code in Swift 4.2.1 (Linux)
    // Find the index of matching string in B and record the ith item from A
    var foundNames = [String]()
    for (index, number) in B.enumerated() {
        if number.contains(P) {
            foundNames.append(A[index])
        }
    }
    // if count == 0 return No contact
    if foundNames.count == 0 {
        return "NO CONTACT"
    }
    // if count == 1, return macthed item from A
    else if foundNames.count == 1 {
        return foundNames[0]
    }
    // else count > 1 return smallest alphabatic name from A
    else {
        foundNames = foundNames.sorted()
        return foundNames[0]
    }
}

var array_A = ["pim", "pom", "ABC", "BCD", "ZYB"]
var array_B = ["999999999", "777888999", "234567879", "45567788", "52562783"]
var searchString = "9"
let foundName = solution(&array_A, &array_B, &searchString)
print("foundName: \(foundName)")
*/
