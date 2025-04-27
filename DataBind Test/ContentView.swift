//
//  ContentView.swift
//  DataBind Test
//
//  Created by Afeez Yunus on 27/04/2025.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @StateObject var chartView = ChartView.shared.chartView
    @State var meterName = "Hohoho"
    @State var meterValue:Float = 50
    @State var meterColour:Color = .blue
    var body: some View {
        VStack {
            chartView.view()
                .frame(width: 300, height: 300)
            VStack{
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .background(Color.gray)
            .onTapGesture {
                meterName = "It's changed now"
                meterValue = 11
                meterColour = Color("Testt")
                changeBoundObjects()
                print(meterName)
            }
        }
        .padding()
        .onAppear{
            changeBoundObjects()
        }
    }
    func changeBoundObjects() {
            //the next syntax can be broken in two, but linking it all on one syntax works just fine if you want to directly name the Viewmodels, which is the approach I'd be taking henceforth
            let chartViewModel = chartView.riveModel!.riveFile.viewModelNamed("Chart VM")!
            // now let's call the instance
            // Create and store the instance as a property
            let chartInstance = chartViewModel.createInstance(fromName: "Speed Instance")
            
            // let's bind the instances to the stateMachine
            if let chartInstance = chartInstance {
                chartView.riveModel?.stateMachine?.bind(viewModelInstance: chartInstance)
            }
            let speedRawName = chartInstance?.stringProperty(fromPath: "Chart name")
            speedRawName?.value = meterName
            
            let speedRawValue = chartInstance?.numberProperty(fromPath: "trim value")
            speedRawValue?.value = meterValue
            
        let speedRawColour = chartInstance?.colorProperty(fromPath: "Name colour")
        speedRawColour?.value = UIColor(meterColour)
        
        //changes won't reflect without advancing the statemachine
        chartView.triggerInput("advance")
            
       // print("the name is \(speedRawName.value)")
            
    }
}

#Preview {
    ContentView()
}

class ChartView: ObservableObject {
    static let shared = ChartView()
    @Published var chartView: RiveViewModel!
    init () {
        chartView = RiveViewModel(fileName: "chart", stateMachineName: "State Machine 1")
    }
}
