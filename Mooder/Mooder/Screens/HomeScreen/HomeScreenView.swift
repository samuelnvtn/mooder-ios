// HomeScreenView.swift
import SwiftUI

struct HomeScreenView: View {
  @State private var viewModel: HomeScreenViewModel
  @EnvironmentObject var authViewModel: AuthViewModel
  @State private var shownTagName: String? = nil
  @State private var labelPosition: CGPoint? = nil

  init(viewModel: HomeScreenViewModel) {
    self._viewModel = State(initialValue: viewModel)
  }

  var body: some View {
    ScrollView {

      if viewModel.state.isMoodSavedToday {
          VStack(alignment: .leading, spacing: 16) {
              
              Text("Mood saved!")
                  .font(.title)
                  .bold()
              
              Text(viewModel.todayFormatted)
                  .foregroundColor(.gray)
              
              if let mood = viewModel.moodOptions.first(where: { $0.value == viewModel.state.selectedMood }) {
                  Text("Mood: \(mood.emoji) \(mood.label)")
              }
///*
              Text("Details:")
                  .font(.subheadline)
//TODO: NEFUNGUJE KDYZ SE PREHLASIM, STEJNY PROBLEM S COREDATA A FIREBASE SYNC ASI???
              if !viewModel.state.selectedTags.isEmpty {
                  ZStack(alignment: .topLeading) {
                      HStack(spacing: 8) {
                          Circle()
                              .fill(MoodLevel(rawValue: viewModel.state.selectedMood)?.color ?? .secondary)
                              .frame(width: 8, height: 8)
                          
                          ForEach(viewModel.state.selectedTags) { tag in
                              GeometryReader { geo in
                                  Button {
                                      shownTagName = tag.name
                                      labelPosition = geo.frame(in: .named("capsuleArea")).origin
                                      DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                          withAnimation(.easeOut(duration: 0.5)) {
                                              shownTagName = nil
                                          }
                                      }
                                  } label: {
                                      Image(systemName: tag.iconName)
                                          .frame(width: 24, height: 24)
                                          .foregroundColor(.accentColor)
                                  }
                              }
                              .frame(width: 24, height: 24)
                          }
                      }
                      .padding(.horizontal, 12)
                      .padding(.vertical, 10)
                      .background(Color(.systemGray5))
                      .clipShape(Capsule())
                      .coordinateSpace(name: "capsuleArea")
                      
                      if let tagName = shownTagName, let position = labelPosition {
                          Text(tagName)
                              .font(.caption2)
                              .padding(.horizontal, 10)
                              .padding(.vertical, 4)
                              .background(Capsule().fill(Color.accentColor.opacity(0.85)))
                              .foregroundColor(.white)
                              .position(x: position.x + 12, y: 60)
                              .transition(.opacity)
                              .animation(.easeInOut(duration: 0.3), value: shownTagName)
                      }
                  }
              } else {
                  Text("No tags selected.")
                      .foregroundColor(.gray)
                      .font(.footnote)
              }
// */
              Text("Note:")
                  .font(.subheadline)
                  .padding(.top, 10)
              
              Text(viewModel.state.note.isEmpty ? "Looks like you did not add any notes..." : viewModel.state.note)
                  .padding()
                  .background(.ultraThinMaterial)
                  .clipShape(RoundedRectangle(cornerRadius: 12))

              Spacer().frame(height: 16)
              
              Image(systemName: "sun.haze")
                  .font(.system(size: 88))
                  .frame(maxWidth: .infinity)
                  .foregroundColor(.gray)
              
              Text("Check your personalized\ntips or come back\ntomorrow!")
                  .multilineTextAlignment(.center)
                  .foregroundColor(.gray)
                  .frame(maxWidth: .infinity, alignment: .center)
              
          }
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
        
      } else {

        VStack(alignment: .leading, spacing: 16) {
          Text("How’s your day been?")
            .font(.title)
            .bold()

          Text(viewModel.todayFormatted)
            .foregroundColor(.gray)

          VStack {
            ForEach(viewModel.moodOptions, id: \.value) { mood in
              Button {
                viewModel.selectMood(mood.value)
              } label: {
                HStack {
                  Text(mood.emoji)
                  Text(mood.label)
                  Spacer()
                  if viewModel.state.selectedMood == mood.value {
                    Image(systemName: "checkmark")
                  }
                }
              }
              .padding(.vertical, 4)
            }
          }
          .padding()
          .background(.ultraThinMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 12))

          Text("Details")
            .font(.title2)
            .bold()
            .padding(.top)

          ForEach(viewModel.groupedTags, id: \.0) { (category, tags) in
            VStack(alignment: .leading) {
              Text(category)
                .font(.headline)

              // MARK: - Změny zde pro horizontální scrollování a dynamickou šířku tagů
              ScrollView(.horizontal, showsIndicators: false) {  // Horizontalní scroll
                HStack(spacing: 8) {  // Mezera mezi tagy
                  ForEach(tags) { tag in
                    Button {
                      viewModel.toggleTag(tag)
                    } label: {
                      Label(tag.name, systemImage: tag.iconName)
                        .font(.caption)  // Zmenšený font pro lepší kompaktnost
                        .padding(.horizontal, 10)  // Horizontální padding
                        .padding(.vertical, 6)  // Vertikální padding
                        .background(
                          viewModel.state.selectedTags.contains(tag)
                            ? Color.accentColor.opacity(0.2) : Color(.systemGray6)
                        )
                        .foregroundColor(
                          viewModel.state.selectedTags.contains(tag)
                            ? Color.accentColor : Color.primary
                        )  // Barva textu
                        .clipShape(Capsule())  // Zaoblený tvar
                        .lineLimit(1)  // Zabrání zalamování textu
                    }
                  }
                }
                .padding(.vertical, 4)  // Trochu vertikálního paddingu pro ScrollView
              }
            }
            .padding(.top, 8)
          }

          TextField("Note", text: Binding(
              get: { String(viewModel.state.note.prefix(200)) },
              set: { viewModel.state.note = String($0.prefix(200)) }
          ))
          .padding(12)
          .background(Color.gray.opacity(0.1))
          .cornerRadius(12)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(Color(.systemGray5), lineWidth: 1)
          )

          Button("Save") {
            viewModel.saveMood()
          }
          .buttonStyle(.borderedProminent)
          .padding(.top, 16)
        }
        .padding()
      }
    }
    .onAppear {
      viewModel.loadToday()
    }
    .onReceive(authViewModel.$moodsDidSync) { synced in
        if synced {
            print("🔁 Sync detected, reloading today's mood")
            viewModel.loadToday()
        }
    }

  }

}
