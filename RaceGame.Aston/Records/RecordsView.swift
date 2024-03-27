//
//  Records.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 12.03.2024.
//

import UIKit
import SnapKit

private enum Constants {
    static let viewBackgroundColor: UIColor = .white
}

private extension String {
    static let title = "Таблица рекордов"
}

final class RecordsView: UIViewController {
    
    var presenter: RecordsPresenter?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecordsCell.self, forCellReuseIdentifier: RecordsCell.identifire)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.viewBackgroundColor
        navigationItem.title = .title
        setupView()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension RecordsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let playersList = presenter?.getPlayers() else { return 1 }
        return playersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let playersList = presenter?.getPlayers() else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordsCell.identifire, for: indexPath) as! RecordsCell
        cell.delegate = self
        cell.setupPlayer(player: playersList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension RecordsView: RecordsViewDelegate {
    func getAvatar(player: Player) -> UIImage? {
        let avatar = presenter?.getAvatar(player: player)
        return avatar
    }
}
