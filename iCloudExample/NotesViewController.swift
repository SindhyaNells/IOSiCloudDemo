//
//  NotesViewController.swift
//  iCloudExample
//
//  Created by Sindhya on 10/6/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit
import CloudKit
import Foundation
import Dispatch
import Darwin

class NotesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var serviceCallTableView: UITableView!
    
    let service_db = CKContainer.default().publicCloudDatabase
    var serviceData=[ServiceCallData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        serviceCallTableView.delegate = self
        serviceCallTableView.dataSource = self
        loadServiceCallData()
        
    }
    
    func loadServiceCallData(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "CustServiceApp", predicate: predicate)
        
        let operation = CKQueryOperation(query: query)
        var newData = [ServiceCallData]()
        operation.desiredKeys = ["location","callReason","description"]
        operation.resultsLimit = 50
        operation.recordFetchedBlock = {record in
            let rec = ServiceCallData()
            rec.callLocation = record["location"] as! String
            rec.reason = record["callReason"] as! String
            rec.desc = record["description"] as! String
            newData.append(rec)
            
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.serviceData = newData
                    self.serviceCallTableView.reloadData()
                } else {
                    let ac = UIAlertController(title: "Error Fetching Data", message: "There was a problem fetching the service data \(error!.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = serviceCallTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = serviceData[indexPath.row].reason
        return cell
    }

}
