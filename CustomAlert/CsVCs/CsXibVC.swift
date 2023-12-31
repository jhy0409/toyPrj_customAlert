//
//  CsXibVC.swift
//  CustomAlert
//
//  Created by inooph on 2023/08/24.
//

import UIKit

class CsXibVC: useDimBgVC, PrBtnLayout {
    
    // MARK: ------------------- IBOutlets -------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var ctTop: NSLayoutConstraint!
    @IBOutlet weak var ctBtm: NSLayoutConstraint!
    
    @IBOutlet weak var contV_titMsgHeight: NSLayoutConstraint!
    @IBOutlet weak var contV_WidthRatio: NSLayoutConstraint!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tvHeight: NSLayoutConstraint!
    
    
    // MARK: ------------------- Variables -------------------
    var isDefPair: btnLayout = .withinZroIdx
    var btnTitleArr: [String] = []
    
    var titMsgViewFull: CGFloat = 1.0
    var titMsgViewMax: CGFloat = 0.6
    
    lazy var csXViewNums: CsViewNums = .init(csWidthRatio: 0.8,
                                             defMrgVerti: view.frame.height * 0.05,
                                             tblDefRatio: tblHeightVal == 0 ? titMsgViewFull : titMsgViewMax)
    
    /// 상하 마진
    var defMrgVti: CGFloat {
        return (csXViewNums.defMrgVerti * 2) 
    }
    
    var viewHeight: CGFloat {
        return view.frame.height - defMrgVti
    }
    
    var mxHeight: CGFloat {
        return viewHeight * csXViewNums.tblDefRatio
    }
    
    var mnHeight: CGFloat {
        if lblMsgMaxY + tblHeightVal > viewHeight {
            let btmRt = topHgt/viewHeight > 1 ? (1.0 - csXViewNums.tblDefRatio) : 1 - (topHgt/viewHeight)
            return viewHeight * btmRt
            
        } else {
            return viewHeight * (1.0 - csXViewNums.tblDefRatio)
        }
    }
    
    var lblMsgMaxY: CGFloat {
        return lblMsg.frame.maxY
    }
    
    /// 상단 높이
    var topHgt: CGFloat {
        return lblMsgMaxY > mxHeight ? mxHeight : lblMsgMaxY
    }
    
    var artTp: (title: String, msg: String) = ("", "")
    
    
    // MARK: ------------------- View Life Cycle -------------------
    deinit {
        print("--> csXibVc 메모리 해제")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if (tblHeightVal + topHgt) > viewHeight {
            // 테이블뷰 높이 먼저
            let tblHgt = (viewHeight - topHgt) - tblHeightVal < 0 ? mnHeight : tblHeightVal

            tvHeight.constant = tblHgt
            contV_titMsgHeight.constant = topHgt
            
        } else {
            contV_titMsgHeight.constant = lblMsgMaxY
            tvHeight.constant = tblHeightVal
        }
    }
    
    override func setView(fcn: String = #function, lne: Int = #line, spot: String = #fileID) {
        super.setView(fcn: fcn, lne: lne, spot: spot)
        
        let newConst = contV_WidthRatio.setConstMultiplier(csXViewNums.csWidthRatio)
        view.removeConstraint(contV_WidthRatio)
        view.addConstraint(newConst)
        view.layoutIfNeeded()
        contV_WidthRatio = newConst
        
        ctTop.constant = csXViewNums.defMrgVerti
        ctBtm.constant = csXViewNums.defMrgVerti
        
        lblTitle.text   = artTp.title
        lblMsg.text     = artTp.msg
        
        [lblTitle, lblMsg].forEach {
            if let lbl = $0 {
                lbl.frame.size = lbl.sizeThatFits(lbl.frame.size)
            }
        }
        
        let lineView: UIView = .init()
        lineView.backgroundColor = .systemGray5
        view.addSubview(lineView)

        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: tblView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: tblView.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: tblView.topAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        lineView.isHidden = btnTitleArr.count < 1
        tblView.separatorInset = .zero
    }
    
    
    // MARK: ------------------- IBAction functions -------------------
    @objc func cellTabAct(_ sender: UIButton) {
        print("--> cellTabAct tag = \(sender.tag) / csXibVC\n")
        dismiss(animated: true)
    }
    
