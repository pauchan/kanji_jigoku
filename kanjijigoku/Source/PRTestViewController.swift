//
//  PRTestViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/16.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit
import ChameleonFramework
import Fabric
import Crashlytics
import FlatUIKit

class PRTestViewController: UIViewController, UIAlertViewDelegate {
    
    var descriptionText = ""
    
    var questions : [Question]!
    
    var questionsCount = 0
    var properAnswersCount = 0
    var maxQuestionCount = 10
    var wrongAnswer = false
    
    @IBOutlet var testOptionButtons: [UIButton]!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var testProgressLabel: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        descriptionLabel.text = descriptionText
        testProgressLabel.configureFlatProgressView(withTrackColor: UIColor.silver(), progressColor: UIColor.alizarin())
        loadQuestion(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.navigationItem.title = "Test"
    }
    
    func testButtonClicked(_ sender : AnyObject) {
        
        let button = sender as! UIButton
        if let index = testOptionButtons.index(of: button) {
            if index == questions[questionsCount].properAnswerIndex {

                if !wrongAnswer {
                    properAnswersCount += 1
                }
                let answerLabel = (questions[questionsCount].meaning != "") ? "\(questions[questionsCount].question) → \(questions[questionsCount].meaning)" : "\(questions[questionsCount].question)　→ \(questions[questionsCount].options[index])"

                button.backgroundColor = UIColor.flatGreenDark
                let toast : UIAlertView = UIAlertView(title: "Prawidłowa odpowiedź!", message: answerLabel, delegate: self, cancelButtonTitle: "Dalej")
                toast.show()
                }
            else {
                    button.backgroundColor = UIColor.flatRed
                    wrongAnswer = true
                    button.isEnabled = false
            }
        }
    }
    
    func loadQuestion(_ questionNumber: Int) {
        
        testProgressLabel.setProgress(Float(questionNumber)/Float(maxQuestionCount), animated: true)
        wrongAnswer = false
        questionLabel.text = questions[questionNumber].question
        for button in testOptionButtons {
            if let index = testOptionButtons.index(of: button) {
                button.layer.cornerRadius = 10 // this value vary as per your desire
                button.clipsToBounds = true
                
                button.isEnabled = true
                button.backgroundColor = UIColor.flatWhite
                button.setTitle(questions[questionNumber].options[index], for: UIControlState())
                
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.titleLabel?.textAlignment = NSTextAlignment.center
                
                button.addTarget(self, action: #selector(PRTestViewController.testButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            }
        }
    }
    
    func generateSummary() {
    
        let kanjiString : String = questions[questionsCount-1].question as String
        let attrArr = [NSFontAttributeName : UIFont().appFontOfSize(12.0)]
        let beginningAtrStr = NSAttributedString(string: kanjiString , attributes: attrArr)
        let tempString : NSMutableAttributedString = NSMutableAttributedString(attributedString: beginningAtrStr)
        tempString.append(NSAttributedString(string: " "))
        tempString.append(NSAttributedString(string: questions[questionsCount-1].meaning, attributes: [NSFontAttributeName : UIFont().appFontOfSize(12.0)]))
        tempString.append(NSAttributedString(string: " "))
        
        for button in testOptionButtons {
            let atrStr = NSAttributedString(string: button.title(for: UIControlState())!, attributes: [NSForegroundColorAttributeName : button.backgroundColor!, NSFontAttributeName : UIFont().appFontOfSize(12.0)])
            tempString.append(atrStr)
            tempString.append(NSAttributedString(string: " "))
        }
        questions[questionsCount-1].questionSummaryString = tempString
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        self.processProperAnswer()
    }
    
    func processProperAnswer() {
        questionsCount += 1
        generateSummary()
        
        if questionsCount >= maxQuestionCount {
            let vc = PRTestResultsViewController()
            vc.descriptionText = descriptionText
            vc.questions = questions
            vc.correctAnswers = properAnswersCount
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            loadQuestion(questionsCount)
        }
    }
}
