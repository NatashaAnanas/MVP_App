//
//  MainViewController.swift
//  MVP_App
//
//  Created by Наталья Коновалова on 26.01.2026.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func reloadData()
    func updateImage(_ image: UIImage?, at index: Int)
}

final class MainViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var presenter: MainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        presenter.fetchInfo()
    }
    
    private func setupUI() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectItem(at: indexPath.row)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainTableViewCell.reuseId,
            for: indexPath
        ) as? MainTableViewCell
        else { return UITableViewCell() }
        
        let index = indexPath.row
        cell.configure(title: presenter.item(at: index))
        
        if let image = presenter.cachedImage(at: index) {
            cell.setImage(image)
        } else {
            cell.setImage(nil)
            presenter.fetchImage(at: indexPath.row)
        }
        
        return cell
    }
}

extension MainViewController: MainViewProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateImage(_ image: UIImage?, at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell else {
            return
        }
        cell.setImage(image)
    }
}
