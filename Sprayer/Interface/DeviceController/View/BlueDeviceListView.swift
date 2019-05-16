//
//  BlueDeviceListView.swift
//  Sprayer
//
//  Created by fanglin on 2019/4/11.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import SnapKit

class BlueDeviceListView: AniShowCloseView,UITableViewDelegate,UITableViewDataSource {

    @objc var dataList:[Model] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    lazy var tableView:UITableView = {
        let tbView = UITableView.init(frame: .zero, style: .plain)
        tbView.separatorStyle = .none
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib.init(nibName: "BlueDeviceListCell", bundle: nil), forCellReuseIdentifier: "BlueDeviceListCell")
        return tbView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(350*IPONE_SCALE))
        self.corner(byRoundingCorners: [.topLeft,.topRight], radii: 10, rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(350*IPONE_SCALE)))
        self.setInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInterface() {
        let titleL = UILabel.init()
        titleL.text = "Device List"
        titleL.font = UIFont.init(name: "PingFang-SC-Bold", size: CGFloat(18*IPONE_SCALE))
        titleL.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        titleL.textAlignment = .center
        self.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(10*IPONE_SCALE)
            make.left.right.equalToSuperview()
            make.height.equalTo(18*IPONE_SCALE)
        }
        
        let lineV = UIView.init()
        lineV.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        self.addSubview(lineV)
        lineV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleL.snp.bottom).offset(10*IPONE_SCALE)
            make.height.equalTo(1)
        }
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(lineV.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlueDeviceListCell", for: indexPath) as! BlueDeviceListCell
        cell.blueModel = dataList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50*IPONE_SCALE)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.animationClose()
        let model = dataList[indexPath.row]
        BlueToothManager.getInstance()?.connectPeripheral(with: model)
        BlueToothManager.getInstance()?.stopScan()  //停止扫描
    }
}
