//
//  SearchItemViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/15.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class SearchItemViewController: UIViewController {

    @IBOutlet weak var itemSearchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!

    var allItems: [ItemList] = []
    var searchItems: [ItemList] = []
    var scanResult: Int?

    let foodManager = FoodManager()
    let medicineManager = MedicineManager()
    let makeupManager = MakeupManager()
    let necessaryManager = NecessaryManager()
    let othersManager = OthersManager()
    let taskGroup = DispatchGroup()

    var foodItems: [ItemList] = []
    var medicineItems: [ItemList] = []
    var makeupItems: [ItemList] = []
    var necessaryItems: [ItemList] = []
    var othersItems: [ItemList] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        setupResultTableView()

        itemSearchBar.delegate = self

        getTotalData()

        self.searchItems = self.allItems

        let notificationName = Notification.Name("ScanResult")
        NotificationCenter.default.addObserver(self, selector: #selector(getScanResult(noti:)), name: notificationName, object: nil)
    }

    func setupResultTableView() {

        resultTableView.delegate = self

        resultTableView.dataSource = self

        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)

        resultTableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")

    }

    private func getTotalData() {

        //        DispatchQueue.global(qos: .background).async {
        self.taskGroup.enter()

        self.foodManager.getFoodItems(success: { [weak self] nonTrashItems, _  in

            self?.foodItems = nonTrashItems
            self?.taskGroup.leave()

        }) { [weak self] (error) in

            print(error)
            self?.taskGroup.leave()
        }

        self.taskGroup.enter()

        self.medicineManager.getMedicineItems(success: { [weak self] nonTrashItems, _  in

            self?.medicineItems = nonTrashItems
            self?.taskGroup.leave()

        }) { [weak self] (error) in

            print(error)
            self?.taskGroup.leave()
        }

        self.taskGroup.enter()

        self.makeupManager.getMakeupItems(success: { [weak self] nonTrashItems, _  in

            self?.makeupItems = nonTrashItems
            self?.taskGroup.leave()

        }) { [weak self] (error) in

            print(error)
            self?.taskGroup.leave()
        }

        self.taskGroup.enter()

        self.necessaryManager.getNecessaryItems(success: { [weak self] nonTrashItems, _  in

            self?.necessaryItems = nonTrashItems
            self?.taskGroup.leave()

        }) { [weak self] (error) in

            print(error)
            self?.taskGroup.leave()
        }

        self.taskGroup.enter()

        self.othersManager.getOthersItems(success: { [weak self] nonTrashItems, _  in

            self?.othersItems = nonTrashItems
            self?.taskGroup.leave()

        }) { [weak self] (error) in

            print(error)
            self?.taskGroup.leave()
        }
        //        }

        self.taskGroup.notify(queue: .main) { [weak self] in

            guard let strongSelf = self else { return }

            strongSelf.allItems = strongSelf.foodItems + strongSelf.medicineItems + strongSelf.makeupItems + strongSelf.necessaryItems + strongSelf.othersItems

            strongSelf.resultTableView.reloadData()
        }

    }

    @objc func getScanResult(noti: Notification) {

        guard let data = noti.userInfo!["PASS"] as? String else { return }

        self.itemSearchBar.text = data

        matchSearchResult(text: data)
    }

}

extension SearchItemViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableCell", for: indexPath) as? ItemListTableViewCell {

            cell.selectionStyle = .none

            switch searchItems[indexPath.row].isInstock {
            case true:

                cell.setupInstockCell(item: searchItems[indexPath.row])

            default:

                cell.setupNotInstockCell(item: searchItems[indexPath.row])
            }

            return cell

        } else {

            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = UIStoryboard.itemDetailStoryboard().instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }
        controller.list = searchItems[indexPath.row]
        controller.index = indexPath.row
        show(controller, sender: nil)
    }

}

extension SearchItemViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        matchSearchResult(text: searchText)
    }

    func matchSearchResult(text: String) {
        if text == "" {
            self.searchItems = []
        } else {
            self.searchItems = []
            for item in self.allItems {
                if item.name.lowercased().hasPrefix(text.lowercased()) || String(describing: item.itemId).lowercased().hasPrefix(text.lowercased()) {
                    self.searchItems.append(item)
                }
            }
        }
        self.resultTableView.reloadData()
    }

}
