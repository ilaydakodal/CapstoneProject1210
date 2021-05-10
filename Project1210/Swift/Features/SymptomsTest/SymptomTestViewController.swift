//
//  SymptomTestViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/6/21.
//

import UIKit


class SymptomTestViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButtonA: UIButton!
    @IBOutlet weak var answerButtonB: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var questions = [Question]()
    var questionNumber: Int = 0
    var currentProgress: Int = 0
    var selectedAnswer: Int = 0
    
    func askQuestions() {
        questions = [Question(question: "How are you feeling today?",
                              answerA: "Great!",
                              answerB: "Not that well"),
                     Question(question: "Are you experiencing headaches?",
                              answerA: "Yes",
                              answerB: "No"),
                     Question(question: "Are you having difficulty breathing?",
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
                     Question(question: "Have you experienced  diarrhea in past 6 days?",
                              answerA: "Yes",
                              answerB: "No"),
                     Question(question: "How is your fever?",
                              answerA: "Around 38.0",
                              answerB: "Higher than 39.0")]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askQuestions()
        answerButtonA.applyDefaultStyling(color: .blue)
        answerButtonB.applyDefaultStyling(color: .blue)
        answerButtonA.isHidden = true
        answerButtonB.setTitle("Start", for: .normal)
        progressBar.progress = 0
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
            questionNumber = 0
        }
    }
    
    func updateQuestions() {
        if questionNumber < questions.count {
            questionLabel.text = questions[questionNumber].question
            answerButtonA.setTitle(questions[questionNumber].answerA, for: .normal)
            answerButtonB.setTitle(questions[questionNumber].answerB, for: .normal)
        } else if questionNumber >= questions.count {
            questionLabel.text = "Have a great day!"
            answerButtonA.isHidden = true
            progressBar.isHidden = true
            answerButtonB.setTitle("Exit", for: .normal)
        }
        questionNumber += 1
    }
    
    //MARK:- ACTION
    @IBAction func buttonClick(_ sender: UIButton) {
        if questionNumber == 0 {
            answerButtonA.isHidden = false
        }
        
        if sender.tag == selectedAnswer {
            updateQuestions()
            if questionNumber > 1 {
                updateUI()
            }
        }
        
        if  answerButtonA.isTouchInside && questionNumber == 2 {
            questionLabel.text = "Have a great day!"
            answerButtonA.isHidden = true
            progressBar.isHidden = true
            answerButtonB.setTitle("Exit", for: .normal)
        }
        
        if answerButtonB.titleLabel?.text == "Exit" && answerButtonB.isTouchInside {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func updateUI() {
        progressBar.progress = getProgress()
    }
}
