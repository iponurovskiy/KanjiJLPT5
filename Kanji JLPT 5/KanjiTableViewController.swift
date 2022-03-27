//
//  KanjiTableViewController.swift
//  Kanji Book 5
//
//  Created by Ivan on 10/08/2018.
//

import UIKit

var kanjiList = [Kanji]();

class KanjiTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!

    var filteredKanjiList = [Kanji]()
    
    enum sections: Int {
        case  Numbers_and_time = 0,
            Nature_elements,
            Directions_and_locations,
            Humans,
            Adjectives,
            Actions
    }
    
    
    struct KanjiListJSON: Codable {
        var list: [KanjiJSON]
    }

    struct KanjiJSON: Codable {
        var image: String
        var section: Int
        var index: Int
        var isLearned: Bool
        var meaning: String
        var onyomi: [String]
        var kunyomi: [String]
    }
    
    
    func loadJSON() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileURL = documentsDirectory.appendingPathComponent("kanji.json")
            
            do {
                if (!FileManager.default.fileExists(atPath: fileURL.path)) {
                    let bundlePath = Bundle.main.url(forResource: "kanji", withExtension: "json")
                    try FileManager.default.copyItem(at: bundlePath!, to: fileURL)
                }
                
                let jsonData = try Data(contentsOf: fileURL)
            
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(KanjiListJSON.self, from: jsonData)
            
                for i in 0..<(decodedData.list.count) {
                kanjiList.append(Kanji(image: decodedData.list[i].image,
                                       section: decodedData.list[i].section,
                                       index: decodedData.list[i].index,
                                       isLearned: decodedData.list[i].isLearned,
                                       meaning: decodedData.list[i].meaning,
                                       onyomi: decodedData.list[i].onyomi,
                                       kunyomi: decodedData.list[i].kunyomi))
                
                }
            
            } catch {
                print("error:\(error)")
            }
        }
        
    }
    
    func saveJSON() {
        //let path = Bundle.main.url(forResource: "kanji", withExtension: "json");
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileURL = documentsDirectory.appendingPathComponent("kanji.json")
            do {
            
                let encoder = JSONEncoder()
            
                var encodedData = KanjiListJSON(list:[])
            
                for i in 0..<(kanjiList.count) {
                encodedData.list.append(KanjiJSON(image: kanjiList[i].image,
                                                  section: kanjiList[i].section,
                                                  index: kanjiList[i].index,
                                                  isLearned: kanjiList[i].isLearned,
                                                  meaning: kanjiList[i].meaning,
                                                  onyomi: kanjiList[i].onyomi,
                                                  kunyomi: kanjiList[i].kunyomi))
                
                }
            
                let JSONdata = try encoder.encode(encodedData)
                try JSONdata.write(to: fileURL)

            } catch {
                print("error:\(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.tableView.backgroundView = backgroundImage
        
        self.searchBar.showsScopeBar = true
        self.searchBar.scopeButtonTitles = ["All", "Learned", "Not learned"]
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        
        self.searchBar.placeholder = "Search"
        
        loadJSON()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String
    {
        switch section {
            case sections.Numbers_and_time.rawValue: return "Numbers and time"
            case sections.Nature_elements.rawValue: return "Nature elements"
            case sections.Directions_and_locations.rawValue: return "Directions and locations"
            case sections.Humans.rawValue: return "Humans"
            case sections.Adjectives.rawValue: return "Adjectives"
            case sections.Actions.rawValue: return "Actions"
            default: return ""
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var counts: [Int:Int] = [:]
        if (self.isFiltering()) {
            filteredKanjiList.forEach {counts[$0.section, default:0] += 1}
        } else {
            kanjiList.forEach {counts[$0.section, default:0] += 1}
        }
        switch section {
        case sections.Numbers_and_time.rawValue: return counts[sections.Numbers_and_time.rawValue] ?? 0
            case sections.Nature_elements.rawValue: return counts[sections.Nature_elements.rawValue] ?? 0
            case sections.Directions_and_locations.rawValue: return counts[sections.Directions_and_locations.rawValue] ?? 0
            case sections.Humans.rawValue: return counts[sections.Humans.rawValue] ?? 0
            case sections.Adjectives.rawValue: return counts[sections.Adjectives.rawValue] ?? 0
            case sections.Actions.rawValue: return counts[sections.Actions.rawValue] ?? 0
        default: return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "KanjiTableViewCell", for: indexPath) as! KanjiTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        var i = 0
        var offset = 0
        
        while (i < indexPath.section) {
            offset += self.tableView.numberOfRows(inSection: i)
            i = i + 1
        }
        
        let row = indexPath.row + offset
        var count = 0
        var kanji: Kanji
        
        if (self.isFiltering()) {
            count = filteredKanjiList.count
            kanji = filteredKanjiList[row]
        } else {
            count = kanjiList.count
            kanji = kanjiList[row]
        }
        
        if (row < count) {
            cell.kanjiMeaning.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
            cell.kanjiMeaning.text = kanji.meaning
        
            cell.kanjiImage.text = kanji.image
            cell.kanjiImage.font = UIFont(name: cell.kanjiImage.font.fontName, size: cell.kanjiImage.frame.width - 10)
            cell.kanjiImage.layer.borderWidth = 2
            cell.kanjiImage.layer.cornerRadius = 8.0
            cell.kanjiImage.layer.borderColor = UIColor.black.cgColor
        
            var onyomiText: String = ""
            var kunyomiText: String = ""
            
            var i: Int = 0
            
            repeat {
                onyomiText = onyomiText + kanji.onyomi[i]
                if (i < kanji.onyomi.count - 1) {
                    onyomiText = onyomiText + ", "
                }
                i = i+1
            } while i < kanji.onyomi.count
            
            
            cell.kanjiOnyomi.text = onyomiText
            
            i = 0
            
            repeat {
                kunyomiText = kunyomiText + kanji.kunyomi[i]
                if (i < kanji.kunyomi.count - 1) {
                    kunyomiText = kunyomiText + ", "
                }
                i = i+1
            } while i < kanji.kunyomi.count
            
            cell.kanjiKunyomi.text = kunyomiText
            
            if (kanji.isLearned) {
                cell.backgroundColor = UIColor.init(red: 144.0/255.0, green: 238.0/255.0, blue: 144.0/255.0, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor.white
            }
        
            
        } else {
            cell.kanjiImage.text = ""
            cell.kanjiMeaning.text = ""
            cell.kanjiOnyomi.text = ""
            cell.kanjiKunyomi.text = ""
            
            
        }

        return cell
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.hidesBottomBarWhenPushed = true;
        if segue.identifier == "ShowKanjiDetail" {
            let detailViewController = segue.destination as! KanjiDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            
            var i = 0
            var offset = 0
            
            while (i < myIndexPath.section) {
                offset += self.tableView.numberOfRows(inSection: i)
                i = i + 1
            }
            
            let row = myIndexPath.row + offset
            var count = 0
            var current_kanji: Kanji
            
            if (self.isFiltering()) {
                count = filteredKanjiList.count
                current_kanji = filteredKanjiList[row]
            } else {
                count = kanjiList.count
                current_kanji = kanjiList[row]
            }
            
            if (row < count) {
                let kanji = Kanji(image: current_kanji.image,
                              section: current_kanji.section,
                              index: current_kanji.index,
                              isLearned: current_kanji.isLearned,
                              meaning: current_kanji.meaning,
                              onyomi: current_kanji.onyomi,
                              kunyomi: current_kanji.kunyomi)
            
                detailViewController.kanjiDetail = kanji
            }
            
        }
    }
    

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return self.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = self.searchBar.selectedScopeButtonIndex != 0
        return  !searchBarIsEmpty() || searchBarScopeIsFiltering
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredKanjiList = kanjiList.filter({( item : Kanji) -> Bool in
            
            var scope_bool = false
            if (scope == "Learned") {scope_bool = true}
            if (scope == "Unlearned") {scope_bool = false}
            
            let doesCategoryMatch = (scope == "All") || (item.isLearned == scope_bool)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && item.meaning.lowercased().contains(searchText.lowercased())
            }
        })
        
        tableView.reloadData()
    }
    
    
    // Scopes:
    // 0 - Unlearned
    // 1 - Learned
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = self.searchBar.text
        filterContentForSearchText(searchText!, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText, scope: scope)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var i = 0
        var offset = 0
        
        while (i < indexPath.section) {
            offset += self.tableView.numberOfRows(inSection: i)
            i = i + 1
        }
        
        let row = indexPath.row + offset
        var current_kanji: Kanji
        
        if (self.isFiltering()) {
            current_kanji = filteredKanjiList[row]
        } else {
            current_kanji = kanjiList[row]
        }
        
        if (!current_kanji.isLearned) {
            let changeAction = UIContextualAction(style: .normal, title:  "Check as learned", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("Check as learned ...")
                current_kanji.isLearned = true
                self.saveJSON()
                let scope = self.searchBar.scopeButtonTitles![self.searchBar.selectedScopeButtonIndex]
                let searchText = self.searchBar.text
                self.filterContentForSearchText(searchText!, scope: scope)
                success(true)
            })
            
            changeAction.backgroundColor = UIColor.init(red: 144.0/255.0, green: 238.0/255.0, blue: 144.0/255.0, alpha: 1.0)
            return UISwipeActionsConfiguration(actions: [changeAction])
        } else {
            let changeAction = UIContextualAction(style: .normal, title:  "Check as not learned", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("Check as not learned ...")
                current_kanji.isLearned = false
                self.saveJSON()
                let scope = self.searchBar.scopeButtonTitles![self.searchBar.selectedScopeButtonIndex]
                let searchText = self.searchBar.text
                self.filterContentForSearchText(searchText!, scope: scope)
                success(true)
            })
            
            changeAction.backgroundColor = UIColor.red
            return UISwipeActionsConfiguration(actions: [changeAction])
        }
        
        
    }
    



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
