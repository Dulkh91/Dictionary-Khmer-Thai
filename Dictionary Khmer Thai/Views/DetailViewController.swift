//
//  DetailViewController.swift
//  Dictionary Khmer Thai
//
//  Created by ROS DUL on 6/8/23.
//

 
 import UIKit
 import AVFoundation

 class DetailViewController: UIViewController {
     
     @IBOutlet weak var phoneticLabel: UILabel!
     @IBOutlet weak var khmerWordLabel: UILabel!
     
     
     var thaiWord: String?
     var khmerWord: String?
     var phonetic: String?
     var btnWord = UIButton()
     
     var wordVoice = AVSpeechSynthesizer()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         customBNT()
         btnWord.titleLabel?.font = UIFont(name: "Athiti Bold", size: 20)
         if let thaiWord = thaiWord {
             phoneticLabel.text = ("/  \(phonetic!)  /")
             khmerWordLabel.text = khmerWord
             btnWord.setTitle(thaiWord, for: .normal)
             btnWord.setImage(UIImage(named: "Hearing"), for: .normal)
             btnWord.semanticContentAttribute = .forceRightToLeft
         }
         if view.frame.width > 550{
             khmerWordLabel.font = UIFont.systemFont(ofSize: 24.0)
             phoneticLabel.font = UIFont.systemFont(ofSize: 24.0)
             btnWord.titleLabel?.font = UIFont(name: "Athiti Bold", size: 28.0)
//             btnWord.titleLabel?.font = UIFont.systemFont(ofSize: 24.0)
         }
         
         
     }
    
 }
extension DetailViewController{
    func customBNT(){
        btnWord = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width - 150, height: 45))
        btnWord.addTarget(self, action: #selector(wordToVioce), for: .touchUpInside)
        btnWord.setTitleColor(.blue, for: .normal)
        navigationItem.titleView = btnWord
        
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        
    }
    
    @objc func wordToVioce(){
        
        let word = AVSpeechUtterance(string: thaiWord!)
        word.voice = AVSpeechSynthesisVoice(language: "th")
        self.wordVoice.speak(word)
    }
}