    // MARK: ------------------- function -------------------
}

// MARK: ------------------- tableView -------------------
extension CsXibVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return calcCnt
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return defCellHgt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CsXibTvc", for: indexPath) as! CsXibTvc
        cell.tag                = indexPath.row
        cell.isLast             = cell.tag == (btnTitleArr.count - 1)
        cell.isDefPair          = isDefPair
        
        cell.csXibVC            = self
        
        let idxArr = getBtnIdxs(row: indexPath.row, calc: calcCnt, total: btnTitleArr.count)
        
        cell.setView(btnIdxs: idxArr)
        
        return cell
    }
}

// MARK: ------------------- cell class -------------------
class CsXibTvc: CommonTvc {
    @IBOutlet var btnTitles: [UIButton]!
    
    var isDefPair: btnLayout = .withinZroIdx
    var isLast: Bool = false
    
    let lineView: UIView = .init()
    
    weak var csXibVC: CsXibVC?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setView(fcn: String = #function, lne: Int = #line, spot: String = #fileID) {
        super.setView(fcn: fcn, lne: lne, spot: spot)
    }
    
    func setView(btnIdxs: (prv: Int?, nxt: Int?)?) {
        setView()
        
        let btnBgCol: UIColor   = .clear
        let prevCol: UIColor    = .clear, nxtCol: UIColor = .clear
        
        for i in 0..<btnTitles.count {
            // 초기화
            btnTitles[i].setTitle("", for: .normal)
            
            // 버튼 정렬 분기
            switch isDefPair {
                
            case .withinZroIdx, .evenRng:
                if let idxs = btnIdxs {
                    switch i {
                    case 0:
                        if let first = idxs.prv {
                            btnTitles[i].tag = first
                            btnTitles[i].backgroundColor = prevCol
                            
                            btnTitles[i].setTitle(String(describing: first), for: .normal)
                        }
                        
                    case 1:
                        if let second = idxs.nxt {
                            btnTitles[i].tag = second
                            btnTitles[i].backgroundColor = nxtCol
                            
                            btnTitles[i].setTitle(String(describing: second), for: .normal)
                        }
                        
                        btnTitles[i].isHidden = idxs.nxt == nil
                        
                    default: break
                    }
                }
                
            case .fullSize:
                btnTitles[i].setTitle(String(describing: tag), for: .normal)
                btnTitles[i].backgroundColor = btnBgCol
                btnTitles[i].isHidden = i > 0
            }
            
            btnTitles[i].addTarget(csXibVC, action: #selector(csXibVC?.cellTabAct(_:)), for: .touchUpInside)
        }
        
        addSubview(lineView)
        lineView.backgroundColor = .systemGray5
        lineView.isHidden = btnTitles[1].isHidden
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: btnTitles[1].leadingAnchor, constant: 0.5),
            lineView.topAnchor.constraint(equalTo: btnTitles[1].topAnchor),
            lineView.bottomAnchor.constraint(equalTo: btnTitles[1].bottomAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
}


// MARK: ------------------- struct & enum -------------------
struct CsViewNums {
    /// superView 대비 뷰 너비 비율
    var csWidthRatio: CGFloat
    
    /// 기본 컨테이너 뷰 상하 마진
    var defMrgVerti: CGFloat
    
    var tblDefRatio: CGFloat
}

enum btnLayout: String {
    /**
     index 0번째만 두 칸 사용
     
     1. 0, 1, 2
     
     2. index
     - 0 : 0, 1
     - 1 : 2 ...
     */
    case withinZroIdx = "iOS기본 스타일"
    
    /// 짝수는 두 칸, 남은 인덱스가 홀수일 경우 한 칸
    case evenRng = "바둑판 배열"
    
    /// 셀 가득 채우기
    case fullSize = "채우기"
}


protocol PrBtnLayout {
    var isDefPair: btnLayout { get set }
    var btnTitleArr: [String] { get set }
    
    var calcCnt: Int { get }
    
    var artTp: (title: String, msg: String) { get set }
    
    var defViewWidthRatio: CGFloat { get set }
    var defCellHgt: CGFloat { get set }
    var tblHeightVal: CGFloat { get }
    
    var titMsgViewFull: CGFloat { get set }
    var titMsgViewMax: CGFloat { get set }
    
    
    var defMrgVerti: CGFloat { get set }
    var csXViewNums: CsViewNums { get }
    
    func getBtnIdxs(row: Int, calc: Int, total: Int) -> (prv: Int?, nxt: Int?)?
}

extension PrBtnLayout {
    
    var calcCnt: Int {
        let cnt = btnTitleArr.count
        switch isDefPair {

        case .withinZroIdx:
            switch btnTitleArr.count {
            case 0: return 0
            case 1...2: return 1
            default: return cnt
            }
            
        case .evenRng:
            return (btnTitleArr.count / 2) + (cnt % 2 == 0 ? 0 : 1)
            
        case .fullSize:
            return cnt
        }
    }
    
    var defViewWidthRatio: CGFloat {
        get { return 0.8 }
        set { defViewWidthRatio = newValue }
    }
    
    var defCellHgt: CGFloat {
        get { return 50 }
        set { defCellHgt = newValue }
    }
    
    var tblHeightVal: CGFloat {
        return CGFloat(calcCnt) * defCellHgt
    }
    
    var defMrgVerti: CGFloat {
        get { return 0.1 }
        set { defMrgVerti = newValue }
    }
    
    var csXViewNums: CsViewNums {
        get {
            return .init(csWidthRatio: defViewWidthRatio,
                         defMrgVerti: defMrgVerti,
                         tblDefRatio: tblHeightVal == 0 ? titMsgViewFull : titMsgViewMax)
        }
    }
    
    /**
     - total    : 0, 1, 2
     - calc     : 0, 1
     - row      : 0, 1
  
     1. withinZroIdx
        1. 2개까지는 0번째 [0, 1] 정렬
        2. 2개 초과시 fullSize 사용
     
     2. evenRange : 버튼개수가 짝수일 때는 [n, n+1], 홀수인 줄에서는 [n]으로 표시
         - 0 - 0, 1
         - 1 - 2, 3
         - 2 - 4, 5
         - 3 - 6
     
     3. fullSize : 버튼영역 전체 채우기
     */
    func getBtnIdxs(row: Int, calc: Int, total: Int) -> (prv: Int?, nxt: Int?)? {
        print("\n--> row = \(row) /  calc = \(calc) /  total = \(total)")
        
        var res: (prv: Int?, nxt: Int?) = (nil, nil)
        
        switch isDefPair {
        case .withinZroIdx:
            switch total {
            case 0: break
                
            case 1: // 0
                res = (prv: total - 1, nxt: nil)
                
            case 2: // 0, 1
                res = (prv: total - 2, nxt: total - 1)
                
            default:
                switch total {
                case 0: break
                case 1: res = (total - 1, nil)
                case 2: res = (total - 2, total - 1)
                default: res = (row, nil)
                }
            }
       
        case .evenRng:
            switch total {
            case 0: break
            case 1:
                res = (total - 1, nil)
                
            default:
                let prvIx: Int  = 2 * row
                let nxtIx: Int? = (prvIx + 1) > (total - 1) ? nil : (prvIx + 1)
                res = (prvIx, nxtIx)
            }
            
        case .fullSize: return nil
        }
        
        print("\(res)")
        
        return res
    }
}

