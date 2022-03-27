//
//  InfoViewController.swift
//  Kanji Book 5
//
//  Created by Ivan on 19/11/2018.
//

import UIKit
import MessageUI
import StoreKit

class InfoViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var Restore_btn: UIButton!
    @IBOutlet weak var RemoveAds_btn: UIButton!
    
    let isAdRemoved = UserDefaults.standard.object(forKey: "isAdRemoved") as? Bool ?? false
    
    let InAppPurchaseID = "com.KanjiJLPT5.RemoveAds"
    let paymentQueue = SKPaymentQueue.default()
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getProducts()
        /*let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)*/

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(isAdRemoved) {
            setAdsButtonsDisabled()
        }
        
    }

    @IBAction func shareApp(_ sender: Any) {
        let firstItem = "Learn kanji right on your device!"
        let secondItem = "itms-apps://itunes.apple.com/app/id1446854257"
        
        let activityVC = UIActivityViewController(activityItems: [firstItem, secondItem], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    @IBAction func rateButtonClicked(_ sender: Any) {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            let urlString = "itms-apps://itunes.apple.com/app/id1446854257"
            let url = URL(string: urlString)!
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func removeAd(_ sender: Any) {
        //UserDefaults.standard.set(true, forKey: "isAdRemoved")
        if (!isAdRemoved) {
            self.purchase()
        }
    }
    
    @IBAction func restorePurchases(_ sender: Any) {
        if (!isAdRemoved) {
            self.restorePurchases()
        }
    }
    
    func setAdsButtonsDisabled() {
        Restore_btn.isEnabled = false
        RemoveAds_btn.isEnabled = false
    }
    
    
    @IBAction func writeToSupport(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["kanjibook5@gmail.com"])
            mailVC.setSubject("Letter to support")
            self.present(mailVC, animated: true, completion: nil)
        } else {
            print("Unable to send email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProducts() {
        let products: Set = [self.InAppPurchaseID]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase() {
        guard let productToPurchase = products.filter({$0.productIdentifier == self.InAppPurchaseID}).first else {return}
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        print("restoring")
        paymentQueue.restoreCompletedTransactions()
        
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

extension InfoViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
}

extension InfoViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .failed:
                queue.finishTransaction(transaction)
                break
            case .purchased:
                fallthrough
            case .restored:
                UserDefaults.standard.set(true, forKey: "isAdRemoved");
                RemoveAds_btn.isEnabled = false
                Restore_btn.isEnabled = false
                queue.finishTransaction(transaction)
                let alert = UIAlertController(title: "Success", message: "Ads are removed!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
            case .purchasing:
                break
            case .deferred:
                break
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status()->String {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}


