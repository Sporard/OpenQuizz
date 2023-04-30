//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Pierre Sabard on 30/04/2023.
//

import UIKit

class QuestionView: UIView {
    
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    enum Style {
        case correct, incorrect, standard
    }
    
    var style: Style = .standard {
        didSet{
            setStyle(style)
        }
    }
    
    var title: String = "" {
        didSet{
            self.label.text = title
        }
    }
    
    
    private func setStyle(_ style: Style){
        switch style {
            case .correct:
            self.backgroundColor = UIColor(red: 200.0/255.0, green: 236.0/255.0, blue: 160.0/255.0, alpha: 1)
            self.icon.image = UIImage(named: "Icon Correct")
            
            case .incorrect:
            self.backgroundColor = UIColor(red: 243.0/255.0, green: 135.0/255.0, blue: 148.0/255, alpha: 1)
            self.icon.image = UIImage(named: "Icon Error")
            case .standard:
            self.backgroundColor = UIColor(red: 191.0/255.0, green: 196.0/255.0, blue: 201.0/255, alpha: 1)
            self.icon.isHidden = true
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
