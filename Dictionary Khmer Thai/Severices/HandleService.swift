//
//  HandleService.swift
//  Dictionary Khmer Thai
//
//  Created by ROS DUL on 2/8/23.
//

import Foundation
import UIKit
import CoreData
class HandleService{
    var context = UIApplication.shared.delegate as! AppDelegate
    var appDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dataDictionary: [Dictionary_Khmer_Thai] = []
    
    func fetchData() ->[Dictionary_Khmer_Thai]{
        do{
            dataDictionary = try! appDelegate.fetch(Dictionary_Khmer_Thai.fetchRequest())
        }catch{
            print("Con't fecthData +\(error)")
        }
        return dataDictionary
    }
    func searchData(thaiWord: String) ->[Dictionary_Khmer_Thai]{
            dataDictionary = try! appDelegate.fetch(Dictionary_Khmer_Thai.fetchRequest())
            let predicate = NSPredicate(format: "thai contains %@", thaiWord)
            //thai គឺជាឈ្មោះនៃ fill
            let request: NSFetchRequest = Dictionary_Khmer_Thai.fetchRequest()
            request.predicate = predicate
        do{
            dataDictionary = try! (appDelegate.fetch(request))
        }catch{
            print("Con't Search Data +\(error)")
        }
        return dataDictionary
    }

}
