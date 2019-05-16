//
//  BlueDeviceListCell.swift
//  Sprayer
//
//  Created by fanglin on 2019/4/11.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class BlueDeviceListCell: UITableViewCell {

    var blueModel:Model = Model() {
        didSet{
            nameL.text = blueModel.peripheral.name
            if blueModel.isLinking {
                isLinkingImg.isHidden = false
            }else {
                isLinkingImg.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var isLinkingImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp() {
        nameL.font = UIFont.systemFont(ofSize: CGFloat(16*IPONE_SCALE))
        nameL.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(16*IPONE_SCALE)
        }
        
        isLinkingImg.isHidden = true
        isLinkingImg.snp.makeConstraints { (make) in
            make.right.equalTo(-20*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22.5*IPONE_SCALE)
        }
        
        let lineV = UIView.init()
        lineV.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        self.contentView.addSubview(lineV)
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
