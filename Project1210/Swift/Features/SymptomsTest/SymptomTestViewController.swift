//
//  SymptomTestViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/6/21.
//

import UIKit
import CoreML

protocol StatusDelegate: class {
    func statusManager(controller: SymptomTestViewController ,userValue: User)
}

class SymptomTestViewController: UIViewController {
    
    var model: finalmodel?
    var data: [Double] = []
    var questions = [Question]()
    var questionNumber: Int = 0
    var currentProgress: Int = 0
    var selectedAnswer: Int = 0
    var delegate: StatusDelegate?
    var testModel = TestModel()
    var thisUser = User.shared
    var thisSymptom = Symptom(symptomId: 1, fever: "",
                              cough: "", sore_throat: "",
                              shortness_of_breath: "", headeche: "",
                              as_gender: true, age_60_and_above: true, admin_Id: 1, user_Id: 1, output: 1, lat: 41.0422, long: 29.0093)
    let database = DataBaseCommands()
    let symptomForId = Symptom(symptomId: 1, fever: "", cough: "", sore_throat: "", shortness_of_breath: "", headeche: "", as_gender: true, age_60_and_above: true, admin_Id: 1, user_Id: 1, output: 1)
    let locationMap = MapViewController()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButtonA: UIButton!
    @IBOutlet weak var answerButtonB: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model = try? finalmodel(configuration: .init())
    }
    
    //MARK:- getter methods
    
    func getQuestion() -> String {
        return questions[questionNumber].question
    }
    
    func getProgress() -> Float {
        return Float(questionNumber + 1) / Float(questions.count)
    }
    
    func getNextQuestion() {
        if questionNumber + 1 < questions.count{
            questionNumber += 1
        } else {
            questionNumber = 1
        }
    }
    
    func updateQuestions(answer: String) {
        questionNumber += 1
        questionLabel.text = questions[questionNumber].question
        answerButtonA.setTitle(questions[questionNumber].answerA, for: .normal)
        answerButtonB.setTitle(questions[questionNumber].answerB, for: .normal)
        if  answer == "Great!" {
            questionLabel.text = "Have a great day!"
            answerButtonA.isHidden = true
            progressBar.isHidden = true
            answerButtonB.setTitle("Exit", for: .normal)
        }
    }
    
    //MARK:- ACTION
    @IBAction func buttonClick(_ sender: UIButton) {
        print(questionNumber)
        print(sender.currentTitle)
        if questionNumber != 0 {
            updateUI()
        }
        
        if sender.currentTitle == "Cancel" {
            self.dismiss(animated: true, completion: nil)
        }
        
        userChoice(answer: sender.currentTitle!)
        if questionNumber == 8 {
            data = [testModel.cough, testModel.fever, testModel.sore_throat, testModel.shortness_of_breath, testModel.headache, testModel.gender]
            for value in data{
                print(value)
            }
            
            guard let input = try? MLMultiArray(shape:[1,6], dataType: MLMultiArrayDataType.double) else {
                fatalError("Unexpected runtime error. MLMultiArray")
            }
            
            for (index, element) in data.enumerated() {
                input[index] = NSNumber(integerLiteral: Int(element))
                print("input: \(input)")
            }
            
            guard let result = try? model?.prediction(input: input) else {return}
            var resultfinal: String = ""
            testModel.output = result.classLabel
            thisSymptom.output = result.classLabel
            
            if result.classLabel == 1 {
                resultfinal = "positive"
                
            } else if result.classLabel == 0  {
                resultfinal = "negative"
            }
            
            print("Predicted class: \(result.classLabel)")
            
            print("Result Final: \(resultfinal)")
            if thisSymptom.output == 1 {
                
                let alert = UIAlertController(title: "Warning!", message: "According to your answers, you may have positive result for COVID-19. It would be better if you go to a hospital! ", preferredStyle: .alert)
                let action = UIAlertAction(title: "Got it!", style: .default) { (alertAction) in
                    self.updateQuestions(answer: sender.currentTitle!)
                    self.progressBar.isHidden = true
                    self.answerButtonA.isHidden = true
                }
                alert.addAction(action)
                present(alert, animated: true,completion: nil)
            } else if thisSymptom.output == 0 {
                let alert = UIAlertController(title: "Enjoy!", message: "According to your answers, the result is negative! ", preferredStyle: .alert)
                let action = UIAlertAction(title: "Got it!", style: .default) { (alertAction) in
                    self.updateQuestions(answer: sender.currentTitle!)
                    self.progressBar.isHidden = true
                    self.answerButtonA.isHidden = true
                }
                alert.addAction(action)
                present(alert, animated: true,completion: nil)
            }
        } else if sender.currentTitle == "Exit" && questionNumber == questions.count-1 {
            locationMap.heatMapView?.reloadInputViews()
            database.insertSymptoms(symptomValues: self.thisSymptom)
            database.updateUser(updateTestStatus: true, userValues: thisUser!)
            let updatedUser = database.getUser(idValue: thisUser!.id)
            print("This user: \(updatedUser?.testApplied)")
            delegate?.statusManager(controller: self, userValue: updatedUser!)
            let calendar = Calendar.current
            let date = Date()
            let components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date)
            let currentDate = calendar.date(from: components)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd'T'HH:mm:ssZ"
            let stringDate = dateFormatter.string(from: currentDate)
            print("Current Date: \(stringDate)")
            database.updateUserTime(currentTime: stringDate, userValues: updatedUser!)
            let eventDate = currentDate.addingTimeInterval(60*60*24*7)
            let stringEventDate = dateFormatter.string(from: eventDate)
            print("Event Date: \(stringEventDate)")
            database.updateUserEventDate(eventTime: stringEventDate, userValues: updatedUser!)
            DispatchQueue.main.async {
                self.answerButtonA.isHidden = true
                self.answerButtonB.isHidden = true
                self.dismiss(animated: true) {
                    self.viewDidLoad()
                    self.answerButtonA.isHidden = false
                    self.answerButtonB.isHidden = false
                    
                }
            }
        } else if sender.currentTitle == "Exit" && questionNumber == 2 {
            DispatchQueue.main.async {
                self.answerButtonA.isHidden = true
                self.answerButtonB.isHidden = true
                self.dismiss(animated: true) { [self] in
                    questionNumber = 0
                    self.viewDidLoad()
                    self.answerButtonA.isHidden = false
                    self.answerButtonB.isHidden = false
                }
            }
        }
        else {
            updateQuestions(answer: sender.currentTitle!)
        }
    }
    
    func updateUI() {
        progressBar.progress = getProgress()
    }
    
    func userChoice(answer: String?) {
        
        thisSymptom.symptomId = symptomForId.symptomId
        thisSymptom.user_Id = thisUser!.id
        
        thisSymptom.as_gender = thisUser!.gender
        testModel.gender = Double(thisUser!.gender == false ? 1:0)
        thisSymptom.admin_Id = 0
        thisSymptom.age_60_and_above = false
        if  questionNumber == 2  {
            thisSymptom.headeche = answer ?? "No"
            testModel.headache = answer == "Yes" ? 1:0
        } else if questionNumber == 5 {
            thisSymptom.sore_throat = answer ?? "No"
            testModel.sore_throat = answer == "Yes" ? 1:0
        } else if questionNumber == 3 {
            thisSymptom.cough = answer ?? "No"
            testModel.cough = answer == "Yes" ? 1:0
        } else if questionNumber == 6 {
            thisSymptom.shortness_of_breath = answer ?? "No"
            testModel.shortness_of_breath = answer == "Yes" ? 1:0
        } else if questionNumber == 8 {
            thisSymptom.fever = answer ?? "No"
            testModel.fever = answer == "Higher than 38.0" ? 1:0
        }
    }
}

