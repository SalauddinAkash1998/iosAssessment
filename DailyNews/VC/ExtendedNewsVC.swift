//
//  DetailViewController.swift
//  NewsApp
//
//  Created by McKenzie Macdonald on 2/3/22.
//

import UIKit
import WebKit

class ExtendedNewsVC: UIViewController {
    
    
    
    @IBOutlet weak var webView: WKWebView!
    
    
    @IBOutlet weak var loadingSpin: UIActivityIndicatorView!
    var articleURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set self to be the webView's delegate
        webView?.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Check that there is a url
        if articleURL != nil {
            
            // Create the URL object
            if let url = URL(string: articleURL!) {
                
                // Create the URLRequest
                let request = URLRequest(url: url)
                
                // Start spinner
                loadingSpin?.alpha = 1
                loadingSpin?.startAnimating()
                
                // Load it into the webview
                webView?.alpha = 0
                webView?.load(request)
            }
        }
        
    }

}

extension ExtendedNewsVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // Stop the spinner and hide it
        
        loadingSpin.stopAnimating()
        loadingSpin.alpha = 0
        
        // Show the webView
        webView.alpha = 1
        
    }
    
}
