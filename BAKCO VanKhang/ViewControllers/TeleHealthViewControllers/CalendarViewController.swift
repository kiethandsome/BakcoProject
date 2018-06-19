//
//  CalendarViewController.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/4/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import JTAppleCalendar
import MBProgressHUD
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON

class CalendarViewController: BaseViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        return formatter
    }()
    
    var dates = [Date]()
    var doctorId = Int()
    var schedulers = [HealthCareScheduler]() {
        didSet {
            dates.removeAll()
            for scheduler in schedulers {
                let dateString = scheduler.Date
                let date = dateString.convertStringToDate(with: "yyyy-MM-dd")
                self.dates.append(date)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getScheduler(doctorId: self.doctorId)
        setupUI()
    }
    
    func setupUI() {
        title = "Chọn ngày hẹn"
        showCancelButton()
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollToDate(Date(), animateScroll: false)
    }
    
    func makeVisible(cell: CalendarCell) {
        cell.isUserInteractionEnabled = true
        cell.dateLabel.textColor = .white
    }
    
    func makeInvisible(cell: CalendarCell) {
        cell.isUserInteractionEnabled = false
        cell.dateLabel.textColor = UIColor.clear
    }
    
    func makeUnavailable(cell: CalendarCell) {
        cell.isUserInteractionEnabled = false
        cell.dateLabel.textColor = UIColor.lightGray
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {return}
        if cellState.dateBelongsTo == .thisMonth {
            handleAvailableDate(cell: cell, cellState: cellState)
        } else {
            makeInvisible(cell: validCell)
        }
    }
    
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {return}
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleAvailableDate(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        if self.dates.count > 0 {
            for date in dates {
                if cellState.date == date {
                    makeVisible(cell: validCell)
                } else {
                    makeUnavailable(cell: validCell)
                }
            }
        } else {
            makeUnavailable(cell: validCell) /// gray
        }
    }
    
    fileprivate func getScheduler(doctorId: Int) {
        let url = URL(string: API.TeleHealth.getSchedule)!
        let param: Parameters = ["doctorId" : doctorId,
                                 "serviceId" : 2]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let completionHandler = { (response: DataResponse<JSON>) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.schedulers.removeAll()
            
            print(response)
        }
        Alamofire.request(url, method: .get, parameters: param, encoding: JSONEncoding.default).responseSwiftyJSON(completionHandler: completionHandler)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let myCell = cell as? CalendarCell else {return}
        myCell.dateLabel.text = cellState.text
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let currentDate = visibleDates.monthDates.first?.date
        
        formatter.dateFormat = "MM"
        self.monthLabel.text = formatter.string(from: currentDate!)
        
        formatter.dateFormat = "yyyy"
        self.yearLabel.text = formatter.string(from: currentDate!)
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 5,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
}


















