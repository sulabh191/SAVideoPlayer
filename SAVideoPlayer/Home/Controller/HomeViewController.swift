//
//  HomeViewController.swift
//  VideoAnalytics
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variable declarations
    var homeEventHandler : HomeUIInterface!
    var videoList: [VideoModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView()
        addNavigationBarButton()
        
        homeEventHandler.getVideoList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNavigationBarButton() {
        
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("Custom", for: .normal)
        //btn1.setImage(UIImage(named: "imagename"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        btn1.addTarget(self, action: #selector(HomeViewController.logOutTapped), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
    }

    
    func configureTableView() {
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        
        tableView.register(UINib(nibName: "VideoListTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoListTableViewCell")
    }

    func videoListTableViewCellAtIndexPath(_ indexPath: IndexPath) -> VideoListTableViewCell {
        
        
        let videoListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoListTableViewCell") as! VideoListTableViewCell
        if let videoData = videoList?[indexPath.row] {
            videoListTableViewCell.setVideoListData(_videoData: videoData)
        }
        return videoListTableViewCell
    }

    func logOutTapped() {
        
    }

}

extension HomeViewController : HomeUI {
    
    func videoListFetchedSuccessfully(_ videoList: [VideoModel]) {
        
        self.videoList = videoList
        self.tableView.reloadData()
    }
}

extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    //MARK: UITableView Delegates and data source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = self.videoList?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {

        return videoListTableViewCellAtIndexPath(indexPath)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let videoData = videoList?[indexPath.row] {
            homeEventHandler.handleNext(videoData: videoData)
        }
    }
}
