//
//  ContentView.swift
//  HabitsTracker
//
//  Created by Héctor Beristain on 28/06/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ItemList]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { itemList in
                    NavigationLink {
                        DetailView(itemList: itemList)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(itemList.title)
                                .font(.headline)
                            Text(itemList.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = ItemList(timestamp: Date(), title: "New Habit")
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    var itemList: ItemList

    @State private var newTaskTitle: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(itemList.title)
                .font(.largeTitle)
                .bold()

            Text(itemList.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                .font(.subheadline)
                .foregroundColor(.secondary)

            Divider()

            List {
                ForEach(getTasks(for: itemList)) { task in
                    HStack {
                        Button(action: {
                            toggleFinished(task: task)
                        }) {
                            Image(systemName: task.finished ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.finished ? .green : .secondary)
                        }
                        .buttonStyle(.plain)

                        Text(task.title)
                            .strikethrough(task.finished, color: .gray)
                            .foregroundColor(task.finished ? .gray : .primary)
                    }
                }
            }

            HStack {
                TextField("New Task", text: $newTaskTitle)
                    .textFieldStyle(.roundedBorder)

                Button("Add") {
                    addTask()
                }
                .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    private func getTasks(for item: ItemList) -> [TaskItem] {
        var tasks: [TaskItem] = []
        var current = item.task
        while let t = current {
            tasks.append(t)
            current = t.nextTask
        }
        return tasks
    }

    private func addTask() {
        let trimmedTitle = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        withAnimation {
            let newTask = TaskItem()
            modelContext.insert(newTask)

            if let lastTask = getTasks(for: itemList).last {
                lastTask.nextTask = newTask
            } else {
                itemList.task = newTask
            }
            newTask.nextTask = nil
            newTask.itemList = itemList

            newTaskTitle = ""
        }
    }

    private func toggleFinished(task: TaskItem) {
        withAnimation {
            task.finished.toggle()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [ItemList.self, TaskItem.self], inMemory: true)
}
