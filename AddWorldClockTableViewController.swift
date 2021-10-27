//
//  AddWorldClockTableViewController.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2021/10/22.
//

import UIKit

protocol AddWorldClockTableViewControllerDelegate {
    // 離開增加世界時鐘的頁面後觸發
    func addWorldClockTableViewControllerDidCancel(_ controller: AddWorldClockTableViewController)
}

class AddWorldClockTableViewController: UITableViewController {
    let zoneList = Zone.data
    lazy var filteredZoneList = zoneList
    var selectedZone: Zone?
    var delegate: AddWorldClockTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        // present modally 向下滑相關
        navigationController?.presentationController?.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredZoneList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CityTableViewCell.self)", for: indexPath) as? CityTableViewCell else  { return UITableViewCell() }
        let row = indexPath.row
        let zone = filteredZoneList[row]
        let countryName = zone.countryNameByCN
        let city = zone.cityNameByCN
        cell.cityLabel.text = "\(city) (\(countryName))"
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            selectedZone = filteredZoneList[indexPath.row]
        }
    }
}

// MARK: UISearchResultsUpdating - search controller 更新表格內容
extension AddWorldClockTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
           searchText.isEmpty == false {
            filteredZoneList = zoneList.filter({($0.cityNameByCN+$0.countryNameByCN).localizedStandardContains(searchText)})
        } else {
            filteredZoneList = zoneList
        }
        tableView.reloadData()
    }
}

// MARK: UISearchBarDelegate - search bar 取消觸發
extension AddWorldClockTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        delegate?.addWorldClockTableViewControllerDidCancel(self)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UIAdaptivePresentationControllerDelegate - present modally 向下滑觸發
extension AddWorldClockTableViewController: UIAdaptivePresentationControllerDelegate {
    // present modally 向下滑觸發
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        self.delegate?.addWorldClockTableViewControllerDidCancel(self)
    }
}
