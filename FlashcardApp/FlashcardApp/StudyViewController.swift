//
//  StudyViewController.swift
//  Flashcard App
//
//  Created by christinaathecoder on 7/8/22.
//

import UIKit

class StudyViewController: UIViewController {
    
    let DS = DefaultSettings()
    
    @IBOutlet weak var studyTermLabel: PaddingLabel!
    @IBOutlet weak var studyDefLabel: PaddingLabel!
    @IBOutlet weak var flashcardNextBtn: UIButton!
    @IBOutlet weak var flashcardPrevBtn: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var alertYesBtn: UIButton!
    @IBOutlet weak var alertNoBtn: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var shuffleBtn: UIButton!
    @IBOutlet weak var shuffleAlertView: UIView!
    @IBOutlet weak var shuffleAlertTitleLabel: UILabel!
    @IBOutlet weak var shuffleAlertMessageLabel: UILabel!
    @IBOutlet weak var shuffleYesBtn: UIButton!
    @IBOutlet weak var shuffleNoBtn: UIButton!
    @IBOutlet weak var alertOkBtn: UIButton!
    @IBOutlet weak var prevAlertTitleLabel: UILabel!
    @IBOutlet weak var prevAlertMessageLabel: UILabel!
    @IBOutlet weak var prevAlertView: UIView!
    var detailsVC: DetailsViewController!
    var studyVC: StudyViewController!
    var flashcards: [[String:String]] = []
    var index = 0
    
    override func viewDidLoad() {
        //button styling
        DS.setRight(btn: flashcardNextBtn)
        DS.setLeft(btn: flashcardPrevBtn)
        DS.setRight(btn: alertNoBtn)
        DS.setLeft(btn: alertYesBtn)
        DS.setBigButton(btn: shuffleBtn)
        DS.setBigButton(btn: alertOkBtn)
        DS.setLeft(btn: shuffleYesBtn)
        DS.setRight(btn: shuffleNoBtn)
        
        //label styling
        DS.setLabel(lbl: studyTermLabel)
        studyTermLabel.font = .sansSequelBold(size: 20.0)
        DS.setLabel(lbl: studyDefLabel)
        studyDefLabel.font = .sansSequelMed(size: 16.0)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        mainView.addGestureRecognizer(leftSwipe)
        mainView.addGestureRecognizer(rightSwipe)
        
        flashcards = detailsVC.flashcards
    }
    
    override func viewWillAppear(_ animated: Bool) {
        alertView.isHidden = true
        shuffleAlertView.isHidden = true
        prevAlertView.isHidden = true
        
        studyTermLabel.text = flashcards[index]["term"]
        studyDefLabel.text = flashcards[index]["definition"]
        
        studyDefLabel.isHidden = true
    }
    
    //MARK: BUTTON ACTIONS
    @IBAction func shuffleBtnPressed(_ sender: Any) {
        shuffleAlertView.isHidden = false
        let alertTitle = "let's shuffle!"
        let displayMsg = "this will restart your deck, are you sure you want to continue?"
        DS.makeCustomAlert(alertView: shuffleAlertView, mainView: mainView, label1: shuffleAlertTitleLabel, label2: shuffleAlertMessageLabel, title: alertTitle, msg: displayMsg)
    }
    
    @IBAction func shuffleYesBtnPressed(_ sender: Any) {
        flashcards.shuffle()
        index = 0
        DS.dismissAlert()
        viewWillAppear(true)
    }
    
    @IBAction func shuffleNoBtnPressed(_ sender: Any) {
        shuffleAlertView.isHidden = true
        DS.dismissAlert()
    }
    
    @IBAction func alertNoBtnPressed(_ sender: Any) {
        cancelStudy()
    }
    
    @IBAction func alertYesBtnPressed(_ sender: Any) {
        startOver()
    }
    
    @IBAction func alertOkBtnPressed(_ sender: Any) {
        prevAlertView.isHidden = true
        DS.dismissAlert()
    }
    
    @IBAction func nextBtnTouch(_ sender: Any) {
        studyDefLabel.isHidden = true
        if index+1 < flashcards.count {
            index += 1
            studyTermLabel.text = flashcards[index]["term"]
            studyDefLabel.text = flashcards[index]["definition"]
        } else {
            alertView.isHidden = false
            let alertTitle = "congratulations!"
            let displayMsg = "you finished your deck :), keep studying?"
            DS.makeCustomAlert(alertView: alertView, mainView: mainView, label1: alertTitleLabel, label2: alertMessageLabel, title: alertTitle, msg: displayMsg)
        }
    }
    
    @IBAction func prevBtnTouch(_ sender: Any) {
        studyDefLabel.isHidden = true
        if index-1 >= 0 {
            index -= 1
            studyTermLabel.text = flashcards[index]["term"]
            studyDefLabel.text = flashcards[index]["definition"]
        } else {
            prevAlertView.isHidden = false
            let alertTitle = "uh oh!"
            let alertMsg = "you've reached the beginning of your deck!"
            DS.makeCustomAlert(alertView: prevAlertView, mainView: mainView, label1: prevAlertTitleLabel, label2: prevAlertMessageLabel, title: alertTitle, msg: alertMsg)
        }
    }
    
    //MARK: TAP GESTURES
    @IBAction func flipCard(_ sender: Any) {
        if studyDefLabel.isHidden == true {
            studyDefLabel.isHidden = false
        } else {
            studyDefLabel.isHidden = true
        }
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            prevBtnTouch(self)
        }
        if sender.direction == .right {
            nextBtnTouch(self)
        }
    }
    
    //MARK: OTHER
    func cancelStudy() {
        performSegue(withIdentifier: "studyDone", sender: self)
    }
    
    func startOver() {
        DS.dismissAlert()
        index = 0
        viewWillAppear(true)
    }
    
}
