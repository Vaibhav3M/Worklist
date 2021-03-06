//
//  DashboardViewController.swift
//  Worklist
//
//  Created by Vaibhav M on 31/10/18.
//  Copyright © 2018 Vaibhav M. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    var taskDataList  = [TaskData]()
    var approvalDataList = [ApprovalData]()
   
    @IBOutlet weak var btnAutoApproval: UIButton!
    @IBOutlet weak var btnFloatStatus: UIButton!
    @IBOutlet weak var btnFloatTask: UIButton!
    @IBOutlet weak var btnFloatApproval: UIButton!
    @IBOutlet weak var btnFloatClose: UIButton!
    @IBOutlet weak var floatingBtnView: UIView!
    
    @IBOutlet weak var viewFloatingButtonCover: UIView!
    
    @IBOutlet weak var viewFloatingButtonCoverTop: UIView!
    @IBOutlet weak var dashboardView: UIView!
    @IBOutlet weak var taskHeaderView: UIView!
    @IBOutlet weak var approvalHeaderView: UIView!
    
    @IBOutlet weak var approvalView: UIView!
    
    @IBOutlet weak var tableBg: UIView!
    
    @IBOutlet weak var btnSeeAllApproval: UIButton!
    @IBOutlet weak var btnApprovalCount: UIButton!
    
    @IBOutlet weak var taskCollectionView: UICollectionView!

    @IBOutlet weak var approvalTableView: UITableView!
    
    
    let taskCellIdentifier = "taskCell"
    let approvalCellIdentifier = "approvalCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        taskData()
        approvalData()
        taskTap()
        approvalTap()
        
        btnApprovalCount.setTitle(String(approvalDataList.count), for: .normal)
        
       //MARK: tableView Corner radius
        self.approvalTableView.layer.cornerRadius = 10
        self.approvalTableView.layer.masksToBounds = true
        
        btnApprovalCount.layer.cornerRadius = btnApprovalCount.frame.width / 2
        btnApprovalCount.layer.masksToBounds = true
        
        //MARK:  button actions
        btnApprovalCount.addTarget(self, action: #selector(seeAllApprovalViewButton), for: .touchUpInside)
        btnSeeAllApproval.addTarget(self, action: #selector(seeAllApprovalViewButton), for: .touchUpInside)
        
        //MARK: floating btn actions
        btnFloatClose.addTarget(self, action: #selector(close), for: .touchUpInside)
        btnFloatApproval.addTarget(self, action: #selector(approval), for: .touchUpInside)
        btnFloatTask.addTarget(self, action: #selector(task), for: .touchUpInside)
        btnFloatStatus.addTarget(self, action: #selector(status), for: .touchUpInside)
        btnAutoApproval.addTarget(self, action: #selector(autoApproval), for: .touchUpInside)
        
        //MARK: tableview border styling
        tableBg.layer.cornerRadius = 10
        tableBg.layer.masksToBounds = true
        
        tableBg.layer.shadowColor = UIColor.lightGray.cgColor
        tableBg.layer.shadowOffset = CGSize(width: 0,height: 2.0)
        tableBg.layer.shadowRadius = 2.0
        tableBg.layer.shadowOpacity = 1.0
        tableBg.layer.masksToBounds = false;
        tableBg.layer.shadowPath = UIBezierPath(roundedRect:tableBg.bounds, cornerRadius:tableBg.layer.cornerRadius).cgPath
        
        
    }
    
    
    
    //MARK:  task collection view functions
    func taskData() {
        
        for i in 0...3 {
            
            let taskData = TaskData()
            
            taskData.dataTaskType = taskType[i]
            taskData.dataDetail = taskDescription[i]
            taskData.dataPriority = taskPriority[i]
            taskData.dataDueDate = taskDueDate[i]
            
            taskDataList.append(taskData)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let count = taskDataList.count
        
        if taskDataList.count < 3 {
            
            return count
            
        } else {
        
            return 3
            
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = taskCollectionView.dequeueReusableCell(withReuseIdentifier: taskCellIdentifier, for: indexPath as IndexPath) as! TaskCollectionViewCell
        
        var data = TaskData()
        
        data = taskDataList[indexPath.row]
        
        cell.taskTypeCell.text = data.dataTaskType
        cell.descriptionCell.text = data.dataDetail
        cell.dueDateCell.text = data.dataDueDate
        cell.priorityCell.image = data.dataPriority
        
        
        //cell customization corner radius
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = true
        
        //cell layer shadow settings
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.layer.cornerRadius).cgPath
        
        cell.btnMoreItemView.addTarget(self, action: #selector(showMoreTaskViewButton), for: .touchUpInside)
        cell.btnMoreItems.addTarget(self, action: #selector(showMoreTaskViewButton), for: .touchUpInside)

        // viewMoreitem faded
        
        cell.viewMoreItems.layer.cornerRadius = 10.0
        cell.viewMoreItems.layer.masksToBounds = true
     
        if indexPath.row < 2
        {
            cell.viewMoreItems.isHidden = true
        }
        
        cell.lblMoreItems.text = "\(taskDataList.count - 3) more tasks"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if taskDataList.count < 3 {
            
            showMoreTaskViewButton()

        }
    
    }
    
    
    //MARK: collectionView custom height
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: 120 , height: 150)
    
    }
    

    //MARK: approval tableView functions below
    
    func approvalData() {
        
        for i in 0...5 {
        
        let approvalData = ApprovalData()
        
        approvalData.approvalType = approvalType[i] + " - " + approvalDescription[i]
        approvalData.profileImage = image[i]
        approvalData.approvalDueDate = approvalDueDate[i]
        approvalData.priorityImage = approvalPriority[i]
            
        approvalDataList.append(approvalData)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = approvalTableView.dequeueReusableCell(withIdentifier: approvalCellIdentifier, for: indexPath as IndexPath) as! ApprovalCollectionViewCell
        
        var data = ApprovalData()
        
        data = approvalDataList[indexPath.row]
        
        cell.approvalType.text = data.approvalType
        cell.profileImage.image = data.profileImage
        cell.approvalDate.text = data.approvalDueDate
        cell.priorityImage.image = data.priorityImage
        
        //imageview circular
        cell.profileImage.layer.cornerRadius = (cell.profileImage.frame.width) / 2
        cell.profileImage.layer.masksToBounds = true
        
        //bottom separator removal
        if (indexPath.row == 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.frame.size.width, bottom: 0, right: 0)
        }
        
        return cell
        
    }
    
    func approvalTap() {
        let approvalTap = UITapGestureRecognizer(target: self, action: #selector(approvalTapped))
        approvalHeaderView.addGestureRecognizer(approvalTap)
    }
    
    @objc func approvalTapped(sender: UITapGestureRecognizer) {
        seeAllApprovalViewButton()
    }
    
    func taskTap() {
        let taskTap = UITapGestureRecognizer(target: self, action: #selector(taskTapped))
        taskHeaderView.addGestureRecognizer(taskTap)
    }
    
    @objc func taskTapped(sender: UITapGestureRecognizer) {
        showMoreTaskViewButton()
    }
    
    //MARK: objc function definations
    
    @objc func showMoreTaskViewButton()  {
        
        let taskView = self.storyboard?.instantiateViewController(withIdentifier: "TaskApprovalViewController") as! TaskApprovalViewController
        
        taskView.segmentControlIndex = 0
        
        self.navigationController?.pushViewController(taskView, animated: true)
        
    }
    
    @objc func seeAllApprovalViewButton()  {
        
        let approvalView = self.storyboard?.instantiateViewController(withIdentifier: "TaskApprovalViewController") as! TaskApprovalViewController
        
        approvalView.segmentControlIndex = 1
        
        self.navigationController?.pushViewController(approvalView, animated: true)
        
    }
    
    
    @objc func close() {
        floatingBtnView.isHidden = true
        viewFloatingButtonCover.isHidden = true
        viewFloatingButtonCoverTop.isHidden = true
        
    }
    
    @objc func approval() {
        floatingBtnView.isHidden = true
        viewFloatingButtonCover.isHidden = true
        viewFloatingButtonCoverTop.isHidden = true

        
        seeAllApprovalViewButton()
    }
    
    @objc func task() {
        floatingBtnView.isHidden = true
        viewFloatingButtonCover.isHidden = true
        viewFloatingButtonCoverTop.isHidden = true


        
        showMoreTaskViewButton()
    }
    
    @objc func autoApproval() {
        floatingBtnView.isHidden = true
        viewFloatingButtonCover.isHidden = true
        viewFloatingButtonCoverTop.isHidden = true


        
        let autoApprovalView = self.storyboard?.instantiateViewController(withIdentifier: "AutoApprovalViewController") as! AutoApprovalViewController
        
        self.navigationController?.pushViewController(autoApprovalView, animated: true)
    }
    
    @objc func status() {
        floatingBtnView.isHidden = true
        viewFloatingButtonCover.isHidden = true
        viewFloatingButtonCoverTop.isHidden = true


        let statusView = self.storyboard?.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
        
        self.navigationController?.pushViewController(statusView, animated: true)
    }
    
    //MARK: button definations
    
    @IBAction func homeTapped(_ sender: Any) {
        
      self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController")
        self.navigationController?.popViewController(animated: false)
        
    }
    
    
    @IBAction func menuTapped(_ sender: Any) {
    
        floatingBtnView.isHidden = false
        viewFloatingButtonCover.isHidden = false
        viewFloatingButtonCoverTop.isHidden = false

        
        }
    
    
    @IBAction func searchTapped(_ sender: Any) {
        
        let notificationView = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        self.navigationController?.pushViewController(notificationView, animated: false)
        
    }

    
    @IBAction func logoutTapped(_ sender: Any) {

        utilities.logoutAlert(controller: self)
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        
        let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        self.navigationController?.pushViewController(profileView, animated: true)
        
        
    }
    
    
    @IBAction func notificationTapped(_ sender: Any) {
        
        let notificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        
        self.navigationController?.pushViewController(notificationView, animated: false)
        
    }
    
    
}
