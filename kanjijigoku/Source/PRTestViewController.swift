//
//  PRTestViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/16.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRTestViewController: UIViewController {
    
    var descriptionText = ""
    
    var questions : [Question]!
    
    var questionsCount = 0
    var properAnswersCount = 0
    var maxQuestionCount = 10
    var wrongAnswer = false
    var correctMarked = false
    
    @IBOutlet var testOptionButtons: [UIButton]!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var testProgressLabel: UIProgressView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "Test"

        
        descriptionLabel.text = descriptionText
        loadQuestion(0)
    }
    
    func testButtonClicked(sender : AnyObject)
    {
        let button = sender as UIButton
        if let index = find(testOptionButtons, button)
        {
            println("Selected index = \(index)")
            if index == questions[questionsCount].properAnswerIndex
            {
                if !correctMarked
                {
                    correctMarked = true
                    button.backgroundColor = UIColor.greenColor()
                    answerLabel.hidden = false
                    if !wrongAnswer
                    {
                        properAnswersCount++
                    }
                }
                else
                {
                    questionsCount++
                    generateSummary()

                    if questionsCount >= maxQuestionCount
                    {
                        var vc = PRTestResultsViewController()
                        vc.descriptionText = descriptionText
                        vc.questions = questions
                        vc.correctAnswers = properAnswersCount
                        self.navigationController?.pushViewController(vc, animated: false)

                    }
                    else
                    {
                        // generate summary for the currentquestion
                        loadQuestion(questionsCount)
                    }
                }
                
            }
            else
            {
                if !correctMarked
                {
                    button.backgroundColor = UIColor.redColor()
                    wrongAnswer = true
                    button.enabled = false
                }

            }
        }
    }
    
    func loadQuestion(questionNumber: Int)
    {
        correctMarked = false
        testProgressLabel.setProgress(Float(questionNumber)/Float(maxQuestionCount), animated: true)
        wrongAnswer = false
        answerLabel.hidden = true
        answerLabel.text = questions[questionNumber].meaning
        
        answerLabel.adjustsFontSizeToFitWidth = true
        answerLabel.textAlignment = NSTextAlignment.Center
        
        questionLabel.text = questions[questionNumber].question
        for button in testOptionButtons
        {
            if let index = find(testOptionButtons, button)
            {
                button.enabled = true
                button.backgroundColor = UIColor.lightGrayColor()
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
        let attrArr = [NSFontAttributeName : UIFont(name: "Helvetica-Bold", size: 12.0)!]
        let beginningAtrStr = NSAttributedString(string: kanjiString , attributes: attrArr)
        var tempString : NSMutableAttributedString = NSMutableAttributedString(attributedString: beginningAtrStr)
        tempString.appendAttributedString(NSAttributedString(string: " "))
        tempString.appendAttributedString(NSAttributedString(string: questions[questionsCount-1].meaning, attributes: [NSFontAttributeName : UIFont(name: "Helvetica", size: 12.0)!]))
        tempString.appendAttributedString(NSAttributedString(string: " "))
        
        for button in testOptionButtons
        {
            let atrStr = NSAttributedString(string: button.titleForState(UIControlState.Normal)!, attributes: [NSForegroundColorAttributeName : button.backgroundColor!, NSFontAttributeName : UIFont(name: "Helvetica", size: 12.0)!])
            tempString.appendAttributedString(atrStr)
            tempString.appendAttributedString(NSAttributedString(string: " "))
        }
        questions[questionsCount-1].questionSummaryString = tempString
    
    }
    
}
