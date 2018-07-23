//
//  IletisimViewController.swift
//  iosuygulama
//
//  Created by tolga iskender on 23.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit
import MessageUI
class IletisimViewController: UIViewController, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var isim: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var dogum: UITextField!
    @IBOutlet weak var Tel: UITextField!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Tel.keyboardType = UIKeyboardType.numberPad
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(IletisimViewController.degis(datePicker:)), for: .valueChanged)
        _ = UIGestureRecognizer(target: self, action: #selector(IletisimViewController.eDokun(gestureRecognizer:)))
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(IletisimViewController.dismissPicker))
        
        dogum.inputAccessoryView = toolBar
        dogum.inputView = datePicker
        
    }
    @objc func dismissPicker() {
        
        view.endEditing(true)
        
    }
    func mailConfigure() -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        
        mail.setToRecipients(["gokhan.gokoya@neyasis.com"])
        mail.setSubject("Merhaba")
        mail.setMessageBody("iyi Günler", isHTML: false)
        
        return mail
    }
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Uyarı", message: "Mail Gönderilemedi", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    @objc func eDokun(gestureRecognizer: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    @objc func degis(datePicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dogum.text=dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
     }
    @IBAction func Send(_ sender: Any) {
       if (email.text?.validEmail())! && (Tel.text?.validTel())! && (isim.text?.validAd())! && email.text != "" && isim.text != "" && dogum.text != "" && Tel.text != "" {
        let mailController = mailConfigure()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailController, animated: true, completion: nil)
        } else {
            showMailError()
        }
        }
        else
       {
        let alert = UIAlertController(title: "Uyarı", message: "Bilgilerinizi Kontrol Ediniz !", preferredStyle: .alert)
        let action = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        }
    }
   
    
}
extension String {
    func validEmail() -> Bool {
       
        let regex = try! NSRegularExpression(pattern: "^([a-zA-Z0-9._-])+([a-zA-Z0-9])@([a-zA-Z]{3,15}).([a-z]{3,7}(.[a-z]{2,5})?)$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    func validAd() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z]{3,30}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func validTel() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[0][5][0-5][0-9]{8}+$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
}
extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Kapat", style: UIBarButtonItemStyle.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
