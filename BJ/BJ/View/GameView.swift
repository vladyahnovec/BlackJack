//
//  GameView.swift
//  BJ
//
//  Created by Круглич Влад on 28.06.24.
//

import SwiftUI

struct GameView: View {
    @StateObject var vm: ViewModel
    var body: some View {
        if vm.currentView == "HomeView" {
            ContentView()
            
        }
        else {
            VStack {
                ZStack {
                    Image("bg")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width + 1000, height: UIScreen.main.bounds.height + 100)
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                vm.currentView = "HomeView"
                                vm.myCards.removeAll()
                                vm.dilerCards.removeAll()
                                vm.myScore = 0
                                vm.dilerScore = 0
                                vm.stavka = "100"
                                vm.whoWin = ""
                                vm.checker = false
                                vm.dilerCard = ""
                            
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 530)
                        
                        HStack {
                            ForEach(vm.dilerCards, id: \.self) {
                                c in
                                Image("\(c)")
                                    .resizable()
                                    .frame(width: vm.dilerCards.count < 4 ? 80 : 60, height: vm.dilerCards.count < 4 ? 120 : 100)
                            }
                        }
                        Spacer()
                        HStack {
                            VStack {
                                Text("Дилер")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 25))
                                    .bold()
                                ZStack {
                                    Circle()
                                        .frame(width: 60)
                                        .opacity(0.5)
                                    Text("\(vm.dilerScore)")
                                        .foregroundStyle(.white)
                                        .bold()
                                        .font(.system(size: 30))
                                }
                            }
                            Spacer()
                            Image("rybashka")
                                .resizable()
                                .frame(width: 100, height: 140)
                            Spacer()
                            VStack {
                                Text("Игрок")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 25))
                                    .bold()
                                ZStack {
                                    Circle()
                                        .frame(width: 60)
                                        .opacity(0.5)
                                    Text("\(vm.myScore)")
                                        .foregroundStyle(.white)
                                        .bold()
                                        .font(.system(size: 30))
                                }
                            }
                        }
                        .padding(.horizontal, 530)
                        Spacer()
                        
                        HStack {
                            ForEach(vm.myCards, id: \.self) {
                                c in
                                Image("\(c)")
                                    .resizable()
                                    .frame(width: vm.myCards.count < 4 ? 80 : 60, height: vm.myCards.count < 4 ? 120 : 100)
                            }
                        }
                        
                        if vm.whoWin == "" {
                            Text("Ваша ставка: \(vm.stavka)")
                                .foregroundColor(.white)
                                .bold()
                                .font(.system(size: 20))
                                .padding(.vertical, 30)
                        }
                        else {
                            Text("\(vm.whoWin)")
                                .foregroundStyle(vm.whoWin == "Победа дилера! -\(vm.stavka)" ? .red : .green)
                                .font(.system(size: 25))
                                .bold()
                                .padding(.vertical, 30)
                        }
                        HStack {
                            Button(action: {
                                vm.checker = true
                                vm.giveCard(deck: &vm.dilerCards)
                                vm.giveScore(deck: vm.dilerCards, score: &vm.dilerScore)
                                vm.determineWinner()
                            }) {
                                Text("Хватит")
                                    .frame(width: 150, height: 50)
                                    .background(.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                    .bold()
                            }
                            .disabled(vm.whoWin != "")
                            Spacer()
                            Button(action: {
                                vm.count = "+" + vm.stavka
                                vm.giveCard(deck: &vm.myCards)
                                vm.giveScore(deck: vm.myCards, score: &vm.myScore)
                                if vm.myScore > 21 {
                                    vm.whoWin = "Победа дилера!!!!!! -\(vm.stavka)"
                                    vm.bank = String((Int(vm.bank) ?? 0) - (Int(vm.stavka) ?? 0))
                                    vm.count = "-" + vm.stavka
                                }
                            }) {
                                Text("Взять")
                                    .frame(width: 150, height: 50)
                                    .background(.white)
                                    .foregroundColor(.green)
                                    .cornerRadius(20)
                                    .bold()
                            }
                            .disabled(vm.myScore > 21 || vm.whoWin != "")
                        }
                        .padding(.horizontal, 530)
                        Spacer()
                        
                    }
                }
            }
        }
    }
}
