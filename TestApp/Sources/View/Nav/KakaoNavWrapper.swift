//
//  TestNavView.swift
//  TestApp
//
//  Created by 강창현 on 2023/08/29.
//

import SwiftUI
import KNSDKBundle

struct KakoNavWrapper: UIViewRepresentable {

    func makeCoordinator() -> NaviCoordinator {
        NaviCoordinator.shared
    }
    
    func makeUIView(context: Context) -> some UIView {
        
        context.coordinator.getKakaoNaiView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // 업데이트가 필요한 경우에 사용
        // 예: 위치 업데이트, 경로 변경 등
    }
}

final class NaviCoordinator: NSObject, ObservableObject, KNSDKDelegate, KNGuidance_GuideStateDelegate, KNGuidance_RouteGuideDelegate, KNGuidance_VoiceGuideDelegate, KNGuidance_SafetyGuideDelegate, KNGuidance_LocationGuideDelegate, KNGuidance_CitsGuideDelegate, KNNaviView_StateDelegate, KNNaviView_GuideStateDelegate {
    
    static let shared = NaviCoordinator()
    // 카카오내비 관련 변수들
//    var startDest: String = ""
//    var startX: CGFloat = 0.0
//    var startY: CGFloat = 0.0
//    var endDest: String = ""
//    var endX: CGFloat = 0.0
//    var endY: CGFloat = 0.0
//    var startAddress: String = ""
//    var endAddress: String = ""
    @ObservedObject var coordinator = Coordinator.shared
    var view = KNNaviView()
    var guidance = KNGuidance()
    // 카카오내비 설정 및 뷰 설정
    override init() {
        super.init()
        guidance.guideStateDelegate = self
        guidance.routeGuideDelegate = self
        guidance.voiceGuideDelegate = self
        guidance.safetyGuideDelegate = self
        guidance.locationGuideDelegate = self
        guidance.citsGuideDelegate = self
        view.stateDelegate = self
        view.guideStateDelegate = self
    }
    
    func getKakaoNaiView() -> KNNaviView {
        return view
    }
    
    deinit {
        print("Coordinator deinit!")
    }
    
    func startNavigate() {
        let startPos = KNSDK.sharedInstance()?.convertWGS84ToKATEC(withLongitude: coordinator.userLocation.1, latitude: coordinator.userLocation.0)
        let goalPos = KNSDK.sharedInstance()?.convertWGS84ToKATEC(withLongitude: coordinator.destination.1, latitude: coordinator.destination.0)
        // KNNaviView 초기화 및 설정
        KNSDK.sharedInstance()?.initialize(withAppKey: "923b28d9b3a43a58017321fb76583ace", clientVersion: "1.0", completion: { [self] error in
            if let error = error {
                print("KNSDK Init Failed(\(error.code), \(error.msg))")
            } else {
                let startPos = KNSDK.sharedInstance()?.convertWGS84ToKATEC(withLongitude: coordinator.userLocation.1, latitude: coordinator.userLocation.0)
                let goalPos = KNSDK.sharedInstance()?.convertWGS84ToKATEC(withLongitude: coordinator.destination.1, latitude: coordinator.destination.0)
                let start = KNPOI(name: coordinator.currentAddress[1], pos: startPos ?? IntPoint(), address: coordinator.currentAddress[1])
                let goal = KNPOI(name: coordinator.address, pos: goalPos ?? IntPoint())
                
                print(start, goal)
                // 경로 생성 및 요청
                KNSDK.sharedInstance()?.makeTrip(withStart: start, goal: goal, vias: []) { error, trip in
                    if let error = error {
                        print("Generation Failed(\(String(describing: error.code)), \(String(describing: error.msg)))")
                    } else {
                        print("Generation 성공")
                        trip?.route(with: KNRoutePriority.recommand, avoidOptions: KNRouteAvoidOption.none.rawValue, completion: { [self]  error, routes in
                            if let error = error {
                                print("Request Failed(\(error.code), \(error.msg))")
                            } else {
                                print("Request 성공")
                                KNSDK.sharedInstance()?.sharedGuidance()
                                if let route = routes?.first {
                                    view = KNNaviView(guidance: self.guidance, trip: trip, routeOption: .recommand, avoidOption: .zero)
                                }
                            }
                        })
                    }
                }
            }
        })
    }
    
    // MARK: - KNGuidance_GuideStateDelegate
    // 길 안내 시작 시 호출
    func guidanceGuideStarted(_ aGuidance: KNGuidance) {
        
    }
    
    // 경로 변경 시 호출. 교통 변화 또는 경로 이탈로 인한 재탐색 및 사용자 재탐색 시 전달
    func guidanceCheckingRouteChange(_ aGuidance: KNGuidance) {
        
    }
    
    // 경로에서 이탈한 뒤 새로운 경로를 요청할 때 호출
    func guidanceOut(ofRoute aGuidance: KNGuidance) {
        
    }
    
