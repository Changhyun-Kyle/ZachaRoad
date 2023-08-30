//
//  MapBottomSheet.swift
//  TestApp
//
//  Created by 강창현 on 2023/08/26.
//

import SwiftUI

struct MapBottomSheet: View {
    
    @ObservedObject var mainViewModel: MainViewModel
    @StateObject var drivingInfoViewModel = DrivingInfoViewModel()
    @StateObject var coordinator: Coordinator = Coordinator.shared
    //@StateObject var mainViewModel: MainViewModel
    
    var address: String
    var currentAddress: String
    let currentDate: Date = Date()
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let currentTime = formatter.string(from: currentDate)
        return currentTime
    }
    
    var body: some View {
        ZStack {
            Color(UIColor(.paneColor))
            VStack(spacing: 0) {
                HStack {
                    Image("StartMapMarker")
                        .padding(.trailing, -10)
                    Text("현위치:")
                        .bold()
                    Text("\(currentAddress)")
                    Spacer()
                }
                
                HStack {
                    Image("EndMapMarker")
                        .padding(.trailing, -10)
                    Text("목적지:")
                        .bold()
                    Text("\(address)")
                    Spacer()
                }
                
                HStack {
                    CustomButton {
                        mainViewModel.active = true
                        mainViewModel.startAddress = coordinator.currentAddress[1]
                        Task {
                            let id = UUID().uuidString
                            await drivingInfoViewModel.saveStartDrivingInfo(drivingInfo: DrivingInfo(id: id, startAddress: coordinator.currentAddress[1], startTime: currentTime, endAddress: "", endTime: "", fuelFee: 0, tollFee: 0, depreciation: 0))
                            drivingInfoViewModel.recentRef = id
                        }
                    } content: {
                        Text("안내시작")
                    }
                }
                Spacer()
            }
            .font(.title3)
            .padding(10)
            .alert(
                "주행종료",
                isPresented: $drivingInfoViewModel.showAlert
            ) {
                Button {
                    let endAddress: String = coordinator.currentAddress[1]
                    Task {
                        await drivingInfoViewModel.saveEndDrivingInfo(["endAddress":endAddress])
                    }
                } label: {
                    Text("확인")
                }
            } message: {
                Text("주행이 완료되었습니다")
            }
            
        }
        .cornerRadius(10)
        .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .leading)
        
    }
}

struct MapBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.systemGray)
            MapBottomSheet(mainViewModel: MainViewModel(), address: "Test", currentAddress: "Test")
        }
        
    }
}
