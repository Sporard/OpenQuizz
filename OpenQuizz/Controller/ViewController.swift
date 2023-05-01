//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Pierre Sabard on 24/04/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var questionViewOutlet: QuestionView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var game: Game = Game()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
        startNewGame()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        
        questionViewOutlet.addGestureRecognizer(panGestureRecognizer)
    }

    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    
    private func startNewGame() {
        // Init view
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        questionViewOutlet.title = "Loading .."
        questionViewOutlet.style = .standard
        score.text = "0/10"
        
        game.refresh()
        
    }
    
    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        questionViewOutlet.title = game.currentQuestion.title
    }
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer){
        if game.state == .ongoing {
            switch sender.state{
            case .began, .changed:
                transformQuestionWithView(gesture: sender)
            case .ended, .cancelled:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionWithView(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: questionViewOutlet)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x/(screenWidth / 2)
        let rotationAngle = (CGFloat.pi/6) * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        questionViewOutlet.transform = transform
        
        if (translation.x > 0){
            questionViewOutlet.style = .correct
        } else {
            questionViewOutlet.style = .incorrect
        }
        
       
        
        
    }
    
    private func showQuestionView(){
        questionViewOutlet.transform = .identity
        questionViewOutlet.style = .standard
        
        animateNewQuestion()
    
        
        switch game.state {
        case .ongoing:
            questionViewOutlet.title = game.currentQuestion.title
        case .over:
            questionViewOutlet.title = "Game over"
            
        }
        animateNewQuestion()
    }
    
    private func answerQuestion() {
        
        switch questionViewOutlet.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        default:
            break
        }
        
        score.text = "\(game.score) / 10"
        
        animateAnswerQuestion()
        
    }
    
    private func animateAnswerQuestion(){
        let screenWidth = UIScreen.main.bounds.width
        var questionAnwseredAnimation: CGAffineTransform
        if questionViewOutlet.style == .correct{
            questionAnwseredAnimation = CGAffineTransform(translationX: screenWidth, y: 0)
        }  else {
            questionAnwseredAnimation = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.questionViewOutlet.transform = questionAnwseredAnimation
        }, completion: { (success) in
            if success {
                self.showQuestionView()
            }
            
        })
    }
    
    private func animateNewQuestion(){
        // Reduce size
        questionViewOutlet.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5,initialSpringVelocity: 0.5, options: [], animations: {
            self.questionViewOutlet.transform = .identity
        }, completion: nil)
    }
    
}

