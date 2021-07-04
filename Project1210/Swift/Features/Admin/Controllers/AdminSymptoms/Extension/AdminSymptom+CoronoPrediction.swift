//
//  AdminSymptom+CoronoPrediction.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/15/21.
//

import Foundation
import CoreML

extension AdminSymptomViewController {
    
    func coronaPrediction() {
        
        testModel.cough = coughTextField.text! == "Yes" ? 1:0
        testModel.gender = genderSegmentControl.selectedSegmentIndex.toBool() == false ? 1:0
        testModel.fever = feverTextField.text! == "36.5–37.5 °C (Normal)" ? 0:1
        testModel.headache = headacheTextField.text! == "Yes" ? 1:0
        testModel.shortness_of_breath = shortnessOfBreathTextField.text! == "Yes" ? 1:0
        
        data = [testModel.cough, testModel.fever, testModel.sore_throat, testModel.shortness_of_breath, testModel.headache,testModel.gender]
        
        guard let input = try? MLMultiArray(shape:[1, 6], dataType: MLMultiArrayDataType.double) else {
            fatalError("Unexpected runtime error. MLMultiArray")
        }
        for (index, element) in data.enumerated() {
            input[index] = NSNumber(integerLiteral: Int(element))
        }
        print("input: \(input)")
        guard let result = try? model?.prediction(input: input) else {return}
        
        var resultfinal: String = ""
        testModel.output = result.classLabel
        
        if result.classLabel == 0 {
            resultfinal = "negative"
            
        } else if result.classLabel == 1  {
            resultfinal = "positive"
        }
        print("Predicted class: \(result.classLabel)")
        print("Result Final: \(resultfinal)")
    }
}
