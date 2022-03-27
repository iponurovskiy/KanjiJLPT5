//
//  SelectQuizViewController.swift
//  Kanji Book 5
//
//  Created by Ivan on 07/10/2018.
//

import UIKit
import GoogleMobileAds


class SelectQuizViewController: UIViewController, GADInterstitialDelegate {
    
    var interstitialAd: GADInterstitial!
    var isAdRemoved: Bool!
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var quizButton1: UIButton!
    @IBOutlet weak var quizButton2: UIButton!
    
    
    func reloadInterstitialAd() -> GADInterstitial{
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-XXXXXXXXXX")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitialAd = reloadInterstitialAd()
    }
    
    
    @IBAction func mode1Tapped(_ sender: Any) {
        
        if (self.interstitialAd.isReady && !isAdRemoved) {
            self.interstitialAd.present(fromRootViewController: self)
        }
        performSegue(withIdentifier: "startQuiz", sender: 1);
    }
    
    @IBAction func mode2Tapped(_ sender: Any) {
        if (self.interstitialAd.isReady && !isAdRemoved) {
            self.interstitialAd.present(fromRootViewController: self)
        }
        performSegue(withIdentifier: "startQuiz", sender: 2);
    }
    
    func heightForElement(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label = UILabel()
        label.frame = CGRect(x:0,
                             y:0,
                             width: width,
                             height: CGFloat.greatestFiniteMagnitude)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
       
        
        //if (!isAdRemoved) {
            self.interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-XXXXXXXXXXXXX")
            let request = GADRequest();
            self.interstitialAd.load(request)
            self.interstitialAd = reloadInterstitialAd()
        //}
        
        //////////// 1. Create button 1 /////////
        quizButton1.titleLabel?.font = UIFont(name: "Thonburi", size: self.view.frame.width/20)
        var itemHeight = heightForElement(text: "Kanji ⟶ Meaning", font: (quizButton1.titleLabel?.font)!, width: self.view.frame.width/2) + 10
        quizButton1.frame = CGRect(x: self.view.frame.width/4,
                                   y: self.view.frame.midY-itemHeight-30,
                                   width: self.view.frame.width/2,
                                   height: itemHeight)
        quizButton1.layer.borderWidth = 1
        quizButton1.layer.borderColor = UIColor.black.cgColor
        quizButton1.layer.cornerRadius = itemHeight/2
        quizButton1.titleLabel?.adjustsFontSizeToFitWidth = true
        quizButton1.titleLabel?.minimumScaleFactor = 0.5
        //print("midY: ", self.view.frame.midY, " height:", quizButton1.frame.height, "top:", quizButton1.frame.minY)
        /////////////////////////////////////////////////////////////////////////////////
        
        //////////// 2. Create button 2 /////////
        quizButton2.titleLabel?.font = UIFont(name: "Thonburi", size: self.view.frame.width/20)
        quizButton2.frame = CGRect(x: self.view.frame.width/4,
                                   y: self.view.frame.midY+20,
                                   width: self.view.frame.width/2,
                                   height: itemHeight)
        quizButton2.layer.borderWidth = 1
        quizButton2.layer.borderColor = UIColor.black.cgColor
        quizButton2.layer.cornerRadius = itemHeight/2
        quizButton2.titleLabel?.adjustsFontSizeToFitWidth = true
        quizButton2.titleLabel?.minimumScaleFactor = 0.5
        /////////////////////////////////////////////////////////////////////////////////
        
        //////3. Create label //////////
        selectLabel.font = UIFont.systemFont(ofSize: self.view.frame.width/15)
        selectLabel.textAlignment = .center
        selectLabel.numberOfLines = 0
        itemHeight = heightForElement(text: selectLabel.text!, font: (selectLabel.font)!, width: self.view.frame.width/2)
        selectLabel.frame = CGRect(x: 30,
                                   y: quizButton2.frame.minY/2,
                                   width: self.view.frame.width-60,
                                   height: itemHeight)
        selectLabel.adjustsFontSizeToFitWidth = true
        selectLabel.minimumScaleFactor = 0.5
        
        ////////////////////////////////////////////////
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        quizButton1.center.x -= view.bounds.width
        quizButton2.center.x += view.bounds.width
        isAdRemoved = UserDefaults.standard.object(forKey: "isAdRemoved") as? Bool ?? false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5, delay: 0.0,
                                usingSpringWithDamping: 0.3,
                                initialSpringVelocity: 0.5,
                                options: [], animations: {
                                self.quizButton1.center.x += self.view.bounds.width
                                self.quizButton2.center.x -= self.view.bounds.width
                               
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startQuiz" {
            let detailViewController = segue.destination as! QuizViewController
            detailViewController.mode = sender as? Int
        }
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
