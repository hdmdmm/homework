//
//  UserListViewController.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/21/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserListViewController: UITableViewController {
    private let dataLayer = DataLayer()
    private var list = BehaviorRelay(value: [UserModel]())
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Car Owners"
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(updateList), for: .valueChanged)
        setupCellConfiguration()
        setupCellTapHandling()
        updateList()
    }
    
    private func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(UserModel.self)
            .subscribe(onNext: { [weak self]
                userModel in
                if let indexPath = self?.tableView.indexPathForSelectedRow {
                    self?.tableView.deselectRow(at: indexPath, animated: true)
                }
                let vc = GeoDetailsViewController.instantiate(from: Storyboard.main)
                vc.userModel = userModel
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
    }

    private func setupCellConfiguration() {
        list.asObservable()
            .bind(to: tableView
                .rx
                .items(cellIdentifier: UserListCell.cellID, cellType: UserListCell.self)) {
            row, model, cell in
            cell.configure(with: model.owner)
        }.disposed(by: disposeBag)
    }
    
    @objc private func updateList() {
        self.refreshControl?.beginRefreshing()
        let completion: (_ list: [UserModel]?, _ error: Error?) -> Swift.Void = {
            [weak self] list, error in
            self?.refreshControl?.endRefreshing()
            if error != nil {
                self?.showError(error)
                return
            }
            guard let list = list else {
                return
            }
            self?.list.accept(list)
        }
        guard let list = dataLayer.getList(completion), !list.isEmpty else {
            log.warning("Nothing cached in the datalayer list")
            return
        }
        self.list.accept(list)
    }
}

extension UserListViewController: Message{}
