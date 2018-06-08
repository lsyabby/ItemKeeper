//
//  PrivacyViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/27.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var privacyTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

    }
    
    func setupTableView() {
        
        privacyTableView.delegate = self
        
        privacyTableView.dataSource = self
        
    }

}

extension PrivacyViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PrivacyTableViewCell.self), for: indexPath) as? PrivacyTableViewCell else { return UITableViewCell() }
       
        cell.okBtn.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        
        return cell
    }

    @objc func backToLogin() {
       
        dismiss(animated: true, completion: nil)
    }

}
