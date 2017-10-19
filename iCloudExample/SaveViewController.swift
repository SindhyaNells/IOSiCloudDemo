//
//  SaveViewController.swift
//  iCloudExample
//
//  Created by Sindhya on 10/4/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit
import CloudKit
import Foundation

class SaveViewController: UIViewController {

    let service_db = CKContainer.default().publicCloudDatabase
    
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var txtCallReason: UITextField!
    
    @IBOutlet weak var txtDesc: UITextField!
    
    @IBOutlet weak var btnView: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnSave(_ sender: Any) {
        
        let callRecord = CKRecord(recordType: "CustServiceApp")
        callRecord.setObject(txtLocation.text! as CKRecordValue?, forKey: "location")
        callRecord.setObject(txtCallReason.text! as CKRecordValue?, forKey: "callReason")
        callRecord.setObject(txtDesc.text! as CKRecordValue?, forKey: "description")
        
        service_db.save(callRecord) {
            (record, error) in
            if error != nil {
                print("Error saving data"+(error?.localizedDescription)!)
            } else {
                print("The record is saved in database!")
            }
            }
        
        self.showAlert(title: "Cloud Storage", message: "Data saved in cloud successfully!")
        
    }
    
    
    func showAlert(title:NSString,message:NSString)
    {
        let alertController:UIAlertController=UIAlertController(title:title as String, message: message as String as String, preferredStyle: UIAlertControllerStyle.alert)
        let successAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.txtLocation.text=""
            self.txtDesc.text=""
            self.txtCallReason.text=""
            
        }
        alertController.addAction(successAction)
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue:UIStoryboardSegue , sender: Any?) {
       
    }
    
}

