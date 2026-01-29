//
//  ViewController.swift
//  Dictionary Khmer Thai
//
//  Created by ROS DUL on 2/8/23.
//

import UIKit
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
     // Mark-: search bar
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var handleService: HandleService!
    var displayedData = [Dictionary_Khmer_Thai]()
    
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        handleService = HandleService()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Mark-: search bar
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "ស្វែងរកពាក្យ"
    
        transferData()
      
    }
    private func transferData(){
        displayedData = handleService.fetchData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = displayedData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = data.thai
        if view.frame.width > 550{
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 24.0)
            searchBar.searchTextField.font = UIFont.systemFont(ofSize: 24.0)
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = displayedData[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "screenDetail") as? DetailViewController
        
        detailVC?.thaiWord = data.thai
        detailVC?.phonetic = data.phonetic
        detailVC?.khmerWord = data.khmer
        navigationController?.pushViewController(detailVC!, animated: true)
    }
    
    
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            displayedData = handleService.searchData(thaiWord: searchText)
            tableView.reloadData()
        }else{
            displayedData = handleService.fetchData()
        }
        tableView.reloadData()
        
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            searchBar.enablesReturnKeyAutomatically = true
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
   
}


