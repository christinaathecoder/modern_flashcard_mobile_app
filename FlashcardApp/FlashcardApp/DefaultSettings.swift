//
//  DefaultSettings.swift
//  Flashcard App
//
//  Created by christinaathecoder on 7/5/22.
//

import UIKit
class DefaultSettings: UIViewController {
    
    //colors
    let transWhite =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.8)
    let purple =  UIColor(red: 112.0/255.0, green: 129.0/255.0, blue: 191.0/255.0, alpha: 1.0).cgColor
    let pink =  UIColor(red: 216.0/255.0, green: 90.0/255.0, blue: 138.0/255.0, alpha: 1.0).cgColor
    let orange =  UIColor(red: 240.0/255.0, green: 99.0/255.0, blue: 71.0/255.0, alpha: 1.0).cgColor
    let transblack = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.9)
    let gray = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    
    func getGradientLayer(bounds : CGRect) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        //order of gradient colors
        gradient.colors = [orange, pink, purple]
        // start and end points
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }
    
    func getGradientLayer2(bounds : CGRect) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        //order of gradient colors
        gradient.colors = [purple, pink, orange]
        // start and end points
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }
    
    func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
          //create UIImage by rendering gradient layer.
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
          //get gradient UIcolor from gradient UIImage
        return UIColor(patternImage: image!)
    }
    
    func gradientColor2(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
          //create UIImage by rendering gradient layer.
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
          //get gradient UIcolor from gradient UIImage
        return UIColor(patternImage: image!)
    }
    
    //MARK: LABELS
    func setLabel(lbl: UILabel) {
        lbl.layer.borderWidth = 1
        lbl.layer.borderColor = gradientColor(bounds: lbl.bounds, gradientLayer: getGradientLayer(bounds: lbl.bounds))?.cgColor
        lbl.textColor = transblack
        lbl.layer.cornerRadius = 15
    }
    
    func gradientLabel(lbl: UILabel) {
        let gradient = getGradientLayer(bounds: lbl.bounds)
        lbl.textColor = (gradientColor(bounds: lbl.bounds, gradientLayer: gradient))
    }
    
    //MARK: TEXT FIELD
    func setTextField(txtField: UITextField) {
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = gradientColor(bounds: txtField.bounds, gradientLayer: getGradientLayer(bounds: txtField.bounds))?.cgColor
        txtField.layer.cornerRadius = 15
    }
    
    //MARK: TEXT VIEW
    func setTextView(txtView: UITextView) {
        txtView.layer.borderWidth = 1
        txtView.layer.borderColor = gradientColor2(bounds: txtView.bounds, gradientLayer: getGradientLayer2(bounds: txtView.bounds))?.cgColor
        txtView.layer.cornerRadius = 15
    }
    
    //MARK: BUTTONS
    func setLeft(btn: UIButton) {
        let gradient = getGradientLayer(bounds: btn.bounds)
        btn.setTitleColor(gradientColor(bounds: btn.bounds, gradientLayer: gradient), for: .normal)

        btn.titleLabel?.font = .sansSequelMed(size: 16.0)
    }
    
    func setRight(btn: UIButton) {
        let gradient = getGradientLayer2(bounds: btn.bounds)
        btn.setTitleColor(gradientColor2(bounds: btn.bounds, gradientLayer: gradient), for: .normal)

        btn.titleLabel?.font = .sansSequelMed(size: 16.0)
    }
    
    func setBigButton(btn: UIButton) {
        let gradient = getGradientLayer(bounds: btn.bounds)
        btn.setTitleColor(gradientColor(bounds: btn.bounds, gradientLayer: gradient), for: .normal)
        btn.layer.cornerRadius = 15
        btn.layer.borderWidth = 2
        btn.layer.borderColor = gradientColor(bounds: btn.bounds, gradientLayer: gradient)?.cgColor
        btn.titleLabel?.font = .sansSequelSemi(size: 16.0)
    }
    
    //MARK: ALERTS
    func makeCustomAlert(alertView: UIView, mainView: UIView, label1: UILabel, label2: UILabel, title: String, msg: String) {
        backgroundView.frame = mainView.bounds
        mainView.addSubview(backgroundView)
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        })
        alertView.backgroundColor = .white
        alertView.layer.masksToBounds = true
        alertView.layer.cornerRadius = 15
        mainView.addSubview(alertView)
        label1.text = title
        label1.font = .sansSequelSemi(size: 18.0)
        label1.textColor = transblack
        label2.text = msg
        label2.font = .sansSequel(size: 15.0)
        label2.textColor = transblack
    }
    
    func dismissAlert() {
        backgroundView.removeFromSuperview()
    }
}

