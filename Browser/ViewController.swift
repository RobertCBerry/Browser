//
//  ViewController.swift
//  Browser
//
//  Created by Robert Berry on 3/22/18.
//  Copyright © 2018 Robert Berry. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {
    
    // MARK: Properties
    
    var webView: WKWebView
   
    @IBOutlet weak var barView: UIView!
    
    @IBOutlet weak var urlField: UITextField!
   
    @IBOutlet weak var progressView: UIProgressView!
    
    // Bar Button Items
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    @IBOutlet weak var reloadButton: UIBarButtonItem!
   
    required init(coder aDecoder: NSCoder) {
        
        self.webView = WKWebView(frame: CGRect.zero)
        super.init(coder: aDecoder)!
        
        // ViewController class is the navigation delegate of the web view.
        
        self.webView.navigationDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the size of the barView when the app loads.
        
        barView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        
        func viewWillTransitionToSize(size: CGSize, with: UIViewControllerTransitionCoordinator) {
            
            barView.frame = CGRect(x: 0, y: 0, width: size.width, height: 30)
        }
        
        // Add web view to the main view, below the progress view.
        
        view.insertSubview(webView, belowSubview: progressView)
        
        // Constraints for web view.
        
        // Disable auto generated constraints.
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Define height and width for web view. 
        
        let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: -44)
        
        let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        
        view.addConstraints([height, width])
        
        // Adds class as an observer of the loading property.
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        // Create URL object from a string.
        
        let url = URL(string: "http://www.appcoda.com")
        
        // Create URL request.
        
        let request = URLRequest(url: url!)
        
        webView.load(request)
        
        // Disable back and forward button upon app launch.
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        urlField.resignFirstResponder()
        
        webView.load(URLRequest(url: URL(string: urlField.text!)!))
        
        return false
    }
    
    // Bar Button Action Items
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        webView.goBack()
    }
    
    @IBAction func forward(_ sender: UIBarButtonItem) {
        
        webView.goForward()
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        
        let request = URLRequest(url: webView.url!)
        
        webView.load(request)
    }
    
    // Method called when the observable property changes. The state of the back and forward buttons will be changed according to the current state of the web view.
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "loading") {
            
            backButton.isEnabled = webView.canGoBack
            
            forwardButton.isEnabled = webView.canGoForward
        }
        
        if (keyPath == "estimatedProgress") {
            
            // Hide the progress view if the webView is completely loaded.
            
            progressView.isHidden = webView.estimatedProgress == 1
            
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    // MARK: WKWebview Delegate
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        // Add alert controller when there is issue loading URL.
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // Method is called when the page load completes. 
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        progressView.setProgress(0.0, animated: false)
    }
}

