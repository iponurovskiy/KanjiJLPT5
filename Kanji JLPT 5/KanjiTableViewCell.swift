//
//  KanjiTableViewCell.swift
//  Kanji Book 5
//
//  Created by Ivan on 10/08/2018.
//

import UIKit

class KanjiTableViewCell: UITableViewCell {

    
    @IBOutlet weak var kanjiImage: UILabel!
    @IBOutlet weak var kanjiMeaning: UILabel!
    @IBOutlet weak var kanjiOnyomi: UILabel!
    @IBOutlet weak var kanjiKunyomi: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