extension SymptomTestViewController {
    
    func configureView() {
        answerButtonA.applyDefaultStyling(color: .blue)
        answerButtonB.applyDefaultStyling(color: .blue)
        
        askQuestions()
        questionNumber = 0
        questionLabel.text = questions[questionNumber].question
        answerButtonB.setTitle("Let's start", for: .normal)
        answerButtonA.setTitle("Cancel", for: .normal)
        progressBar.progress = 0
    }
    
    func askQuestions() {
        questions = [ Question(question: "We have some questions for you!",
                               answerA: "Cancel",
                               answerB: "Let's start"),
                      Question(question: "How are you feeling today?",
                               answerA: "Great!",
                               answerB: "Not that well"),
                      Question(question: "Are you experiencing headaches?",
                               answerA: "Yes",
                               answerB: "No"),
                      Question(question: "Are you having cough?",
                               answerA: "Yes",
                               answerB: "No"),
                      Question(question: "Do you have Severe chest pain?",
                               answerA: "Yes",
                               answerB: "No"),
                      Question(question: "Are experiencing muscle aches or soreness?",
                               answerA: "Yes",
                               answerB: "No"),
                      Question(question: "Are you experiencing shortness of breath or difficulty breathing?",
                               answerA: "Yes",
                               answerB: "No"),
                      Question(question: "Do you have the sense of taste and smell?",
                               answerA: "Yes",
                               answerB: "No"),
                      Question(question: "How is your fever?",
                               answerA: "Around 36.5-37.0",
                               answerB: "Higher than 38.0"),
                      Question(question: "Have a great day!",
                               answerA: "",
                               answerB: "Exit")]
    }
}
