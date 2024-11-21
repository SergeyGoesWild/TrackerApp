//
//  ScheduleVC.swift
//  Tracker
//
//  Created by Sergey Telnov on 21/11/2024.
//

import Foundation
import UIKit

final class ScheduleVC: UIViewController {
    
    let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    var scheduleTableView: UITableView!
    var doneScheduleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScheduleVC()
    }
    
    @objc private func doneScheduleButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
            print("Switch at row \(sender.tag) is now \(sender.isOn ? "ON" : "OFF")")
    }
    
    private func setupScheduleVC() {
        view.backgroundColor = .white
        navigationItem.title = "Расписание"
        navigationItem.hidesBackButton = true
        
        scheduleTableView = UITableView(frame: .zero, style: .plain)
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        scheduleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "scheduleCell")
        scheduleTableView.layer.cornerRadius = 16
        scheduleTableView.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        scheduleTableView.tableFooterView = UIView(frame: .zero)
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        view.addSubview(scheduleTableView)
        
        doneScheduleButton = UIButton(type: .system)
        doneScheduleButton.setTitle("Готово", for: .normal)
        doneScheduleButton.layer.cornerRadius = 16
        doneScheduleButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        doneScheduleButton.setTitleColor(.white, for: .normal)
        doneScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        doneScheduleButton.addTarget(self, action: #selector(doneScheduleButtonPressed), for: .touchUpInside)
        view.addSubview(doneScheduleButton)
        
        NSLayoutConstraint.activate([
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneScheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneScheduleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneScheduleButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

extension ScheduleVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ScheduleVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: Здесь тоже удалить лишние сепараторы
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        cell.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor(red: 0.22, green: 0.45, blue: 0.91, alpha: 1.00)
        switchControl.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        switchControl.tag = indexPath.row
        cell.accessoryView = switchControl
        return cell
    }
}

