//
//  ThirdViewController.swift
//  PetsInARow
//
//  Created by Keith Lee on 5/6/17.
//  Copyright © 2017 Keith Lee. All rights reserved.
//

import UIKit
import MessageUI

class SupportViewController: UIViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate {
    // Model data for settings
    var settingsModel: SettingsModel?
    var statisticsModel: StatisticsModel?
    var gameModel: GameModel?
    
    @IBOutlet weak var webView: WebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = Bundle.main.url(forResource: "Help", withExtension: "html")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        webView.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        settingsModel = appDelegate?.settings
        statisticsModel = appDelegate?.statistics
        gameModel = appDelegate?.game
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

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if UIWebViewNavigationType.linkClicked == navigationType {
            if request.url?.scheme == "mailto" {
                if MFMailComposeViewController.canSendMail() {
                    // Create controller
                    let picker = MFMailComposeViewController()
                    picker.mailComposeDelegate = self
                    picker.setToRecipients(["support@motupresse.com"])
                    picker.setSubject("Pets In a Row Support")
                    
                    // Present view
                    picker.navigationBar.barStyle = UIBarStyle.black
                    self.present(picker, animated: true, completion: nil)
                }
                return false
            }
        }
        return true
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled: break
        case MFMailComposeResult.saved: break
        case MFMailComposeResult.sent: break
        case MFMailComposeResult.failed:
            let alert = UIAlertController(title: "@Email", message: "Sending failed, unknown error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
