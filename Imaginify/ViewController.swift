//
//  ViewController.swift
//  Imaginify
//
//  Created by macbook pro on 13.04.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let textField = UITextField()
    let myButton = UIButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "Input"
        textField.backgroundColor = .black
        textField.textColor = .systemYellow
        textField.tintColor = .systemBlue
        textField.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        textField.delegate = self
        view.addSubview(textField)
        
        myButton.backgroundColor = .systemBlue
        myButton.layer.cornerRadius = 10.0
        myButton.layer.borderWidth = 3.0
        myButton.layer.borderColor = UIColor.red.cgColor
        myButton.setTitleColor(.systemGreen, for: .normal)
        view.addSubview(myButton)
        
        guard let inputText = textField.text else { return }
        
        let action = UIAction(title: "Tap me!") { _ in
            self.fetchData(inputText)
        }
        myButton.addAction(action, for: .touchUpInside)
        makeconstarint()
    }
    
    private func makeconstarint() {
        textField.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        myButton.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-20)
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
    }
    
    private func fetchData(_ input: String) {
        let url = URL(string: "https://openai80.p.rapidapi.com/images/generations")!
        let key = "462f9b99bfmsh36b97096c100fafp122c02jsne81254c63549"
        let host = "openai80.p.rapidapi.com"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue(key, forHTTPHeaderField: "X-RapidAPI-Key")
        request.addValue(host, forHTTPHeaderField: "X-RapidAPI-Host")

        let prompt = "\(input)"
        let body: [String: Any] = [
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024"
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])

        request.httpBody = jsonData

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Unexpected response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP response status code: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            let responseJson = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            if let data = responseJson["data"] as? [[String: Any]],
               let imageUrl = data.first?["url"] as? String {
                print(imageUrl)
            } else {
                print("Invalid response format")
            }
        }

        task.resume()

    }

}


