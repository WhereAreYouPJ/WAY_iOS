////
////  ScheduleViewUIKit.swift
////  Where_Are_You
////
////  Created by juhee on 29.10.24.
////
//
//import Foundation
//import UIKit
//import SwiftUI
//
//class ScheduleViewController: UIViewController {
//    private var viewModel: ScheduleViewModel
//    private var selectedDate: Date?
//    private var weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
//    
//    // MARK: - UI Components
//    private lazy var yearMonthLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 22))
//        label.textColor = .color17
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private lazy var previousMonthButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
//        button.tintColor = .black
//        button.addTarget(self, action: #selector(previousMonthTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private lazy var nextMonthButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        button.tintColor = .black
//        button.addTarget(self, action: #selector(nextMonthTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private lazy var notificationButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "icon-notification"), for: .normal)
//        button.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private lazy var addButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "icon-plus"), for: .normal)
//        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private lazy var weekdayStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.spacing = 0
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//    
//    private lazy var calendarCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//    
//    // MARK: - Initialization
//    init() {
//        self.viewModel = ScheduleViewModel(service: ScheduleService())
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupConstraints()
//        setupWeekdayLabels()
//        updateYearMonthLabel()
//        
//        viewModel.getMonthlySchedule()
//    }
//    
//    // MARK: - UI Setup
//    private func setupUI() {
//        view.backgroundColor = .white
//        
//        view.addSubview(yearMonthLabel)
//        view.addSubview(previousMonthButton)
//        view.addSubview(nextMonthButton)
//        view.addSubview(notificationButton)
//        view.addSubview(addButton)
//        view.addSubview(weekdayStackView)
//        view.addSubview(calendarCollectionView)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Year Month Label
//            yearMonthLabel.leadingAnchor.constraint(equalTo: previousMonthButton.trailingAnchor, constant: 20),
//            yearMonthLabel.centerYAnchor.constraint(equalTo: previousMonthButton.centerYAnchor),
//            
//            // Previous Month Button
//            previousMonthButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            previousMonthButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            previousMonthButton.widthAnchor.constraint(equalToConstant: 44),
//            previousMonthButton.heightAnchor.constraint(equalToConstant: 44),
//            
//            // Next Month Button
//            nextMonthButton.leadingAnchor.constraint(equalTo: yearMonthLabel.trailingAnchor, constant: 20),
//            nextMonthButton.centerYAnchor.constraint(equalTo: previousMonthButton.centerYAnchor),
//            nextMonthButton.widthAnchor.constraint(equalToConstant: 44),
//            nextMonthButton.heightAnchor.constraint(equalToConstant: 44),
//            
//            // Add Button
//            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            addButton.centerYAnchor.constraint(equalTo: previousMonthButton.centerYAnchor),
//            addButton.widthAnchor.constraint(equalToConstant: 34),
//            addButton.heightAnchor.constraint(equalToConstant: 34),
//            
//            // Notification Button
//            notificationButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),
//            notificationButton.centerYAnchor.constraint(equalTo: previousMonthButton.centerYAnchor),
//            notificationButton.widthAnchor.constraint(equalToConstant: 34),
//            notificationButton.heightAnchor.constraint(equalToConstant: 34),
//            
//            // Weekday Stack View
//            weekdayStackView.topAnchor.constraint(equalTo: previousMonthButton.bottomAnchor, constant: 16),
//            weekdayStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            weekdayStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            weekdayStackView.heightAnchor.constraint(equalToConstant: 30),
//            
//            // Calendar Collection View
//            calendarCollectionView.topAnchor.constraint(equalTo: weekdayStackView.bottomAnchor),
//            calendarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            calendarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            calendarCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private func setupWeekdayLabels() {
//        weekdaySymbols.enumerated().forEach { index, symbol in
//            let label = UILabel()
//            label.text = symbol.uppercased()
//            label.textAlignment = .center
//            label.font = UIFont.pretendard(NotoSans: .regular, fontSize: 14)
//            
//            // Set weekday colors
//            switch index + 1 {
//            case 1: label.textColor = .color255125  // Sunday
//            case 7: label.textColor = .color57125   // Saturday
//            default: label.textColor = .color102
//            }
//            
//            weekdayStackView.addArrangedSubview(label)
//        }
//        
//        let separator = UIView()
//        separator.backgroundColor = .brandColor
//        separator.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(separator)
//        
//        NSLayoutConstraint.activate([
//            separator.topAnchor.constraint(equalTo: weekdayStackView.bottomAnchor),
//            separator.leadingAnchor.constraint(equalTo: weekdayStackView.leadingAnchor),
//            separator.trailingAnchor.constraint(equalTo: weekdayStackView.trailingAnchor),
//            separator.heightAnchor.constraint(equalToConstant: 1)
//        ])
//    }
//    
//    private func updateYearMonthLabel() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY.MM"
//        yearMonthLabel.text = formatter.string(from: viewModel.month)
//    }
//    
//    // MARK: - Actions
//    @objc private func previousMonthTapped() {
//        viewModel.changeMonth(by: -1)
//        updateYearMonthLabel()
//        calendarCollectionView.reloadData()
//    }
//    
//    @objc private func nextMonthTapped() {
//        viewModel.changeMonth(by: 1)
//        updateYearMonthLabel()
//        calendarCollectionView.reloadData()
//    }
//    
//    @objc private func notificationTapped() {
//        print("알림 페이지로 이동")
//    }
//    
//    @objc private func addTapped() {
//        let createScheduleView = CreateScheduleView()
//            let hostingController = UIHostingController(rootView: createScheduleView)
//            hostingController.modalPresentationStyle = .fullScreen
//            present(hostingController, animated: true)
//    }
//}
//
//// MARK: - UICollectionView DataSource & Delegate
//extension ScheduleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: viewModel.month)?.count ?? 0
//        let firstWeekday = Calendar.current.component(.weekday, from: viewModel.month.startOfMonth()) - 1
//        let totalDays = daysInMonth + firstWeekday
//        let rows = Int(ceil(Double(totalDays) / 7.0))
//        return rows * 7
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
//        
//        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: viewModel.month)?.count ?? 0
//        let firstWeekday = Calendar.current.component(.weekday, from: viewModel.month.startOfMonth()) - 1
//        let day = indexPath.item - firstWeekday + 1
//        
//        if day > 0 && day <= daysInMonth {
//            cell.configure(day: day, isCurrentMonth: true)
//            
//            // Get date for current cell
//            let date = Calendar.current.date(byAdding: .day, value: day - 1, to: viewModel.month.startOfMonth())!
//            
//            // Check for schedules on this date
//            let daySchedules = viewModel.monthlySchedules.filter { schedule in
//                let scheduleStartDate = Calendar.current.startOfDay(for: schedule.startTime)
//                let scheduleEndDate = Calendar.current.startOfDay(for: schedule.endTime)
//                let cellDate = Calendar.current.startOfDay(for: date)
//                return (scheduleStartDate...scheduleEndDate).contains(cellDate)
//            }
//            
//            // Configure cell with schedules
//            cell.configureSchedules(daySchedules)
//        } else {
//            cell.configure(day: 0, isCurrentMonth: false)
//        }
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.bounds.width - 7) / 7 // -7 for spacing
//        let height = (collectionView.bounds.height - 5 * 7) / 6 // Assuming 6 rows max
//        return CGSize(width: width, height: height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: viewModel.month)?.count ?? 0
//        let firstWeekday = Calendar.current.component(.weekday, from: viewModel.month.startOfMonth()) - 1
//        let day = indexPath.item - firstWeekday + 1
//        
//        if day > 0 && day <= daysInMonth {
//            guard let date = Calendar.current.date(byAdding: .day, value: day - 1, to: viewModel.month.startOfMonth()) else { return }
//            
//            let daySchedules = viewModel.monthlySchedules.filter { schedule in
//                let scheduleStartDate = Calendar.current.startOfDay(for: schedule.startTime)
//                let scheduleEndDate = Calendar.current.startOfDay(for: schedule.endTime)
//                let cellDate = Calendar.current.startOfDay(for: date)
//                return (scheduleStartDate...scheduleEndDate).contains(cellDate)
//            }
//            
//            if !daySchedules.isEmpty {
//                // SwiftUI의 DailyScheduleView를 UIHostingController로 감싸서 표시
//                let dailyScheduleView = DailyScheduleView(
//                    date: date,
//                    isPresented: .constant(true),
//                    onDeleteSchedule: { schedule, title, message in
//                        // 삭제 처리 로직
//                        self.viewModel.deleteSchedule(schedule)
//                        self.calendarCollectionView.reloadData()
//                    }
//                )
//                let hostingController = UIHostingController(rootView: dailyScheduleView)
//                hostingController.modalPresentationStyle = .pageSheet
//                
//                if let sheet = hostingController.sheetPresentationController {
//                    sheet.detents = [.medium()]
//                }
//                
//                present(hostingController, animated: true)
//            }
//        }
//    }
//}
//
//// MARK: - Calendar Cell
//class CalendarCell: UICollectionViewCell {
//    private let dayLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont.pretendard(NotoSans: .regular, fontSize: 14)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let schedulesStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 2
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupUI() {
//        contentView.addSubview(dayLabel)
//        contentView.addSubview(schedulesStackView)
//        
//        NSLayoutConstraint.activate([
//            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
//            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            dayLabel.widthAnchor.constraint(equalToConstant: 30),
//            dayLabel.heightAnchor.constraint(equalToConstant: 30),
//            
//            schedulesStackView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 2),
//            schedulesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
//            schedulesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
//            schedulesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
//        ])
//    }
//    
//    func configure(day: Int, isCurrentMonth: Bool) {
//        dayLabel.text = day > 0 ? "\(day)" : ""
//        
//        if isCurrentMonth {
//            let weekday = Calendar.current.component(.weekday, from: Date()) // 실제로는 해당 날짜의 요일을 계산해야 함
//            switch weekday {
//            case 1: dayLabel.textColor = .color255125  // Sunday
//            case 7: dayLabel.textColor = .color57125   // Saturday
//            default: dayLabel.textColor = .color17
//            }
//        } else {
//            dayLabel.textColor = .color190
//        }
//        
//        // Clear previous schedule views
//        schedulesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//    }
//    
//    func configureSchedules(_ schedules: [Schedule]) {
//        // Maximum 4 schedule bars to show
//        let maxSchedules = min(schedules.count, 4)
//        
//        for i in 0..<maxSchedules {
//            let schedule = schedules[i]
//            let scheduleView = createScheduleView(schedule: schedule, isLastWithMore: i == 3 && schedules.count > 4)
//            schedulesStackView.addArrangedSubview(scheduleView)
//        }
//    }
//    
//    private func createScheduleView(schedule: Schedule, isLastWithMore: Bool) -> UIView {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            view.heightAnchor.constraint(equalToConstant: 14)
//        ])
//        
//        if isLastWithMore {
//            view.backgroundColor = .color231
//            
//            let label = UILabel()
//            label.text = "+"
//            label.font = UIFont.pretendard(NotoSans: .regular, fontSize: 9)
//            label.textAlignment = .center
//            label.translatesAutoresizingMaskIntoConstraints = false
//            
//            view.addSubview(label)
//            NSLayoutConstraint.activate([
//                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//            ])
//            
//        } else {
//            view.backgroundColor = scheduleColor(for: schedule.color)
//            view.layer.cornerRadius = 2
//            
//            let label = UILabel()
//            label.text = schedule.title
//            label.font = UIFont.pretendard(NotoSans: .regular, fontSize: 9)
//            label.textColor = .white
//            label.translatesAutoresizingMaskIntoConstraints = false
//            
//            view.addSubview(label)
//            NSLayoutConstraint.activate([
//                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
//                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
//                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//            ])
//        }
//        
//        return view
//    }
//    
//    private func scheduleColor(for color: String) -> UIColor {
//        switch color {
//        case "red": return .colorRed
//        case "yellow": return .colorYellow
//        case "green": return .colorGreen
//        case "blue": return .colorBlue
//        case "violet": return .colorViolet
//        case "pink": return .colorPink
//        default: return .colorRed
//        }
//    }
//}
//
//// MARK: - Date Extensions
//extension Date {
//    func startOfMonth() -> Date {
//        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
//    }
//    
//    func endOfMonth() -> Date {
//        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
//    }
//}
