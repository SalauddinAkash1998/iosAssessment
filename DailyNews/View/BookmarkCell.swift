//
//  BookmarkCell.swift
//  DailyNews
//
//  Created by BJIT on 18/1/23.
//

import UIKit

class BookmarkCell: UITableViewCell {

    @IBOutlet weak var bookmarkImgView: UIImageView!
    @IBOutlet weak var bookmarkLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
