//
//  DetailsViewController.swift
//  Flashcard App
//
//  Created by christinaathecoder on 7/5/22.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var deckTextField: UITextField!
    @IBOutlet weak var addDeckButton: UIButton!
    @IBOutlet weak var editDeckButton: UIButton!
    @IBOutlet weak var flashcardTable: UITableView!
    @IBOutlet weak var studyButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var alertYesBtn: UIButton!
    @IBOutlet weak var alertNoBtn: UIButton!
    @IBOutlet weak var cancelAlertView: UIView!
    @IBOutlet weak var cancelAlertTitleLbl: UILabel!
    @IBOutlet weak var cancelAlertMsgLbl: UILabel!
    @IBOutlet weak var cancelAlertYesBtn: UIButton!
    @IBOutlet weak var cancelAlertNoBtn: UIButton!
    @IBOutlet var mainView: UIView!
    
    var flashcards: [[String:String]] = []
    let DS = DefaultSettings()
    var modalSwipeExit = true
    var newFlag = false
    var index = 0
    var mainVC: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashcards = mainVC.sections[index].flashcards
        
        //alerts
        alertView.isHidden = true
        cancelAlertView.isHidden = true
        
        //button settings
        DS.setRight(btn: saveButton)
        DS.setLeft(btn: cancelButton)
        DS.setRight(btn: addDeckButton)
        DS.setLeft(btn: editDeckButton)
        DS.setBigButton(btn: studyButton)
        DS.setRight(btn: alertNoBtn)
        DS.setLeft(btn: alertYesBtn)
        DS.setLeft(btn: cancelAlertYesBtn)
        DS.setRight(btn: cancelAlertNoBtn)
        
        //text field settings
        if mainVC.newFlag == false {
            subjectTextField.isUserInteractionEnabled = false
            deckTextField.isUserInteractionEnabled = false
            saveButton.setTitle("update", for: .normal)
        } else {
            DS.setTextField(txtField: subjectTextField)
            DS.setTextField(txtField: deckTextField)
        }
        
        flashcardTable.delegate = self
        flashcardTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subjectTextField.text = mainVC.sections[index].subject
        subjectTextField.font = .sansSequelSemi(size: 20.0)
        subjectTextField.textColor = DS.transblack
        deckTextField.text = mainVC.sections[index].deck
        deckTextField.font = .sansSequelMed(size: 16.0)
        deckTextField.textColor = DS.transblack
        
        let fileURL = mainVC.self.dataFileURL()
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(mainVC.self.sections) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error writing to file.")
            }
        }
        mainVC.mainTableView.reloadData()
        
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if mainVC.newFlag && modalSwipeExit {
            mainVC.sections.remove(at: index)
            mainVC.mainTableView.reloadData()
            mainVC.newFlag = false
        }
        
    }
    
    //MARK: BUTTON ACTIONS
    @IBAction func cardEditPressed(_ sender: UIButton) {
        flashcardTable.isEditing = !flashcardTable.isEditing
        if sender.currentTitle == "edit" || sender.currentTitle == nil {
            sender.setTitle("done", for: .normal)
            subjectTextField.isUserInteractionEnabled = true
            deckTextField.isUserInteractionEnabled = true
            DS.setTextField(txtField: subjectTextField)
            DS.setTextField(txtField: deckTextField)
        }
        else if sender.currentTitle == "done" {
            sender.setTitle("edit", for: .normal)
            subjectTextField.isUserInteractionEnabled = false
            deckTextField.isUserInteractionEnabled = false
            subjectTextField.layer.borderWidth = 0
            deckTextField.layer.borderWidth = 0
        }
    }
    
    @IBAction func alertNoBtnPressed(_ sender: Any) {
        alertView.isHidden = true
        DS.dismissAlert()
    }
    
    @IBAction func alertYesBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "addFlashcard", sender: self)
    }
    
    @IBAction func saveTouch(_ sender: Any) {
        mainVC.sections[index].subject = subjectTextField.text!
        mainVC.sections[index].deck = deckTextField.text!
        mainVC.sections[index].flashcards = flashcards
        
        modalSwipeExit = false
        mainVC.newFlag = false
        
        let fileURL = mainVC.self.dataFileURL()
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(mainVC.self.sections) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error writing to file.")
            }
        }
        mainVC.mainTableView.reloadData()
    }
    
    @IBAction func cancelTouch(_ sender: Any) {
        if subjectTextField.text != mainVC.sections[index].subject || deckTextField.text != mainVC.sections[index].deck || flashcards != mainVC.sections[index].flashcards {
            cancelAlertView.isHidden = false
            // alert for when cancelling and changes are not saved
            let title = "changes not saved"
            let msg = "would you like to save your changes now?"
            DS.makeCustomAlert(alertView: cancelAlertView, mainView: mainView, label1: cancelAlertTitleLbl, label2: cancelAlertMsgLbl, title: title, msg: msg)
        }
        else {
            performSegue(withIdentifier: "cancel", sender: self)
        }
    }
    
    @IBAction func cancelAlertNoPressed(_ sender: Any) {
        performSegue(withIdentifier: "cancel", sender: self)
    }
    
    @IBAction func cancelAlertYesPressed(_ sender: Any) {
        saveTouch(self)
        performSegue(withIdentifier: "saved", sender: self)
    }
    
    // MARK: SEGUE
    @IBAction func unwindToDetailsViewController(segue: UIStoryboardSegue) {
        flashcardTable.reloadData()
    }
    
    // show alert if no cards in deck
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "study" {
            if flashcards.count == 0 {
                alertView.isHidden = false
                let alertTitle = "uh oh! no flashcards :("
                let displayMsg = "would you like to add some now?"
                DS.makeCustomAlert(alertView: alertView, mainView: mainView, label1: alertTitleLabel, label2: alertMessageLabel, title: alertTitle, msg: displayMsg)
                return false
            }
        }
        return true
    }
    
    //MARK: TABLES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = flashcardTable.dequeueReusableCell(withIdentifier: "flashcardCell", for: indexPath)
        let card = flashcards[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.text = card["term"]
        cell.textLabel?.font = .sansSequelMed(size: 14.0)
        cell.textLabel?.textColor = DS.transblack
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = flashcards[sourceIndexPath.row]
        flashcards.remove(at: sourceIndexPath.row)
        flashcards.insert(moveCell, at: destinationIndexPath.row)
        flashcardTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            flashcards.remove(at: indexPath.row)
            flashcardTable.reloadData()
        }
    }
    
    //MARK: NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editFlashcard") {
            let controller = (segue.destination as! FlashcardDetailsViewController)
            controller.detailsVC = self
            if let indexPath = flashcardTable.indexPathForSelectedRow {
                controller.index = indexPath.row
            }
        }
        else if (segue.identifier == "addFlashcard") {
            let controller = (segue.destination as! FlashcardDetailsViewController)
            controller.detailsVC = self
            controller.index = 0
            newFlag = true
            
            let newCard = ["term":"term", "definition":"definition"]
            
            flashcards.insert(newCard, at: 0)
            
            flashcardTable.reloadData()
        }
        else if (segue.identifier == "study") {
            let controller = (segue.destination as! StudyViewController)
            controller.detailsVC = self
            controller.index = 0
        }
    }
    
}
