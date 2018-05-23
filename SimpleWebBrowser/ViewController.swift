//
//  ViewController.swift
//  SimpleWebBrowser
//
//  Created by Shaikat on 24/5/18.
//  Copyright © 2018 Shaikat. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate{
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    //for refactoring
    var webSites = ["apple.com","hackingwithswift.com"]
    
    //load the webview in view controller
    //loadview calls before view controller
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // we need to use KVO(key value object) for estimatded progress bar
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        //add bar button item programatically
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        //add a progressbar in the view load
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        
        
        // flexible bar button item
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progressButton,spacer,reload]
        navigationController?.isToolbarHidden = false
        
        
       
        
        //load the url
        //let url = URL(string: "https://www.hackingwithswift.com")!
        let url = URL(string: "https://" + webSites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    

    @objc func openTapped(){
        let alertController = UIAlertController(title: "Open page.. ", message: nil, preferredStyle: .actionSheet)
       // alertController.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        //alertController.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        for website in webSites{
            alertController.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        //for iPad
       // alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
       
        //for iPhone
        present(alertController, animated: true)
        
    }
    
    func openPage(action: UIAlertAction!){
        let url = URL(string: "https://" + action.title!)!
       // print(url)
        webView.load(URLRequest(url: url))
        
    }
    
    //setting the title to the web view title
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    //for observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webView.estimatedProgress)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //webview delegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url!
        
        if let host = url.host{
            for website in webSites{
                if host.range(of: website) != nil{
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }


}

