//
//  FaqsViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/28/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit

class FaqsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: WebView!

    @IBAction func doneButton(_ sender: UIButton) {
        // Close window
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = Bundle.main.url(forResource: "FAQs", withExtension: "html")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        webView.delegate = self
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

}
