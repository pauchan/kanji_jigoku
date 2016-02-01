//
//  PRTestViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/16.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit
import ChameleonFramework

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
        
        loadQuestion(0)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.navigationItem.title = "Test"
    }
    
    func testButtonClicked(sender : AnyObject)
    {
        let button = sender as! UIButton
        if let index = testOptionButtons.indexOf(button) {
            if index == questions[questionsCount].properAnswerIndex {

                if !wrongAnswer {
                    properAnswersCount++
                }
                let answerLabel = (questions[questionsCount].meaning != "") ? "\(questions[questionsCount].question) → \(questions[questionsCount].meaning)" : "\(questions[questionsCount].question)　→ \(questions[questionsCount].options[index])"

                button.backgroundColor = UIColor.flatGreenColorDark()
                let toast : UIAlertView = UIAlertView(title: "Prawidłowa odpowiedź!", message: answerLabel, delegate: self, cancelButtonTitle: "Dalej")
                toast.show()
                }
            else {
                    button.backgroundColor = UIColor.flatRedColor()
                    wrongAnswer = true
                    button.enabled = false
            }
        }
    }
    
    func loadQuestion(questionNumber: Int)
    {
        testProgressLabel.setProgress(Float(questionNumber)/Float(maxQuestionCount), animated: true)
        wrongAnswer = false
        questionLabel.text = questions[questionNumber].question
        for button in testOptionButtons {
            if let index = testOptionButtons.indexOf(button) {
                button.layer.cornerRadius = 10 // this value vary as per your desire
                button.clipsToBounds = true
                
                button.enabled = true
                button.backgroundColor = UIColor.flatWhiteColor()
                button.setTitle(questions[questionNumber].options[index], forState: UIControlState.Normal)
                
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.titleLabel?.textAlignment = NSTextAlignment.Center
                
                button.addTarget(self, action: "testButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    
    func generateSummary()
    {
    
        let kanjiString : String = questions[questionsCount-1].question as String
        let attrArr = [NSFontAttributeName : UIFont().appFont()]
        let beginningAtrStr = NSAttributedString(string: kanjiString , attributes: attrArr)
        let tempString : NSMutableAttributedString = NSMutableAttributedString(attributedString: beginningAtrStr)
        tempString.appendAttributedString(NSAttributedString(string: " "))
        tempString.appendAttributedString(NSAttributedString(string: questions[questionsCount-1].meaning, attributes: [NSFontAttributeName : UIFont().appFont()]))
        tempString.appendAttributedString(NSAttributedString(string: " "))
        
        for button in testOptionButtons
        {
            let atrStr = NSAttributedString(string: button.titleForState(UIControlState.Normal)!, attributes: [NSForegroundColorAttributeName : button.backgroundColor!, NSFontAttributeName : UIFont().appFont()])
            tempString.appendAttributedString(atrStr)
            tempString.appendAttributedString(NSAttributedString(string: " "))
        }
        questions[questionsCount-1].questionSummaryString = tempString
    
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        self.processProperAnswer()
    }
    
    func processProperAnswer() {
        questionsCount++
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
