//
//  SettingsView.swift
//  RaceGame.Aston
//
//  Created by Sokolov on 01.03.2024.
//

import UIKit
import SnapKit

private enum Constants {
    static let viewBackgroundColor: UIColor = .white
}

private extension String {
    static let title = "Настройки"
    static let alertTitle = "Изменить никнейм"
    static let alertPlaceHolder = "Введите новый никнейм"
    static let alertOkAction = "Сохранить"
    static let alertBackBAction = "Отмена"
    static let errorAlertTitle = "Некорректный никнейм"
    static let errorAlertAction = "Ок"
}

final class SettingsView: UIViewController {
    
    var presenter: SettingsPresenter?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsCellProfile.self, forCellReuseIdentifier: SettingsCellProfile.identifire)
        tableView.register(SettingsCellCar.self, forCellReuseIdentifier: SettingsCellCar.identifire)
        tableView.register(SettingsCellGame.self, forCellReuseIdentifier: SettingsCellGame.identifire)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenFrame = self.view.frame
        let isScrollingEnabled = tableView.shouldEnableScrolling(within: screenFrame)
        tableView.isScrollEnabled = isScrollingEnabled
    }
}

extension SettingsView: SettingsCellProfileDelegate {
    func changeAvatar() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func changeNickname() {
        let alertController = UIAlertController(title: .alertTitle, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = .alertPlaceHolder
        }
        
        let changeAction = UIAlertAction(title: .alertOkAction, style: .default) { [weak self] _ in
            guard let newNickname = alertController.textFields?.first?.text else { return }
            if newNickname.hasLetter == true {
                self?.presenter?.updateNickname(newNickname)
                self?.tableView.reloadData()
            } else {
                let errorAlert =  UIAlertController(title: .errorAlertTitle, message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: .errorAlertAction, style: .cancel, handler: nil)
                errorAlert.addAction(cancelAction)
                self?.present(errorAlert, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: .alertBackBAction, style: .cancel, handler: nil)
        
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension SettingsView: SettingsCellCarDelegate {
    func getNewColor() {
        guard let newColor = presenter?.getNewColor() else { return }
        presenter?.updateCarColor(newColor)
        tableView.reloadData()
    }
}

extension SettingsView: SettingsCellGameDelegate {
    func setThree() {
        presenter?.updateGameSettingsThree()
        tableView.reloadData()
    }
    
    func setStone() {
        presenter?.updateGameSettingsStone()
        tableView.reloadData()
    }
    
    func setGameSpeed(x2: Bool) {
        presenter?.updateGameSettingsSpeed()
        tableView.reloadData()
    }
}

extension SettingsView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            presenter?.updateAvatar(image)
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == .zero {
            guard let player = presenter?.getPlayer() else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCellProfile.identifire, for: indexPath) as! SettingsCellProfile
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setupUser(user: player,
                           avatar: (presenter?.getAvatar())!)
            return cell
        } else if indexPath.section == 1 {
            guard let player = presenter?.getPlayer() else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCellCar.identifire, for: indexPath) as! SettingsCellCar
            cell.delegate = self
            cell.selectionStyle = .none
            cell.setupCarColor(player: player)
            return cell
        } else {
            guard let player = presenter?.getPlayer() else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCellGame.identifire, for: indexPath) as! SettingsCellGame
            cell.delegate = self
            cell.setupSettings(three: player.threesEnabled,
                               stone: player.stonesEnabled,
                               gameSpeedX2: player.gameSpeedX2)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}
