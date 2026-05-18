//
//  ViewController.swift
//  List of guests
//
//  Created by Мария Александрова on 18.05.2026.
//

import UIKit

class ListGuestsViewController: UIViewController {
    
    var guests: [Guest] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var addGuest: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 20,
            bottom: 12,
            trailing: 20
        )
        config.background.backgroundColor = .white
        config.cornerStyle = .capsule
        button.configuration = config
        button.setTitle("Добавить гостя", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.setTitleColor(.darkGray, for: .selected)
        button.setTitleColor(.darkGray, for: .disabled)
        
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addGuestButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .systemBlue
//      tableView.separatorEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        tableView.register(GuestTableViewCell.self, forCellReuseIdentifier: GuestTableViewCell.id)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setupTableView()
        loadGuests()
        setupConstraints()
//        tableView.isHidden = true
    }

    func setupTableView() {
        view.addSubviews([addGuest, tableView])
   }
    
    @objc private func addGuestButtonTapped() {
//        print("addGuestButtonTapped")
        showAlertAddGuest()
    }
    
    private func showAlertAddGuest() {
        let alert = UIAlertController(title: "Добавить гостя",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Введите имя"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Введите фамилию"
        }
        let action = UIAlertAction(title: "Добавить", style: .default) { _ in
            self.guests.append(Guest(id: self.guests.count,
                                     name: alert.textFields?[0].text ?? "",
                                     sername: alert.textFields?[1].text ?? "",
                                     count: 0))
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addGuest.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addGuest.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            addGuest.widthAnchor.constraint(equalToConstant: 300),
//            addGuest.heightAnchor.constraint(equalToConstant: 48),

            tableView.topAnchor.constraint(equalTo: addGuest.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}

extension ListGuestsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: GuestTableViewCell.id,
                                                  for: indexPath) as! GuestTableViewCell
        let guest = guests[indexPath.row]
        
        cell.setup(with: guest)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 60
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Изменить") { _, _, _ in
            let alert = UIAlertController(title: "Изменить гостя", message: nil, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = self.guests[indexPath.row].name
            }
            alert.addTextField { (textField) in
                textField.text = self.guests[indexPath.row].sername
            }
            
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                self.guests[indexPath.row].name = alert.textFields?[0].text ?? ""
                self.guests[indexPath.row].sername = alert.textFields?[1].text ?? ""
                self.tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "Отмена", style: .destructive)
            alert.addAction(action)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
        action.backgroundColor = .systemGreen
        
        let config = UISwipeActionsConfiguration(actions: [action])
        return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.guests.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}

private extension ListGuestsViewController {

    func loadGuests() {

        guard let url = Bundle.main.url(
            forResource: "listGuests",
            withExtension: "json"
        ) else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)

            let decodedGuests = try JSONDecoder().decode(
                [Guest].self,
                from: data
            )
            guests = decodedGuests
        } catch {
            print("Decode error:", error)
        }
    }
}
