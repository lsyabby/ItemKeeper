//
//  DetailViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailTableView: UITableView!
    var list: ItemList?
    override func viewDidLoad() {
        super.viewDidLoad()

        let upNib = UINib(nibName: "DetailUpTableViewCell", bundle: nil)
        detailTableView.register(upNib, forCellReuseIdentifier: "DetailUpTableCell")
        
        let downNib = UINib(nibName: "DetailDownTableViewCell", bundle: nil)
        detailTableView.register(downNib, forCellReuseIdentifier: "DetailDownTableCell")
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let upcell = tableView.dequeueReusableCell(withIdentifier: "DetailUpTableCell", for: indexPath) as? DetailUpTableViewCell,
            let downcell = tableView.dequeueReusableCell(withIdentifier: "DetailDownTableCell", for: indexPath) as? DetailDownTableViewCell else { return UITableViewCell() }
        if indexPath.row == 0 {
            let cell = upcell
            cell.detailNameLabel.text = list?.name
            cell.detailIdLabel.text = String(describing: list?.itemId)
            return cell
        } else {
            let cell = downcell
            return cell
        }
    }
    
}
