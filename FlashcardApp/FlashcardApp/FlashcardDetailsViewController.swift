//
//  FlashcardDetailsViewController.swift
//  Flashcard App
//
//  Created by christinaathecoder on 7/7/22.
//

import UIKit

class FlashcardDetailsViewController: UIViewController, UITextViewDelegate {
    let DS = DefaultSettings()
    
    @IBOutlet weak var definitionTextView: UITextView!
    @IBOutlet weak var termTextView: UITextView!
    @IBOutlet weak var flashcardSaveButton: UIButton!
    @IBOutlet weak var flashcardCancelButton: UIButton!
    @IBOutlet weak var cancelBtnView: UIView!
    @IBOutlet weak var saveBtnView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var emptyAlertView: UIView!
    @IBOutlet weak var emptyAlertTitleLabel: UILabel!
    @IBOutlet weak var emptyAlertMsgLabel: UILabel!
    @IBOutlet weak var emptyAlertOkButton: UIButton!
    
    var index = 0
    var modalSwipeExit = true
    var detailsVC: DetailsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyAlertView.isHidden = true
        termTextView.text = detailsVC.flashcards[index]["term"]
        definitionTextView.text = detailsVC.flashcards[index]["definition"]
        
        //text view settings
        DS.setTextView(txtView: termTextView)
        termTextView.font = .sansSequelBold(size: 20.0)
        DS.setTextView(txtView: definitionTextView)
        definitionTextView.font = .sansSequel(size: 16.0)
        
        //button settings
        DS.setRight(btn:flashcardSaveButton)
        DS.setLeft(btn:flashcardCancelButton)
        DS.setBigButton(btn: emptyAlertOkButton)
        
        //tap gestures
        let termTap = UITapGestureRecognizer(target: self, action: #selector(self.termTapped))
        let defTap = UITapGestureRecognizer(target: self, action: #selector(self.defTapped))
        let tapOut = UITapGestureRecognizer(target: self, action: #selector(self.tapOut))
        termTextView.addGestureRecognizer(termTap)
        definitionTextView.addGestureRecognizer(defTap)
        mainView.addGestureRecognizer(tapOut)
        
        termTextView.delegate = self
        definitionTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if termTextView.text == "term" || termTextView.text == ""{
            termTextView.text = "term"
            termTextView.textColor = DS.gray
        } else {
            termTextView.textColor = DS.transblack
        }
        if definitionTextView.text == "definition" || definitionTextView.text == "" {
            definitionTextView.text = "definition"
            definitionTextView.textColor = DS.gray
        } else {
            definitionTextView.textColor = DS.transblack
        }
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if detailsVC.newFlag && modalSwipeExit {
            detailsVC.flashcards.remove(at: index)
            detailsVC.flashcardTable.reloadData()
            detailsVC.newFlag = false
        }
    }
    
    //MARK: TAP GESTURES
    func textViewShouldReturn (_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    @objc func tapOut() {
        textViewShouldReturn(termTextView)
        textViewShouldReturn(definitionTextView)
        viewWillAppear(true)
    }
    
    @objc func termTapped() {
        if termTextView.text == "term" {
            termTextView.text = ""
            termTextView.textColor = DS.transblack
        }
        if definitionTextView.text == "" {
            definitionTextView.text = "definition"
            definitionTextView.textColor = DS.gray
        }
        termTextView.becomeFirstResponder()
    }
    
    @objc func defTapped() {
        if definitionTextView.text == "definition" {
            definitionTextView.text = ""
            definitionTextView.textColor = DS.transblack
        }
        if termTextView.text == "" {
            termTextView.text = "term"
            termTextView.textColor = DS.gray
        }
        definitionTextView.becomeFirstResponder()
    }
    
    //MARK: BUTTON ACTIONS
    @IBAction func flashcardSaveTouch(_ sender: Any) {
        if termTextView.text == "" || termTextView.text == "term" || definitionTextView.text == "" || definitionTextView.text == "definition" {
            emptyAlertView.isHidden = false
            let alertTitle = "you're missing something!"
            let alertMsg = "please fill in your flashcards"
            DS.makeCustomAlert(alertView: emptyAlertView, mainView: mainView, label1: emptyAlertTitleLabel, label2: emptyAlertMsgLabel, title: alertTitle, msg: alertMsg)

        } else {
            detailsVC.flashcards[index]["term"] = termTextView.text
            detailsVC.flashcards[index]["definition"] = definitionTextView.text
            modalSwipeExit = false
            detailsVC.newFlag = false
            performSegue(withIdentifier: "saved", sender: self)
        }
    }
    
    //MARK: ALERTS
    @IBAction func emptyAlertOkPressed(_ sender: Any) {
        emptyAlertView.isHidden = true
        DS.dismissAlert()
    }
    
    @IBAction func flashcardCancelTouch(_ sender: Any) {
        viewWillDisappear(true)
    }
    
}
