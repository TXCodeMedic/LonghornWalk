//
//  SettingsViewController.swift
//  LonghornWalk
//
//  Created by Yousuf Din on 11/29/22.
//

import UIKit

struct Section {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
    case soundSwitchCell(model: SettingsSwitchOption)
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
    var isOn: Bool
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.self.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.self.identifier)
        table.register(SoundSwitchTableViewCell.self, forCellReuseIdentifier: SoundSwitchTableViewCell.self.identifier)


        return table
    }()
        
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
        
    func configure() {
        models.append(Section(title: "General", options: [
            .switchCell(model: SettingsSwitchOption(title: "Dark Mode", icon: (UIImage(systemName: "moon.circle")), iconBackgroundColor: .systemIndigo, handler: {
                print("Switch")
            }, isOn: UserDefaults.standard.bool(forKey: "darkMode"))),
            
            .soundSwitchCell(model: SettingsSwitchOption(title: "Sound", icon: (UIImage(systemName: "speaker.wave.3.fill")), iconBackgroundColor: .systemPink, handler: {
                print("Switch")
            }, isOn: UserDefaults.standard.bool(forKey: "sound")))
            
        ]))
        
        models.append(Section(title: "Fonts", options: [
            .staticCell(model: SettingsOption(title: "Choose Font", icon: (UIImage(systemName: "textformat")), iconBackgroundColor: .systemGray) {
                let controller = UIAlertController(
                    title: "Available Fonts",
                    message: "Select a font to change app settings",
                    preferredStyle: .actionSheet)
                controller.addAction(UIAlertAction(
                    title: "System",
                    style: .default,
                    handler: {_ in UILabel.appearance(whenContainedInInstancesOf: [UIViewController.self]).font = UIFont.init(name: "San Francisco", size: 14)
                        UserDefaults.standard.set("system", forKey: "font")
                    }))
                controller.addAction(UIAlertAction(
                    title: "Courier",
                    style: .default,
                    handler: {_ in UILabel.appearance(whenContainedInInstancesOf: [UIViewController.self]).font = UIFont.init(name: "Courier", size: 14)
                        UserDefaults.standard.set("courier", forKey: "font")
                    }))
                controller.addAction(UIAlertAction(
                    title: "Futura",
                    style: .default,
                    handler: {_ in UILabel.appearance(whenContainedInInstancesOf: [UIViewController.self]).font = UIFont.init(name: "Futura", size: 14)
                        UserDefaults.standard.set("futura", forKey: "font")
                    }))
                controller.addAction(UIAlertAction(
                    title: "Papyrus",
                    style: .default,
                    handler: {_ in UILabel.appearance(whenContainedInInstancesOf: [UIViewController.self]).font = UIFont.init(name: "Papyrus", size: 14)
                        UserDefaults.standard.set("papyrus", forKey: "font")
                    }))
                controller.addAction(UIAlertAction(
                    title: "Times New Roman",
                    style: .default,
                    handler: {_ in UILabel.appearance(whenContainedInInstancesOf: [UIViewController.self]).font = UIFont.init(name: "Times New Roman", size: 14)
                        UserDefaults.standard.set("timesNewRoman", forKey: "font")
                    }))
                
                self.present(controller, animated: true)
            })
        ]))
        
        models.append(Section(title: "Application", options: [
            .staticCell(model: SettingsOption(title: "Terms of Service", icon: (UIImage(systemName: "text.badge.checkmark")), iconBackgroundColor: .systemPink) {
                let controller = UIAlertController(
                    title: "Terms of Service",
                    message: "blah blah blah",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "Dismiss",
                    style: .cancel))
                
                self.present(controller, animated: true)
            }),
            .staticCell(model:SettingsOption(title: "Privacy Policy", icon: (UIImage(systemName: "lock.shield")), iconBackgroundColor: .link) {
                let controller = UIAlertController(
                    title: "Privacy Policy",
                    message: "blah blah blah",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "Dismiss",
                    style: .cancel))
                
                self.present(controller, animated: true)
            }),
            .staticCell(model:SettingsOption(title: "Course Website", icon: (UIImage(systemName: "desktopcomputer")), iconBackgroundColor: .systemGreen) {
                guard let url = URL(string: "https://www.cs.utexas.edu/~bulko/2022fall/329E.html") else { return }
                UIApplication.shared.open(url)
            }),
            .staticCell(model:SettingsOption(title: "Learn More", icon: (UIImage(systemName: "graduationcap.fill")), iconBackgroundColor: .systemOrange) {
                let controller = UIAlertController(
                    title: "Learn More",
                    message: "blah blah blah",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "Dismiss",
                    style: .cancel))
                
                self.present(controller, animated: true)
            })
        ]))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .soundSwitchCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SoundSwitchTableViewCell.identifier, for: indexPath) as? SoundSwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        case .soundSwitchCell(model: let model):
            model.handler()
        }
    }
    
}

