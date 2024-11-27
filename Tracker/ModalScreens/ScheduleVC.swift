//
//  ScheduleVC.swift
//  Tracker
//
//  Created by Sergey Telnov on 21/11/2024.
//

import Foundation
import UIKit

struct dayOfWeek {
    let orderInt: Int
    let fullName: String
    let shortName: String
    let engName: String
}

protocol ScheduleDelegateProtocol {
    func didSetSchedule(scheduleArray: [dayOfWeek])
}

final class ScheduleVC: UIViewController {
    
    let daysOfWeek = [dayOfWeek(orderInt: 0, fullName: "Понедельник", shortName: "Пн", engName: "Monday"),
                      dayOfWeek(orderInt: 1, fullName: "Вторник", shortName: "Вт", engName: "Tuesday"),
                      dayOfWeek(orderInt: 2, fullName: "Среда", shortName: "Ср", engName: "Wednesday"),
                      dayOfWeek(orderInt: 3, fullName: "Четверг", shortName: "Чт", engName: "Thursday"),
                      dayOfWeek(orderInt: 4, fullName: "Пятница", shortName: "Пт", engName: "Friday"),
                      dayOfWeek(orderInt: 5, fullName: "Суббота", shortName: "Сб", engName: "Saturday"),
                      dayOfWeek(orderInt: 6, fullName: "Воскресенье", shortName: "Вс", engName: "Sunday")]
    
    var scheduleSelection: [dayOfWeek] = []
    var delegate: ScheduleDelegateProtocol?
    
    var scheduleTableView: UITableView!
    var doneScheduleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScheduleVC()
    }
    
    @objc private func doneScheduleButtonPressed() {
        guard let delegate else { return }
        scheduleSelection.sort(by: { $0.orderInt < $1.orderInt })
        delegate.didSetSchedule(scheduleArray: scheduleSelection)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            scheduleSelection.append(daysOfWeek[sender.tag])
        } else {
            let elementToRemove = daysOfWeek[sender.tag]
            scheduleSelection.removeAll(where: { $0.fullName == elementToRemove.fullName })
        }
        updateButtonState()
    }
    
    private func updateButtonState() {
        if scheduleSelection.count > 0 {
            enableDoneButton()
        } else {
            disableDoneButton()
        }
    }
    
    private func enableDoneButton() {
        doneScheduleButton.isEnabled = true
        doneScheduleButton.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
    }
    
    private func disableDoneButton() {
        doneScheduleButton.isEnabled = false
        doneScheduleButton.backgroundColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
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
        if scheduleSelection.count > 0 {
            enableDoneButton()
        } else {
            disableDoneButton()
        }
        doneScheduleButton.setTitle("Готово", for: .normal)
        doneScheduleButton.layer.cornerRadius = 16
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
        let currentItem = daysOfWeek[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        cell.textLabel?.text = daysOfWeek[indexPath.row].fullName
        cell.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        let switchControl = UISwitch()
        if scheduleSelection.contains(where: { $0.fullName == currentItem.fullName }) {
            switchControl.isOn = true
        }
        switchControl.onTintColor = UIColor(red: 0.22, green: 0.45, blue: 0.91, alpha: 1.00)
        switchControl.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        switchControl.tag = indexPath.row
        cell.accessoryView = switchControl
        return cell
    }
}

