//
//  Algorithm+Swift.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/19/21.
//

import UIKit
import CoreML


// the below code will lie under your function in ios after init of the ui and calling the text


/*



let fever = 0 // 0 if false 1 if true
let cough = 0 // 0 if false 1 if true
let sore_throat = 0 // 0 if false 1 if true
let shortness_of_breath = 0 // 0 if false 1 if true
let headache = 0 // 0 if false 1 if true
let age_60_and_above = 0  // 0 if no 1 if yes
let gender = 0 // 0 if Male 1 if Female
let output = 0  //if  ['negative' 'other' 'positive'] then [0 1 2] respectively



/*
 
 Pass your values into the above variables as mentioned in the comments, just after the comments
 
 */





let data = [cough,    fever,    sore_throat, shortness_of_breath, headache, age_60_and_above, gender]

var model: CoronaPredictModelFinal?
model = CoronaPredictModelFinal()


guard let input = try? MLMultiArray(shape:[1,7], dataType: MLMultiArrayDataType.int) else {
    fatalError(“Unexpected runtime error. MLMultiArray”)
}
for (index, element) in data.enumerated() {
    input[index] = NSNumber(integerLiteral: element)
}
guard let result = try? model?.prediction(input: input) else {
    return
}

let resultfinal: String

print(“Predicted class: \(result.classLabel)”)
if result.classLabel == 1 {
    resultfinal = "other"
} else if result.classLabel == 2  {
    resultfinal = "positive"
    
}else {
    
    resultfinal = "negative"
    
}
*/
