//
//  ContentView.swift
//  Player_carDealership_MVVM
//

import SwiftUI

struct CarDealershipContentView: View {
    
    enum Constants {
        static var titleTelegtam = "Telegtam"
        static var nameTelegramLogo = "telegramLogo"
        static var titleMessageTest = "message test"
        static var title = "message test"
        static var titleInfoAuto = "Информация об автомобиле"
        static var titleEngine = "Двигатель"
        static var titleEngineDisplacement = "1.6 Turbo"
        static var titleActuator = "Привод"
        static var titleAWD = "AWD"
        static var titleEquipment = "Комплектация"
        static var titleJoy = "Joy"
        static var titleLifestyle = "Lifestyle"
        static var titleUltimate = "Ultimate"
        static var titleActive = "Active"
        static var titleSupreme = "Supreme"
        static var titleInsurance = "ОМОДА Каско"
        static var titleInsuranceIssue = "Подключить Каско на выгодных условиях?"
        static var titleInsuranceRejection = "Нет, не нужно"
        static var titleСoncordance = "Да"
        static var titlePrice = "Цена"
        static var titleOrder = "Заказать"
        static var titleAfterOrdering = "Благодарим за заказ. Наш менеджер свяжется с Вами в рабочее время для уточнения"
        static var titleFormat = "%.2f руб."
    }
    
    @ObservedObject var viewModel = AutomobileViewModel()
    @State private var segmentIndex = 0
    @State private var offSetX = 0
    @State private var progress: Float = 0
    @State private var isSharePresented = false
    @State private var isShowingActionSheet = false
    @State private var isOnToggle = false
    @State private var isOnAlert = false
    
    private var modelAuto = ["C5", "S5", "S5GT"]
    private var nameAuto = ["omodaС5", "omodaS5", "omodaS5GT"]
    private let step: Double = 1.25
    private let customActivity = ActivityViewCustonActivity(title: Constants.titleTelegtam, imageName: Constants.nameTelegramLogo) {}
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                headerView
                carСhoiceView
                Spacer()
            }
            .animation(.interactiveSpring)
            ZStack {
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(width: geometry.size.width, height: 500)
                    autoInfoView
                    .padding()
                }
            }
        }
        .background(Color.basicBackground)
    }
    
    var headerView: some View {
        HStack {
            Spacer().frame(width: 150)
            Image(.omodaLogo)
            Spacer()
            Button(action: {
                isSharePresented.toggle()
            }) {
                Image(.shareIcon)
                    .padding()
            }
            .sheet(isPresented: $isSharePresented, content: {
                ActivityView(activityItems: [Constants.titleMessageTest], applicationActivities: [customActivity])
            })
        }
    }
    
    var carСhoiceView: some View {
        VStack {
            Image(nameAuto[segmentIndex])
                .resizable()
                .frame(width: 345, height: 198)
                .offset(x: CGFloat(offSetX))
            Picker(selection: Binding(get: {
                segmentIndex
            }, set: { newValue in
                segmentIndex = newValue
                offSetX = -500
                moveBack()
            }), label: Text("")) {
                ForEach(0..<modelAuto.count, id: \.self) {
                    Text(modelAuto[$0]).tag($0)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
    
    var autoInfoView: some View {
        VStack {
            HStack {
                Spacer()
                Text(Constants.titleInfoAuto)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            Spacer()
            HStack {
                Text(Constants.titleEngine)
                Spacer()
                Text(Constants.titleEngineDisplacement)
            }
            Spacer()
            Divider().frame(width: 250)
            HStack {
                Text(Constants.titleActuator)
                Spacer()
                Text(Constants.titleAWD)
            }
            Spacer()
            Divider().frame(width: 250)
            HStack {
                Text(Constants.titleEquipment)
                Spacer()
            }
            Slider(value: Binding(get: {
                progress
            }, set: { newValue in
                let value = (Double(newValue) / step).rounded() * step
                let priceChange = (value - Double(progress)) * 190_000
                viewModel.prices[segmentIndex].value += Double(priceChange)
                progress = Float(value)
            }), in: 0...5, step: 1)
            Spacer()
            HStack {
                Text(Constants.titleJoy)
                Spacer()
                Text(Constants.titleLifestyle)
                Spacer()
                Text(Constants.titleUltimate)
                Spacer()
                Text(Constants.titleActive)
                Spacer()
                Text(Constants.titleSupreme)
            }
            HStack {
                Toggle(isOn: Binding(get: {
                    isOnToggle
                }, set: { newValue in
                    isOnToggle = newValue
                    if newValue {
                        isOnAlert = newValue
                    } else {
                        viewModel.prices[segmentIndex].value -= 99_000
                    }
                })) {
                    Text(Constants.titleInsurance)
                }
                .alert(isPresented: $isOnAlert, content: {
                    Alert(title: Text(Constants.titleInsurance), message: Text(Constants.titleInsuranceIssue), primaryButton: .default(Text(Constants.titleInsuranceRejection),action: {
                        isOnToggle = false
                    }), secondaryButton: .default(Text(Constants.titleСoncordance), action: {
                        viewModel.prices[segmentIndex].value += 99_000
                    }))
                })
            }
            Spacer()
            Divider().frame(width: 250)
            HStack {
                Text(Constants.titlePrice)
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Text(String(format: Constants.titleFormat, (viewModel.prices[segmentIndex].value) / 100).replacingOccurrences(of: ".", with: ""))
                    .font(.system(size: 22, weight: .bold))
            }
            .padding()
            Spacer()
            Button(action: {
                isShowingActionSheet.toggle()
            }) {
                Text(Constants.titleOrder)
                    .frame(width: 360, height: 50)
                    .background(Color.basicBackground)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .actionSheet(isPresented: $isShowingActionSheet) {
                ActionSheet(title: Text(Constants.titleAfterOrdering))
            }
        }
    }
    
    private func moveBack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            offSetX = 0
        }
    }
}

#Preview {
    CarDealershipContentView()
}
