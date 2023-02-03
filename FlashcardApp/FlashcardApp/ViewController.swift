//
//  ViewController.swift
//  Flashcard App
//
//  Created by christinaathecoder on 7/5/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var addBtnView: UIView!
    @IBOutlet weak var editBtnView: UIView!
    var sections: [SectionsObject] = []
    let DS = DefaultSettings()
    var newFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title label settings
        let gradient = CAGradientLayer()
        gradient.colors = [DS.orange, DS.pink, DS.purple]

        gradient.startPoint = CGPoint(x: 0.2, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.8, y: 0.5)
        gradient.frame = labelView.bounds
        labelView.layer.addSublayer(gradient)
        labelView.mask = titleLabel
        titleLabel.text = "flashcard app"
        titleLabel.font = .sansSequelBold(size: 28.0)
        
        //button settings
        DS.setRight(btn: addBtn)
        DS.setLeft(btn: editBtn)
    
        //file management
        let file = dataFileURL()
        
        if (FileManager.default.fileExists(atPath: file.path)) {
            //use JSON instead of plist
            do {
                let data = try Data(contentsOf: file)
                let decoder = JSONDecoder()
                sections = try decoder.decode(Array<SectionsObject>.self, from: data)
                print(file.path)
            } catch {
                print("error finding file")
            }
        }
        else {
            print("file not found")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: BUTTONS
    @IBAction func editTouch(_ sender: UIButton) {
        mainTableView.isEditing =  !mainTableView.isEditing
        
        if sender.currentTitle == "edit" || sender.currentTitle == nil {
            sender.setTitle("done", for: .normal)
        }
        else {
            sender.setTitle("edit", for: .normal)
        }
    }
    
    //MARK: TABLES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = sections[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.text = section.subject
        cell.textLabel?.font = .sansSequelMed(size: 18.0)
        cell.textLabel?.textColor = DS.transblack
        cell.detailTextLabel?.text = section.deck
        cell.detailTextLabel?.font = .sansSequel(size: 14.0)
        cell.detailTextLabel?.textColor = DS.transblack
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = sections[sourceIndexPath.row]
        sections.remove(at: sourceIndexPath.row)
        sections.insert(moveCell, at: destinationIndexPath.row)
        mainTableView.reloadData()
        let fileURL = self.dataFileURL()
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self.sections) {
            do {
                try data.write(to: fileURL)
                print(fileURL)
            } catch {
                print("error writing to file.")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sections.remove(at: indexPath.row)
            mainTableView.reloadData()
            let fileURL = self.dataFileURL()
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(self.sections) {
                do {
                    try data.write(to: fileURL)
                    print(fileURL)
                } catch {
                    print("error writing to file.")
                }
            }
        }
    }
    
    //MARK: SEGUES
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        mainTableView.reloadData()
    }
    
    // MARK: NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = (segue.destination as! DetailsViewController)
        controller.mainVC = self
        if (segue.identifier == "details") {
            if let indexPath = mainTableView.indexPathForSelectedRow {
                controller.index = indexPath.row
            }
        }
        else if (segue.identifier == "new") {
            controller.index = 0
            newFlag = true
            let newDeck = SectionsObject()
            newDeck.subject = ""
            newDeck.deck = ""
            newDeck.flashcards = []
            
            sections.insert(newDeck, at: 0)
            mainTableView.reloadData()
        }
    }
    
    // MARK: DATA
    func dataFileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url:URL?
        url = URL(fileURLWithPath: "")
        url = urls.first!.appendingPathComponent("flashcards.json")
        return url!
    }
    
    @objc func applicationWillResignActive(notification:NSNotification) {
        let fileURL = self.dataFileURL()
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self.sections) {
            do {
                try data.write(to: fileURL)
                print(fileURL)
            } catch {
                print("error writing to file.")
            }
        }
    }
}

// MARK: FONT

extension UIFont {
    static func sansSequelSemi(size: CGFloat) -> UIFont? {
        return UIFont(name: "SequelSans-SemiBoldDisp", size: size)
    }
    static func sansSequel(size: CGFloat) -> UIFont? {
        return UIFont(name: "SequelSans-BookDisp", size: size)
    }
    static func sansSequelBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "SequelSans-BoldDisp", size: size)
    }
    static func sansSequelMed(size: CGFloat) -> UIFont? {
        return UIFont(name: "SequelSans-MediumDisp", size: size)
    }
}