    // 수신 받은 새 경로가 기존의 안내된 경로와 동일할 경우 호출
    func guidanceRouteUnchanged(_ aGuidance: KNGuidance) {
        
    }
    
    // 경로에 오류가 발생 시 호출
    func guidance(_ aGuidance: KNGuidance, routeUnchangedWithError aError: KNError) {
        
    }
    
    // 수신 받은 새 경로가 기존의 안내된 경로와 다를 경우 호출. 여러 개의 경로가 있을 경우 첫 번째 경로를 주행 경로로 사용하고 나머지는 대안 경로로 설정됨
    func guidanceRouteChanged(_ aGuidance: KNGuidance) {
        
    }
    
    // 길 안내 종료 시 호출
    func guidanceGuideEnded(_ aGuidance: KNGuidance) {
        
    }
    
    // 주행 중 기타 요인들로 인해 경로가 변경되었을 때 호출
    func guidance(_ aGuidance: KNGuidance, didUpdate aRoutes: [KNRoute], multiRouteInfo aMultiRouteInfo: KNMultiRouteInfo?) {
        
    }
    
    // MARK: - KNGuidance_LocationGuideDelegate
    // 위치 정보가 변경될 경우 호출. `aLocationGuide`의 항목이 1개 이상 변경 시 전달됨.
    func guidance(_ aGuidance: KNGuidance, didUpdate aLocationGuide: KNGuide_Location) {
        
    }
    
    // MARK: - KNGuidance_RouteGuideDelegate
    // 경로 안내 정보 업데이트 시 호출. `aRouteGuide`의 항목이 1개 이상 변경 시 전달됨.
    func guidance(_ aGuidance: KNGuidance, didUpdateRouteGuide aRouteGuide: KNGuide_Route) {
        
    }
    
    // MARK: - KNGuidance_SafetyGuideDelegate
    // 안전 운행 정보 업데이트 시 호출. `aSafetyGuide`의 항목이 1개 이상 변경 시 전달됨.
    func guidance(_ aGuidance: KNGuidance, didUpdateSafetyGuide aSafetyGuide: KNGuide_Safety) {
        
    }
    
    // 주변의 안전 운행 정보 업데이트 시 호출
    func guidance(_ aGuidance: KNGuidance, didUpdateAroundSafeties aSafeties: [KNSafety]?) {
        
    }
    
    // MARK: - KNGuidance_VoiceGuideDelegate
    // 음성 안내 사용 여부
    func guidance(_ aGuidance: KNGuidance, shouldPlayVoiceGuide aVoiceGuide: KNGuide_Voice, replaceSndData aNewData: AutoreleasingUnsafeMutablePointer<NSData?>!) -> Bool {
        return true
    }
    
    // 음성 안내 시작
    func guidance(_ aGuidance: KNGuidance, willPlayVoiceGuide aVoiceGuide: KNGuide_Voice) {
        
    }
    
    // 음성 안내 종료
    func guidance(_ aGuidance: KNGuidance, didFinishPlayVoiceGuide aVoiceGuide: KNGuide_Voice) {
        
    }
    
    // MARK: - KNGuidance_CitsGuideDelegate
    // C-ITS 정보 변경 시 호출
    func guidance(_ aGuidance: KNGuidance, didUpdateCitsGuide aCitsGuide: KNGuide_Cits) {
        
    }
    
    // MARK: - KNSDKDelegate
    func knsdkFoundUnfinishedTrip(_ aTrip: KNTrip, priority aPriority: KNRoutePriority, avoidOptios aAvoidOptions: Int32) {
        
    }
    
    func knsdkNeedsLocationAuthorization() {
        
    }
    
    func naviViewGuideEnded(_ aNaviView: KNNaviView) {
        
    }
    
    func naviViewGuideState(_ aGuideState: KNGuideState) {
        
    }
    
    func naviViewDidUpdateSndVolume(_ aVolume: Float) {
        
    }
    
    func naviViewDidUpdateUseDarkMode(_ aDarkMode: Bool) {
        
    }
    
    func naviViewDidUpdateMapCameraMode(_ aMapViewCameraMode: MapViewCameraMode) {
        
    }
    
    func naviViewDidMenuItem(withId aId: Int32, toggle aToggle: Bool) {
        
    }
    
    func naviViewScreenState(_ aKNNaviViewState: KNNaviViewState) {
        
    }
    
    func naviViewPopupOpenCheck(_ aOpen: Bool) {
        
    }
    
    
    // MARK: - KNTrip_GuidanceExtension
//    func remainDist() -> Int32 {
//
//    }
//
//    func remainTime() -> Int32 {
//
//    }
//
//    func remainCost() -> Int32 {
//
//    }
//
//    func elapsedDist() -> Int32 {
//
//    }
//
//    func elapsedTime() -> Int32 {
//
//    }
//
//    func elapsedCost() -> Int32 {
//
//    }
//
//    func passedVias() -> [KNPOI]? {
//
//    }
}