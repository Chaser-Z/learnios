//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Jason on 01/08/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var objectTF: UITextField!
    @IBOutlet weak var propertyTF: UITextField!
    @IBOutlet weak var conditionTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var dataArr:[People] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArr = DataManager.fetchAllObject()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func   tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.setData(people: dataArr[indexPath.row])
        
        return cell
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        switch sender.tag {
            
        case 1:
            if objectTF.text != "" && propertyTF.text != "" && conditionTF.text != "" {
                addObject(object: objectTF.text!, property: propertyTF.text!, condition: conditionTF.text!)
            } else {
                showMessage(message: "内容不能为空")
            }
            
        case 2:
            if objectTF.text != "" && propertyTF.text != "" && conditionTF.text != "" {
                deleteObject(object: objectTF.text!, property: propertyTF.text!, condition: conditionTF.text!)
            } else {
                showMessage(message: "内容不能为空")
            }

        case 3:
            if objectTF.text != "" && propertyTF.text != "" && conditionTF.text != "" {
                changeObject(object: objectTF.text!, property: propertyTF.text!, condition: conditionTF.text!)
            } else {
                showMessage(message: "内容不能为空")
            }

        case 4:
            if objectTF.text != "" && propertyTF.text != "" && conditionTF.text != "" {
                fetchObject(object: objectTF.text!, property: propertyTF.text!, condition: conditionTF.text!)
            } else {
                showMessage(message: "内容不能为空")
            }

        default:
            return
            
        }
        
    }
    private func addObject(object: String,property: String,condition: String){
        
        DataManager.addObject(object: object, property: property, condition: condition)
        dataArr = DataManager.fetchAllObject()
        tableView.reloadData()
    }
    private func deleteObject(object: String,property: String,condition: String){
        
        DataManager.deleteObject(object: object, property: property, condition: condition)
        dataArr = DataManager.fetchAllObject()
        tableView.reloadData()
    }
    private func changeObject(object: String,property: String,condition: String){
        
        DataManager.changeObject(object: object, property: property, condition: condition)
        dataArr = DataManager.fetchAllObject()
        tableView.reloadData()
        
    }
    private func fetchObject(object: String,property: String,condition: String){
        
      let dataCount = DataManager.fetchObjectDetail(object: object, property: property, condition: condition).count
        
        showMessage(message: "查询到\(dataCount)条数据")
        
    }
    private func showMessage(message:String){
        
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
     
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

