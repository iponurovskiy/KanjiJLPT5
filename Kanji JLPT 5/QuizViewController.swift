//
//  QuizViewController.swift
//  Kanji Book 5
//
//  Created by Ivan on 18/10/2018.
//

import UIKit
import AVFoundation


class QuizViewController: UIViewController {

    let ANSWER_TAG  = 1
    var mode: Int?
    
    var headerLabel: UILabel?
    var labelAnswer1: UILabel?
    var labelAnswer2: UILabel?
    var labelAnswer3: UILabel?
    var labelAnswer4: UILabel?
    
    var labelQuestion: UILabel?
    
    var backButton: UIButton?
    
    var labelOrigin:CGPoint?
    var correctAnswer: Kanji?
    
    var resultImageView:UIImageView?
    
    var audioPlayer:AVAudioPlayer?
    
    var correctCountLabel:UILabel?
    var wrongCountLabel: UILabel?
    var correctCount: Int = 0
    var wrongCount: Int = 0
    let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath:"transform.scale")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.title = "Kanji Quiz"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

        
        if let currentMode = mode {
            
            var yCoord = (self.navigationController?.navigationBar.frame.height)! +  0.15*self.view.frame.height
            var gap = 0.075*self.view.frame.height
            var xCoord = (self.view.frame.width - 0.3*self.view.frame.height)/3
            
            let lWidth = 0.15*self.view.frame.height
            let lHeight = 0.15*self.view.frame.height
            
            
            pulseAnimation.duration = 0.5
            pulseAnimation.toValue = 1.2
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = Float.infinity
            
            headerLabel = UILabel()
            self.view.addSubview(headerLabel!)
            setLabel(label:headerLabel, xOrigin: 20,
                     yOrigin: (self.navigationController?.navigationBar.frame.height)! + 0.075*self.view.frame.height,
                     lWidth: self.view.frame.width - 40,
                     lHeight: 0.05*self.view.frame.height)
            headerLabel?.text = "Drag the center item and drop it on the correct answer"
            headerLabel?.layer.borderWidth = 0.0
            headerLabel?.font =  UIFont(name: (headerLabel?.font.fontName)!, size: (headerLabel?.frame.height)! - 10)
            
            labelAnswer1 = UIPaddedLabel(withInsets: 3.0, 3.0, 3.0, 3.0)
            self.view.addSubview(labelAnswer1!)
            setLabel(label: labelAnswer1, xOrigin: xCoord, yOrigin: yCoord, lWidth: lWidth, lHeight: lHeight)
            labelAnswer1?.tag = ANSWER_TAG
            
            labelAnswer2 = UIPaddedLabel(withInsets: 3.0, 3.0, 3.0, 3.0)
            self.view.addSubview(labelAnswer2!)
            setLabel(label: labelAnswer2, xOrigin: 2*xCoord+0.15*self.view.frame.height, yOrigin: yCoord, lWidth: lWidth, lHeight: lHeight)
             labelAnswer2?.tag = ANSWER_TAG
            
            yCoord += gap+0.15*self.view.frame.height
            
            labelQuestion = UIPaddedLabel(withInsets: 3.0, 3.0, 3.0, 3.0)
            self.view.addSubview(labelQuestion!)
            setLabel(label: labelQuestion, xOrigin: 0.5*self.view.frame.width - 0.075*self.view.frame.height,
                     yOrigin: yCoord, lWidth: lWidth, lHeight: lHeight)
            
            labelOrigin = labelQuestion?.frame.origin
            
            resultImageView = UIImageView()
            self.view.addSubview(resultImageView!)
            setImageView(imageView: &resultImageView, xOrigin: 0.5*self.view.frame.width - 0.075*self.view.frame.height, yOrigin: yCoord)
            resultImageView?.isHidden = true
            
            
     
            labelQuestion?.isUserInteractionEnabled = true
            let pan = UIPanGestureRecognizer(target: self, action: #selector(QuizViewController.handlePan(sender:)))
            labelQuestion?.addGestureRecognizer(pan)
            
            yCoord += gap+0.15*self.view.frame.height
            
            labelAnswer3 = UIPaddedLabel(withInsets: 3.0, 3.0, 3.0, 3.0)
            self.view.addSubview(labelAnswer3!)
            setLabel(label: labelAnswer3, xOrigin: xCoord, yOrigin: yCoord, lWidth: lWidth, lHeight: lHeight)
             labelAnswer3?.tag = ANSWER_TAG
            
            labelAnswer4 = UIPaddedLabel(withInsets: 3.0, 3.0, 3.0, 3.0)
            self.view.addSubview(labelAnswer4!)
            setLabel(label: labelAnswer4, xOrigin: 2*xCoord+0.15*self.view.frame.height, yOrigin: yCoord, lWidth: lWidth, lHeight: lHeight)
             labelAnswer4?.tag = ANSWER_TAG
            
            yCoord += gap + 0.15*self.view.frame.height
            
            correctCountLabel = UILabel()
            self.view.addSubview(correctCountLabel!)
            setLabel(label:correctCountLabel, xOrigin: 20,
                     yOrigin: yCoord,
                     lWidth: 0.5*self.view.frame.width - 40,
                     lHeight: 0.05*self.view.frame.height)
            correctCountLabel?.layer.borderWidth = 0.0
            correctCountLabel?.font =  UIFont(name: (correctCountLabel?.font.fontName)!, size: (correctCountLabel?.frame.height)! - 10)
            correctCountLabel?.text = "Correct: \(correctCount)"
            
            wrongCountLabel = UILabel()
            self.view.addSubview(wrongCountLabel!)
            setLabel(label:wrongCountLabel, xOrigin: 0.5*self.view.frame.width + 20,
                     yOrigin: yCoord,
                     lWidth: 0.5*self.view.frame.width - 40,
                     lHeight: 0.05*self.view.frame.height)
            wrongCountLabel?.layer.borderWidth = 0.0
            wrongCountLabel?.font =  UIFont(name: (wrongCountLabel?.font.fontName)!, size: (wrongCountLabel?.frame.height)! - 10)
            wrongCountLabel?.text = "Wrong: \(wrongCount)"
            
            
            
            if (currentMode == 1) {
                labelAnswer1?.font = UIFont(name: (labelAnswer1?.font.fontName)!, size: (labelAnswer1?.frame.height)! / 5)
                labelAnswer2?.font = labelAnswer1?.font
                labelAnswer3?.font = labelAnswer1?.font
                labelAnswer4?.font = labelAnswer1?.font
                
                labelQuestion?.font =  UIFont(name: (labelQuestion?.font.fontName)!, size: (labelQuestion?.frame.height)! - 10)
            } else {
                labelAnswer1?.font = UIFont(name: (labelQuestion?.font.fontName)!, size: (labelAnswer1?.frame.height)! - 10)
                labelAnswer2?.font = labelAnswer1?.font
                labelAnswer3?.font = labelAnswer1?.font
                labelAnswer4?.font = labelAnswer1?.font
                
                labelQuestion?.font =  UIFont(name: (labelAnswer1?.font.fontName)!, size: (labelQuestion?.frame.height)! / 5)
            }
            
            newQuestion()
          
        }

        // Do any additional setup after loading the view.
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let panView = sender.view!
        let translation = sender.translation(in: view)
        var mp3Sound: String
        
        switch sender.state {
        case .began:
            labelAnswer1?.layer.add(pulseAnimation, forKey: "pulsation")
            labelAnswer2?.layer.add(pulseAnimation, forKey: "pulsation")
            labelAnswer3?.layer.add(pulseAnimation, forKey: "pulsation")
            labelAnswer4?.layer.add(pulseAnimation, forKey: "pulsation")
        case .changed:
            panView.center = CGPoint(x:panView.center.x + translation.x,
                                     y:panView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        case .ended:
            labelAnswer1?.layer.removeAnimation(forKey: "pulsation")
            labelAnswer2?.layer.removeAnimation(forKey: "pulsation")
            labelAnswer3?.layer.removeAnimation(forKey: "pulsation")
            labelAnswer4?.layer.removeAnimation(forKey: "pulsation")
            
            let intersectingView = checkViewIsIntersecting(viewToCheck: panView)
            
                if ((intersectingView) != nil) {
                    let intersectingLabel = intersectingView as! UILabel
                    if((intersectingLabel.text == correctAnswer?.image) ||
                        (intersectingLabel.text == correctAnswer?.meaning)) {
                            resultImageView?.image = #imageLiteral(resourceName: "correct_icon")
                            mp3Sound = "correct_sound"
                            correctCount += 1
                            correctCountLabel?.text = "Correct: \(correctCount)"

                    } else {
                            resultImageView?.image = #imageLiteral(resourceName: "wrong_icon")
                            mp3Sound = "wrong_sound"
                            wrongCount += 1
                            wrongCountLabel?.text = "Wrong: \(wrongCount)"
                    }
                    resultImageView?.isHidden = false
                    labelQuestion?.isHidden = true

                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.playSound(name: mp3Sound)
                        self.resultImageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
                    }, completion: {(finished: Bool) in
                        self.resultImageView?.layer.transform = CATransform3DIdentity;
                        self.resultImageView?.isHidden = true
                        self.labelQuestion?.isHidden = false
                        self.newQuestion()})

            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    panView.frame.origin = self.labelOrigin!
                })
            }
            break;
        default:
            break;
        }
    }
    
    func setImageView(imageView: inout UIImageView?, xOrigin: CGFloat, yOrigin: CGFloat) {
        imageView?.frame = CGRect(x: xOrigin,
                               y: yOrigin,
                               width: 0.15*self.view.frame.height,
                               height: 0.15*self.view.frame.height)
        
        
       
        imageView?.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: imageView!,
                           attribute: NSLayoutAttribute.leading,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: self.view,
                           attribute: NSLayoutAttribute.leading,
                           multiplier: 1,
                           constant: xOrigin).isActive = true
        NSLayoutConstraint(item: imageView!,
                           attribute: NSLayoutAttribute.top,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: self.view,
                           attribute: NSLayoutAttribute.top,
                           multiplier: 1,
                           constant: yOrigin).isActive = true
        NSLayoutConstraint(item: imageView!,
                           attribute: NSLayoutAttribute.width,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: nil,
                           attribute: NSLayoutAttribute.notAnAttribute,
                           multiplier: 1,
                           constant: 0.15*self.view.frame.height).isActive = true
        NSLayoutConstraint(item: imageView!,
                           attribute: NSLayoutAttribute.height,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: nil,
                           attribute: NSLayoutAttribute.notAnAttribute,
                           multiplier: 1,
                           constant: 0.15*self.view.frame.height).isActive = true

    }
    
    func setLabel( label: UILabel?, xOrigin: CGFloat, yOrigin: CGFloat, lWidth: CGFloat, lHeight: CGFloat) {
 
        label?.frame = CGRect(x: xOrigin,
                             y: yOrigin,
                             width: lWidth,
                             height: lHeight)
        
        
        label?.translatesAutoresizingMaskIntoConstraints = false
        label?.layer.borderWidth = 2
        label?.layer.borderColor = UIColor.black.cgColor
        label?.layer.cornerRadius = 8.0
        label?.textAlignment = .center
        label?.numberOfLines = 0
        
        NSLayoutConstraint(item: label!,
                           attribute: NSLayoutAttribute.leading,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: self.view,
                           attribute: NSLayoutAttribute.leading,
                           multiplier: 1,
                           constant: xOrigin).isActive = true
        NSLayoutConstraint(item: label!,
                           attribute: NSLayoutAttribute.top,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: self.view,
                           attribute: NSLayoutAttribute.top,
                           multiplier: 1,
                           constant: yOrigin).isActive = true
        NSLayoutConstraint(item: label!,
                           attribute: NSLayoutAttribute.width,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: nil,
                           attribute: NSLayoutAttribute.notAnAttribute,
                           multiplier: 1,
                           constant: lWidth).isActive = true
        NSLayoutConstraint(item: label!,
                           attribute: NSLayoutAttribute.height,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: nil,
                           attribute: NSLayoutAttribute.notAnAttribute,
                           multiplier: 1,
                           constant: lHeight).isActive = true
        label?.adjustsFontSizeToFitWidth = true
        label?.minimumScaleFactor = 0.5
        
    }
    
    
    func playSound(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3")
            else {return}
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = audioPlayer else {return}
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: UInt32) -> [Int] {
        
        var uniqueNumbers = [Int]()
        
        while uniqueNumbers.count < numberOfRandoms {
            
            let randomNumber = Int(arc4random_uniform(maxNum + 1)) + minNum
            var found = false
            
            
            for i in 0..<uniqueNumbers.count {
                if uniqueNumbers[i] == randomNumber {
                    found = true;
                    break;
                }
            }
            
            if found == false {
                uniqueNumbers.append(randomNumber)
            }
            
        }
        
        return uniqueNumbers
    }
    
    func newQuestion() {
        if let currentMode = mode {
            var options = [Int]()
            options = uniqueRandoms(numberOfRandoms: 4,
                                    minNum: 0,
                                    maxNum: UInt32(kanjiList.count)-1)
            
            let rightAnswer = Int(arc4random_uniform(4))
              self.correctAnswer = kanjiList[options[rightAnswer]]
            
            if (currentMode == 1) { // Kanji -> Meaning
                
                labelQuestion?.text = kanjiList[options[rightAnswer]].image

                
                labelAnswer1?.text = kanjiList[options[0]].meaning
                labelAnswer2?.text = kanjiList[options[1]].meaning
                labelAnswer3?.text = kanjiList[options[2]].meaning
                labelAnswer4?.text = kanjiList[options[3]].meaning
                
            } else { // Meaning -> Kanji
                labelQuestion?.text = kanjiList[options[rightAnswer]].meaning
                
                labelAnswer1?.text = kanjiList[options[0]].image
                labelAnswer2?.text = kanjiList[options[1]].image
                labelAnswer3?.text = kanjiList[options[2]].image
                labelAnswer4?.text = kanjiList[options[3]].image
            }
            
        }
    }
    
    func checkViewIsIntersecting (viewToCheck: UIView) -> UIView? {
        let allSubViews = self.view.subviews
        for subview in allSubViews {
            if ((!viewToCheck .isEqual(subview)) && (subview.tag == ANSWER_TAG)) {
                if (viewToCheck.frame .intersects(subview.frame)) {
                    return subview
                }
            }
        }
        return nil;
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
