//
//  KanjiDetailViewController.swift
//  Kanji Book 5
//
//  Created by Ivan on 13/08/2018.
//

import UIKit

extension UIViewController {
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
             (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

class KanjiDetailViewController: UIViewController {

    var kanjiDetail: Kanji?
    
    
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
                
        if let kanji = kanjiDetail {
            
            print("width ", self.view.frame.width, "height ", self.view.frame.height)
            var itemHeight = heightForLabel(text: kanji.meaning,
                                            font: UIFont.preferredFont(forTextStyle: .title1),
                                            width: self.view.frame.width-60)
            let headerHeight = self.topbarHeight
            let spacing = (5*self.view.frame.height/12 - headerHeight - itemHeight)/4
            var yCoord = headerHeight + spacing
            
            
            //////////  1. Creating meaningKanjiDetail ////////////////
            let meaningKanjiDetail = UILabel()
            meaningKanjiDetail.text = kanji.meaning
            meaningKanjiDetail.font = UIFont.systemFont(ofSize: self.view.frame.height/25)
            meaningKanjiDetail.textAlignment = .center
            meaningKanjiDetail.numberOfLines = 0
            meaningKanjiDetail.frame = CGRect(x: 30,
                                              y: yCoord,
                                              width: self.view.frame.width-60,
                                              height: itemHeight)
            meaningKanjiDetail.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(meaningKanjiDetail)
            NSLayoutConstraint(item: meaningKanjiDetail,
                               attribute: NSLayoutAttribute.leading,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: self.view,
                               attribute: NSLayoutAttribute.leading,
                               multiplier: 1,
                               constant: 30).isActive = true
            NSLayoutConstraint(item: meaningKanjiDetail,
                               attribute: NSLayoutAttribute.centerX,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: self.view,
                               attribute: NSLayoutAttribute.centerX,
                               multiplier: 1,
                               constant: 0).isActive = true
            NSLayoutConstraint(item: meaningKanjiDetail,
                               attribute: NSLayoutAttribute.top,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: self.view,
                               attribute: NSLayoutAttribute.top,
                               multiplier: 1,
                               constant: yCoord).isActive = true;
            meaningKanjiDetail.adjustsFontSizeToFitWidth = true;
            meaningKanjiDetail.minimumScaleFactor = 0.5;
            yCoord = yCoord + itemHeight + spacing
            //////////////////////////////////////////////////////////////
      
            //////////  2. Creating imageKanjiDetail ////////////////
            let imageKanjiDetail = UILabel()
            imageKanjiDetail.text = kanji.image
            imageKanjiDetail.textAlignment = .center
            imageKanjiDetail.font =  UIFont(name: imageKanjiDetail.font.fontName, size: self.view.frame.height/4 - 10)
            imageKanjiDetail.frame = CGRect(x: self.view.frame.midX - self.view.frame.width/8,
                                            y:yCoord,
                                            width:self.view.frame.height/4,
                                            height:self.view.frame.height/4)
            imageKanjiDetail.layer.borderWidth = 5
            imageKanjiDetail.layer.borderColor = UIColor.black.cgColor
            imageKanjiDetail.layer.cornerRadius = 8.0
            imageKanjiDetail.clipsToBounds = true
            imageKanjiDetail.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(imageKanjiDetail)
            NSLayoutConstraint(item: imageKanjiDetail,
                               attribute: NSLayoutAttribute.centerX,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: self.view,
                               attribute: NSLayoutAttribute.centerX,
                               multiplier: 1,
                               constant: 0).isActive = true
            NSLayoutConstraint(item: imageKanjiDetail,
                               attribute: NSLayoutAttribute.top,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: self.view,
                               attribute: NSLayoutAttribute.top,
                               multiplier: 1,
                               constant: yCoord).isActive = true
            NSLayoutConstraint(item: imageKanjiDetail,
                               attribute: NSLayoutAttribute.height,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: nil,
                               attribute: NSLayoutAttribute.notAnAttribute,
                               multiplier: 1,
                               constant: self.view.frame.height/4).isActive = true
            NSLayoutConstraint(item: imageKanjiDetail,
                               attribute: NSLayoutAttribute.width,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: nil,
                               attribute: NSLayoutAttribute.notAnAttribute,
                               multiplier: 1,
                               constant: self.view.frame.height/4).isActive = true
            yCoord = yCoord + spacing + imageKanjiDetail.frame.height
            
            /////////////////////////////////////////////////
            
            //////////  3. Creating onyomiView ////////////////
            let onyomiView = UIView()
            onyomiView.frame = CGRect(x: self.view.frame.width/4,
                                      y: yCoord,
                                      width: self.view.frame.width/4,
                                      height: self.view.frame.height/3)
            
            onyomiView.layer.borderWidth = 1
            onyomiView.layer.borderColor = UIColor.black.cgColor
            self.view.addSubview(onyomiView)
            /////////////////////////////////////////////////
            
            //////////  4. Creating kunyomiView ////////////////
            let kunyomiView = UIView()
            kunyomiView.frame = CGRect(x: self.view.frame.width/2,
                                      y: yCoord,
                                      width: self.view.frame.width/4,
                                      height: self.view.frame.height/3)
            
            kunyomiView.layer.borderWidth = 1
            kunyomiView.layer.borderColor = UIColor.black.cgColor
            self.view.addSubview(kunyomiView)
            /////////////////////////////////////////////////
            
            //////////  5. Creating horizontal line ////////////////
            let horizontal = UILabel()
            horizontal.frame = CGRect(x: self.view.frame.width/4,
                                      y: yCoord + self.view.frame.height/15,
                                      width: self.view.frame.width/2 ,
                                      height: 1)
            horizontal.backgroundColor = .black
            horizontal.text = ""
            self.view.addSubview(horizontal)
            /////////////////////////////////////////////////
            
            //////////  6. Creating onyomiLabel ////////////////
            let onLabel = UILabel()
            onLabel.font = UIFont.boldSystemFont(ofSize: self.view.frame.height/45)
            itemHeight = heightForLabel(text: "Onyomi", font: onLabel.font, width: 0.25*self.view.frame.width - 20)
            yCoord = (self.view.frame.height/15 - itemHeight)/2
            onLabel.frame = CGRect(x: onyomiView.bounds.minX + 10,
                                   y: yCoord,
                                   width: 0.25*self.view.frame.width - 20,
                                   height: itemHeight)
            onLabel.text = "Onyomi"
            onLabel.textAlignment = .center
            print("view: \(onyomiView.frame.width), label: \(onLabel.frame.width)")
            onyomiView.addSubview(onLabel)
            onLabel.center.x = onyomiView.frame.width/2
            /////////////////////////////////////////////////
            
            //////////  7. Creating kunyomiLabel ////////////////
            let kunLabel = UILabel()
            kunLabel.font = UIFont.boldSystemFont(ofSize: self.view.frame.height/45)
            itemHeight = heightForLabel(text: "Kunyomi", font: kunLabel.font, width: 0.25*self.view.frame.width - 20)
            kunLabel.frame = CGRect(x: kunyomiView.bounds.midX - 30,
                                    y: yCoord,
                                    width: 0.25*self.view.frame.width - 20,
                                    height: itemHeight)
            kunLabel.text = "Kunyomi"
            kunLabel.textAlignment = .center
            kunyomiView.addSubview(kunLabel)
            kunLabel.center.x = kunyomiView.frame.width/2
            
            /////////////////////////////////////////////////
            
            var onyomiText: String = ""
            var kunyomiText: String = ""
            
            var i: Int = 0
            

            //////////  8. Creating onyomiText ////////////////
            repeat {
                onyomiText = onyomiText + kanji.onyomi[i]
                if (i < kanji.onyomi.count - 1) {
                    onyomiText = onyomiText + "\n"
                }
                i = i+1
            } while i < kanji.onyomi.count
            
            yCoord = 0.2*onyomiView.frame.height + 10
            
            let onText = UILabel()
            onText.font = UIFont.systemFont(ofSize: self.view.frame.height/40)
            onText.text = onyomiText
            onText.textAlignment = .center
            onText.numberOfLines = kanji.onyomi.count
            itemHeight = heightForLabel(text: onyomiText, font: onText.font, width: onyomiView.frame.width-10)
            onText.frame = CGRect(x: onyomiView.bounds.midX,
                                  y: yCoord,
                                  width: onyomiView.frame.width-10,
                                  height: itemHeight)
            
            onText.translatesAutoresizingMaskIntoConstraints = false
            onyomiView.addSubview(onText)
            NSLayoutConstraint(item: onText,
                               attribute: NSLayoutAttribute.height,
                               relatedBy: NSLayoutRelation.lessThanOrEqual,
                               toItem: nil,
                               attribute: NSLayoutAttribute.notAnAttribute,
                               multiplier: 1,
                               constant: 0.8*onyomiView.frame.height-20).isActive = true
            NSLayoutConstraint(item: onText,
                               attribute: NSLayoutAttribute.width,
                               relatedBy: NSLayoutRelation.lessThanOrEqual,
                               toItem: nil,
                               attribute: NSLayoutAttribute.notAnAttribute,
                               multiplier: 1,
                               constant: onyomiView.frame.width-10).isActive = true
            NSLayoutConstraint(item: onText,
                               attribute: NSLayoutAttribute.top,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: onyomiView,
                               attribute: NSLayoutAttribute.top,
                               multiplier: 1,
                               constant: yCoord).isActive = true
            NSLayoutConstraint(item: onText,
                               attribute: NSLayoutAttribute.centerX,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: onyomiView,
                               attribute: NSLayoutAttribute.centerX,
                               multiplier: 1,
                               constant: 0).isActive = true
            onText.adjustsFontSizeToFitWidth = true
            onText.minimumScaleFactor = 0.5
            

            /////////////////////////////////////////////////
            
            //////////  9. Creating kunyomiText ////////////////
            
            i = 0
            
            repeat {
                kunyomiText = kunyomiText + kanji.kunyomi[i];
                if (i < kanji.kunyomi.count - 1) {
                    kunyomiText = kunyomiText + "\n"
                }
                i = i+1
            } while i < kanji.kunyomi.count

            let kunText = UILabel()
            kunText.font = UIFont.systemFont(ofSize: self.view.frame.height/40)
            kunText.text = kunyomiText
            kunText.textAlignment = .center
            kunText.numberOfLines = kanji.kunyomi.count
            itemHeight = heightForLabel(text: kunyomiText, font: kunText.font, width: onyomiView.frame.width-10)
            kunText.frame = CGRect(x: kunyomiView.bounds.midX,
                                   y: yCoord,
                                   width: onyomiView.frame.width-10,
                                   height: itemHeight)
            
            kunText.translatesAutoresizingMaskIntoConstraints = false
            kunyomiView.addSubview(kunText)
            NSLayoutConstraint(item: kunText,
                               attribute: NSLayoutAttribute.height,
                               relatedBy: NSLayoutRelation.lessThanOrEqual,
                               toItem: nil,
                               attribute: NSLayoutAttribute.notAnAttribute,
                               multiplier: 1,
                               constant: 0.8*kunyomiView.frame.height-20).isActive = true
            NSLayoutConstraint(item: kunText,
                               attribute: NSLayoutAttribute.width,
                               relatedBy: NSLayoutRelation.lessThanOrEqual,
                               toItem: nil,
                               attribute: NSLayoutAttribute.notAnAttribute,
                               multiplier: 1,
                               constant: kunyomiView.frame.width-10).isActive = true
            NSLayoutConstraint(item: kunText,
                               attribute: NSLayoutAttribute.top,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: kunyomiView,
                               attribute: NSLayoutAttribute.top,
                               multiplier: 1,
                               constant: yCoord).isActive = true
            NSLayoutConstraint(item: kunText,
                               attribute: NSLayoutAttribute.centerX,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: kunyomiView,
                               attribute: NSLayoutAttribute.centerX,
                               multiplier: 1,
                               constant: 0).isActive = true
            kunText.adjustsFontSizeToFitWidth = true
            kunText.minimumScaleFactor = 0.5

            /////////////////////////////////////////////////


        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 /*   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        if (tableView == self.onyomiTableView) {
            count = kanjiDetail?.onyomi.count;
        }
        
        if (tableView == self.kunyomiTableView) {
            count = kanjiDetail?.kunyomi.count;
        }
        
        return count!;
    }*/
    
   /* func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellToReturn = UITableViewCell();
        
        if (tableView == self.kunyomiTableView) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "kunyomiTableCell", for: indexPath) as! yomiCell;
            
            //cell.yomiLabel!.text = kanjiDetail?.kunyomi[indexPath.row];
            cellToReturn = cell;
        } else if (tableView == self.onyomiTableView){
        
            let cell = self.onyomiTableView.dequeueReusableCell(withIdentifier: "onyomiTableCell", for: indexPath) as! yomiCell;
            
            //cell.yomiLabel!.text = kanjiDetail?.onyomi[indexPath.row];
            cellToReturn = cell;
        }
        
        return cellToReturn;
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
