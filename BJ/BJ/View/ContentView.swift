import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject private var vm = ViewModel()
    @State var sortOrder: SortOrder = .ascending

    
    enum SortOrder {
        case ascending, descending, minus, plus
    }
    
    var body: some View {
        VStack {
            if vm.currentView == "HomeView" {
                ZStack {
                    Image("bg")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width + 1000, height: UIScreen.main.bounds.height + 100)
                    
                    VStack {
                        HStack {
                            Button(action: {
                                sortOrder = .ascending
                            }) {
                                Text("Сначала старые")
                                    .foregroundColor(.white)
                                    .padding()
                                    .border(.white, width: 1)
                            }
                            
                            Button(action: {
                                sortOrder = .descending
                            }) {
                                Text("Сначала новые")
                                    .foregroundColor(.white)
                                    .padding()
                                    .border(.white, width: 1)
                            }
                        }
                        HStack {
                            Button(action: {
                                sortOrder = .minus
                            }) {
                                Text("Положительные")
                                    .foregroundColor(.green)
                                    .padding()
                                    .border(.green, width: 1)
                            }
                            
                            Button(action: {
                                sortOrder = .plus
                            }) {
                                Text("Отрицательные")
                                    .foregroundColor(.red)
                                    .padding()
                                    .border(.red, width: 1)
                            }
                        }
                        
                        List {
                            ForEach(sortedItems) { item in
                                HStack {
                                    Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                                    Spacer()
                                    Text(item.bank)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 50, height: 300)
                        .cornerRadius(20)
                        Button(action: {
                            saveHistoryToFile()
                        }) {
                            Text("Сохранить историю")
                                .foregroundColor(.white)
                                .frame(width: 170, height: 40)
                                .font(.system(size: 15))
                                .border(.blue, width: 2)
                        }
                        HStack {
                            Text("Банк: \(vm.bank)$")
                                .foregroundColor(.white)
                                .bold()
                            Spacer()
                            HStack {
                                Text("Ставка:")
                                    .foregroundColor(.white)
                                    .bold()
                                TextField("0", text: $vm.stavka)
                                    .frame(width: 50, height: 30)
                                    .padding(.horizontal, 10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 530)
                        .font(.system(size: 20))
                        .padding(.top, 50)
                        
                        
                        Button(action: {
                            vm.currentView = "GameView"
                            vm.count = ""
                            vm.giveCards(deck: &vm.myCards, otherDeck: vm.dilerCards, cd: nil)
                            vm.giveScore(deck: vm.myCards, score: &vm.myScore)
                            vm.giveCards(deck: &vm.dilerCards, otherDeck: vm.myCards, cd: "dilerCard")
                            vm.giveScore(deck: vm.dilerCards, score: &vm.dilerScore)
                        }) {
                            Text("Сделать ставку")
                                .foregroundColor(.white)
                                .frame(width: 200, height: 60)
                                .background(Color.green)
                                .cornerRadius(20)
                                .bold()
                                .font(.system(size: 20))
                        }
                        .padding(.top, 50)
                    }
                }
                .onAppear {
                    if vm.count != "" {
                        addItem()
                    }
                }

            } else if vm.currentView == "GameView" {
                GameView(vm: vm)
            } else {
                Text("Загрузка...")
            }
        }
    }
    
    private var sortedItems: [Item] {
        switch sortOrder {
        case .ascending:
            return items.sorted { $0.timestamp < $1.timestamp }
        case .descending:
            return items.sorted { $0.timestamp > $1.timestamp }
        case .minus:
            return items.sorted { $0.bank < $1.bank }
        case .plus:
            return items.sorted { $0.bank > $1.bank }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date(), bank: vm.count)
            modelContext.insert(newItem)
        }
    }
    
    private func saveHistoryToFile() {
          let fileName = "history.txt"
          let fileManager = FileManager.default
          
          guard let desktopURL = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first else {
              print("Ошибка: невозможно получить доступ к каталогу рабочего стола.")
              return
          }
          
          let fileURL = desktopURL.appendingPathComponent(fileName)
          
          do {
              let historyText = items.map { "\($0.timestamp): \($0.bank)" }.joined(separator: "\n")
              try historyText.write(to: fileURL, atomically: true, encoding: .utf8)
              print("История успешно сохранена в \(fileURL.path)")
          } catch {
              print("Ошибка сохранения истории: \(error.localizedDescription)")
          }
      }
  }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: Item.self, inMemory: true)
    }
}
