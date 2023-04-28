//
//  Game.swift
//  OpenQuizz
//
//  Created by Pierre Sabard on 25/04/2023.
//

import Foundation

class Game {
    var score: Int = 0
    var questions: [Question] = []
    
    enum State {
      case ongoing, over
    }

    var state: State = State.ongoing
    
    private var currentIndex: Int = 0;
    
    var currentQuestion: Question {
        get {
            return self.questions[self.currentIndex]
        }
    }
    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }
    private func finishGame() {
        state = .over
    }
    
    func answerCurrentQuestion(with answer: Bool){
        if (answer == self.currentQuestion.isCorrect){
            self.score += 1
            self.goToNextQuestion()
        }
    }
    
    func refresh () {
        self.score = 0
        self.currentIndex = 0
        self.state = State.over
        
        QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = State.ongoing
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }
        
    }
    
    private func receiveQuestions(_ questions: [Question]){
        self.questions = questions
        self.state = State.ongoing
    }
}
